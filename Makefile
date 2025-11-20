.PHONY: help lua-lint lua-lint-hook

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

lua-lint: ## Run full lua-language-server lint across tracked Lua directories
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

lua-lint-hook: ## Lint one or more Lua files (usage: make lua-lint-hook FILES="a.lua b.lua")
	@FILES_LIST="$(strip $(FILES))"; \
	if [ -z "$$FILES_LIST" ]; then FILES_LIST="$(strip $(FILE))"; fi; \
	if [ -z "$$FILES_LIST" ]; then \
		printf "$(RED)Error: FILES parameter required$(NC)\n"; \
		echo "Usage: make lua-lint-hook FILES=\"path/one.lua path/two.lua\""; \
		exit 1; \
	fi; \
	for f in $$FILES_LIST; do \
		if [ ! -f "$$f" ]; then \
			printf "$(RED)Error: File $$f not found$(NC)\n"; \
			exit 1; \
		fi; \
	done; \
	if [ ! -x "$(LUA_LS)" ]; then \
		printf "$(RED)Error: lua-language-server not found at $(LUA_LS)$(NC)\n"; \
		exit 1; \
	fi; \
	printf "$(BLUE)Linting $$FILES_LIST...$(NC)\n"; \
	NVIM_RUNTIME=$$(nvim --headless +"lua print(vim.fn.fnamemodify(vim.api.nvim_get_runtime_file('lua/vim/_meta.lua', false)[1], ':h:h'))" +quit 2>&1); \
	TEMP_CONFIG=$$(mktemp); \
	jq --arg runtime "$$NVIM_RUNTIME" '.workspace.library += [$$runtime]' "$(LUARC)" > "$$TEMP_CONFIG"; \
	EXIT_CODE=0; \
	for f in $$FILES_LIST; do \
		DIR=$$(dirname "$$f"); \
		BASE=$$(basename "$$f"); \
		OUTPUT=$$("$(LUA_LS)" --configpath="$$TEMP_CONFIG" --check "$$DIR" --checklevel=Warning 2>&1 | \
			grep -E "$$BASE|Warning|Error" | \
			grep -v "^Initializing" | \
			grep -v "^>>>>" | \
			head -20); \
		if [ -n "$$OUTPUT" ]; then \
			echo "$$OUTPUT"; \
			EXIT_CODE=1; \
		else \
			printf "$(GREEN)✓ No errors in $$f$(NC)\n"; \
		fi; \
	done; \
	rm -f "$$TEMP_CONFIG"; \
	exit $$EXIT_CODE
