# Plugin Organization Guide

## Overview

This directory contains all Neovim plugin specifications organized by theme and purpose. The organization follows a hybrid approach: large or complex plugins get dedicated files, while small plugins are grouped thematically.

## Directory Structure

```
lua/plugins/
├── init.lua           # Lazy.nvim bootstrap and LazyVim framework only
├── README.md          # This file
│
├── editing.lua        # Text editing enhancements
├── ui.lua             # Visual/UI/display plugins
├── git.lua            # Git/VCS integration
├── completion.lua     # Completion engine
├── file-ops.lua       # File operations and environment
├── fuzzy.lua          # Fuzzy finding
├── testing.lua        # Testing and API tools
├── history.lua        # Terminal and undo history
├── colorscheme.lua    # Color schemes (lazy-loaded)
├── ai.lua             # AI assistants
├── treesitter.lua     # Syntax parsing
├── misc.lua           # Uncategorized utilities
│
└── lsp/               # Language server configurations
    ├── go.lua
    ├── lua.lua
    └── ...
```

## Plugin Files Explained

### init.lua (76 lines)
**Purpose**: Lazy.nvim bootstrap and core framework only
**Contents**: lazy.nvim, LazyVim
**Note**: Contains comprehensive organization guide in header

### editing.lua (~65 lines)
**Purpose**: Core text editing enhancements
**Plugins**: yanky.nvim, dial.nvim, mini.pairs
**Theme**: Small plugins that enhance fundamental editing operations

### ui.lua (~225 lines)
**Purpose**: All UI/visual/display plugins
**Plugins**: edgy.nvim, noice.nvim, mini.icons, lualine.nvim, snacks.nvim, render-markdown.nvim, flatten.nvim
**Theme**: Anything that affects visual appearance or UI layout

### git.lua (~230 lines)
**Purpose**: Git and version control integration
**Plugins**: diffview.nvim, neogit, gitsigns.nvim, hunk.nvim, lazyjj.nvim
**Theme**: All git/VCS-related functionality

### completion.lua (~137 lines)
**Purpose**: Completion engine and configuration
**Plugins**: blink.cmp
**Theme**: Dedicated file due to complexity

### file-ops.lua (~60 lines)
**Purpose**: File system operations and environment
**Plugins**: vim-eunuch, direnv.vim
**Theme**: File operations and directory environment loading

### fuzzy.lua (~20 lines)
**Purpose**: Fuzzy finding configuration
**Plugins**: fzf-lua
**Theme**: Fuzzy finding with custom keybindings

### testing.lua (~30 lines)
**Purpose**: Testing and API tools
**Plugins**: kulala.nvim
**Theme**: Room to grow with more testing tools

### history.lua (~35 lines)
**Purpose**: Terminal and undo history management
**Plugins**: terminal.nvim, vim-mundo
**Theme**: History-related utilities

### colorscheme.lua (~150 lines)
**Purpose**: Color schemes with lazy-loading
**Plugins**: tokyonight (default), 11 alternative themes
**Strategy**: Only tokyonight loads at startup. Others load on `:colorscheme` command
**Performance**: Significant startup time improvement

### ai.lua
**Purpose**: AI assistant integrations
**Theme**: AI-powered editing and coding assistance

### treesitter.lua
**Purpose**: Syntax parsing configuration
**Theme**: Treesitter and related syntax tools

### misc.lua (~25 lines)
**Purpose**: Uncategorized utilities
**Plugins**: jj-diffconflicts, vim-cedar
**Theme**: Small plugins that don't fit other categories

### lsp/
**Purpose**: Language-specific LSP configurations
**Organization**: One file per language or LSP server

## Adding New Plugins

Follow this decision tree when adding a new plugin:

### 1. Determine Size and Complexity

- **Simple (<20 lines)**: Proceed to step 2
- **Medium (20-50 lines)**: Proceed to step 2, consider dedicated file if complex
- **Large (>50 lines)**: Create dedicated file with documentation header

### 2. Check Thematic Fit

Does the plugin fit an existing theme?

- **Git/VCS-related** → `git.lua`
- **UI/visual/display** → `ui.lua`
- **Text editing enhancement** → `editing.lua`
- **Testing/API tools** → `testing.lua`
- **File operations** → `file-ops.lua`
- **Fuzzy finding** → `fuzzy.lua`
- **History (undo/terminal)** → `history.lua`
- **Color scheme** → `colorscheme.lua`
- **AI assistant** → `ai.lua`
- **Syntax/parsing** → `treesitter.lua`
- **LSP-related** → `lsp/` subdirectory
- **None of the above** → `misc.lua`

### 3. Follow Existing Patterns

When adding to any file:

1. **Read the file first** to understand its structure
2. **Add documentation header** if creating new file:
   ```lua
   --[[
   filename.lua - Brief Purpose

   Plugins:
   - plugin-name: One-line description
   - plugin-name: One-line description

   Organization rule: Why these plugins are grouped
   See: lua/plugins/init.lua for placement guidelines
   --]]
   ```
3. **Add inline comments** for non-obvious logic
4. **Include `desc` fields** for all keymaps
5. **Document workarounds** with why-comments
6. **Update this README** if creating a new category

### 4. Examples

#### Adding a Simple Plugin (Git-related)
```lua
-- Plugin: "sindrets/diffview.nvim" (15 lines)
-- Action: Add to git.lua (fits theme, small enough)
```

#### Adding a Medium Plugin (New category)
```lua
-- Plugin: "nvim-neotest/neotest" (40 lines, testing-related)
-- Action: Add to testing.lua (fits theme, room to grow)
```

#### Adding a Large Plugin (Complex config)
```lua
-- Plugin: "folke/trouble.nvim" (80 lines, complex)
-- Action: Create lua/plugins/trouble.lua (dedicated file)
```

## File Size Guidelines

After refactoring, here are the expected file sizes:

- **init.lua**: ~75 lines (was 309 lines)
- **Themed files**: 20-100 lines each
- **Specialized files**: 80-250 lines each
- **LSP files**: 50-200 lines each

If a file exceeds these ranges significantly, consider splitting it or extracting large plugin configs into dedicated files.

## Maintenance Tips

1. **Keep init.lua minimal**: Only lazy.nvim and LazyVim belong there
2. **Group by theme, not by size**: A 10-line git plugin belongs in git.lua, not misc.lua
3. **Extract when it hurts**: If you can't scan a file in one screen, consider extracting large configs
4. **Document your decisions**: Add comments explaining non-obvious choices
5. **Update this README**: When adding new categories or patterns

## Benefits of This Organization

✅ **Easy to find**: Clear theme-based grouping
✅ **Scannable files**: Max ~250 lines for specialized files
✅ **Clear placement rules**: Decision tree for new plugins
✅ **Reduced cognitive load**: Logical grouping with documentation
✅ **Performance**: Colorscheme lazy-loading saves startup time
✅ **Maintainable**: Balance between splitting and consolidation
