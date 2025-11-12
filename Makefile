.PHONY: help lint lint-hook

# Variables
LUA_LS := $(HOME)/.local/share/nvim/mason/bin/lua-language-server
LUARC := .luarc.json
LUA_DIRS := lua pack/plugins/start/luasnp

# Colors
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[0;33m
BLUE := \033[0;34m
NC := \033[0m # No Color

help: ## Show this help message
	@printf "$(BLUE)Available targets:$(NC)\n"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(GREEN)%-15s$(NC) %s\n", $$1, $$2}'

lint: ## Run full lint check on all Lua files
	@printf "$(BLUE)Running lua-language-server lint check...$(NC)\n"
	@if [ ! -x "$(LUA_LS)" ]; then \
		printf "$(RED)Error: lua-language-server not found at $(LUA_LS)$(NC)\n"; \
		exit 1; \
	fi
	@NVIM_RUNTIME=$$(nvim --headless +"lua print(vim.fn.fnamemodify(vim.api.nvim_get_runtime_file('lua/vim/_meta.lua', false)[1], ':h:h'))" +quit 2>&1); \
	TEMP_CONFIG=$$(mktemp); \
	jq --arg runtime "$$NVIM_RUNTIME" '.workspace.library += [$$runtime]' "$(LUARC)" > "$$TEMP_CONFIG"; \
	EXIT_CODE=0; \
	for dir in $(LUA_DIRS); do \
		if [ -d "$$dir" ]; then \
			printf "$(YELLOW)Checking $$dir/...$(NC)\n"; \
			OUTPUT=$$("$(LUA_LS)" --configpath="$$TEMP_CONFIG" --check "$$dir" --checklevel=Warning 2>&1 | \
				grep -v "^Initializing" | grep -v "^>>>>" | grep -v "^Diagnosis complete"); \
			if [ -n "$$OUTPUT" ]; then \
				echo "$$OUTPUT"; \
				EXIT_CODE=1; \
			fi; \
		fi; \
	done; \
	rm -f "$$TEMP_CONFIG"; \
	if [ $$EXIT_CODE -eq 0 ]; then \
		printf "$(GREEN)✓ No lint errors found$(NC)\n"; \
	else \
		printf "$(RED)✗ Lint errors found (see above)$(NC)\n"; \
	fi; \
	exit $$EXIT_CODE

lint-hook: ## Simulate hook check on a specific file (usage: make lint-hook FILE=path/to/file.lua)
	@if [ -z "$(FILE)" ]; then \
		printf "$(RED)Error: FILE parameter required$(NC)\n"; \
		echo "Usage: make lint-hook FILE=path/to/file.lua"; \
		exit 1; \
	fi
	@if [ ! -f "$(FILE)" ]; then \
		printf "$(RED)Error: File $(FILE) not found$(NC)\n"; \
		exit 1; \
	fi
	@if [ ! -x "$(LUA_LS)" ]; then \
		printf "$(RED)Error: lua-language-server not found at $(LUA_LS)$(NC)\n"; \
		exit 1; \
	fi
	@printf "$(BLUE)Linting $(FILE)...$(NC)\n"
	@NVIM_RUNTIME=$$(nvim --headless +"lua print(vim.fn.fnamemodify(vim.api.nvim_get_runtime_file('lua/vim/_meta.lua', false)[1], ':h:h'))" +quit 2>&1); \
	TEMP_CONFIG=$$(mktemp); \
	jq --arg runtime "$$NVIM_RUNTIME" '.workspace.library += [$$runtime]' "$(LUARC)" > "$$TEMP_CONFIG"; \
	"$(LUA_LS)" --configpath="$$TEMP_CONFIG" --check "$$(dirname "$(FILE)")" --checklevel=Warning 2>&1 | \
		grep -E "$$(basename "$(FILE)")|Warning|Error" | \
		grep -v "^Initializing" | \
		grep -v "^>>>>" | \
		head -20 || printf "$(GREEN)✓ No errors in $(FILE)$(NC)\n"; \
	rm -f "$$TEMP_CONFIG"
