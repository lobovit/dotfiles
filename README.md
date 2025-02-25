# dotfiles

My personal config files (emacs, freebsd, linux etc..)


# Emacs Configuration 

This repository contains my personal configuration files for Emacs, FreeBSD, Linux, and more. Below is a comprehensive cheatsheet for the Emacs keybindings configured in this setup.

## General Keybindings

| Keybinding | Description |
|------------|-------------|
| `C-c C-c` | Comment or uncomment selected region |
| `F5` | Toggle Treemacs file explorer |
| `C-=` | Expand region (incrementally select larger semantic units) |

## Navigation & Search

| Keybinding | Description |
|------------|-------------|
| `M-x` | Execute command (using Helm) |
| `C-x C-f` | Find files (using Helm) |
| `C-x b` | Switch buffer (using Helm mini) |
| `C-s` | Interactive search (using Helm occur) |
| `C-c s` | Search using Ripgrep |

## Project Management (Projectile)

| Keybinding | Description |
|------------|-------------|
| `C-c p` | Projectile command prefix |
| `C-c p f` | Find file in project |
| `C-c p p` | Switch project |
| `C-c p s r` | Search in project with Ripgrep |
| `C-c p k` | Kill project buffers |
| `C-c p i` | Invalidate project cache |

## Git Integration (Magit)

| Keybinding | Description |
|------------|-------------|
| `C-x g` | Magit status |
| `C-x M-g` | Magit dispatch menu |

## Multiple Cursors

| Keybinding | Description |
|------------|-------------|
| `C-S-c C-S-c` | Edit lines with multiple cursors |
| `C->` | Mark next occurrence like this |
| `C-<` | Mark previous occurrence like this |
| `C-c C-<` | Mark all occurrences like this |

## LSP Mode

| Keybinding | Description |
|------------|-------------|
| `C-c l` | LSP command prefix |
| `C-c l r` | Rename symbol |
| `C-c l d` | Find definition |
| `C-c l a` | Execute code action |

## Code Completion

| Keybinding | Description |
|------------|-------------|
| `C-<tab>` | Trigger company completion |
| `M-/` | Complete (configured in language-specific files) |

## Code Navigation

| Keybinding | Description |
|------------|-------------|
| `M-g j` | Jump to definition (using Dumb Jump) |
| `M-g b` | Jump back (using Dumb Jump) |
| `M-.` | Find definition (in LSP-enabled modes) |
| `M-?` | Find references (in LSP-enabled modes) |

## Language-Specific Features

### C/C++
- `C-c c` - Set up compilation command for C files
- LSP integration with clangd/ccls
- Flycheck for syntax checking
- Project creation with `create-c-project`

### Go
- Auto-formatting on save
- Import management with goimports
- LSP integration with gopls
- Struct manipulation with go-fill-struct and go-add-tags

### Python
- LSP integration with pyright
- Auto-completion and documentation
- Syntax checking with Flycheck

### Java
- LSP integration with Eclipse JDT
- Debugging support with DAP mode
- Spring Boot project creation with `java/spring-initializer`

### Clojure
- CIDER integration for REPL-driven development
- LSP support with clojure-lsp
- Paredit for structural editing

### Rust
- LSP integration with rust-analyzer
- Cargo commands integration
- Auto-formatting on save

### Common Lisp
- SLIME integration for REPL interaction
- LSP support
- Paredit for structural editing

### Shell/Bash
- LSP integration with bash-language-server
- Syntax checking with shellcheck

### Web Development
- HTML/CSS/JS/JSX/TSX support with web-mode
- Emmet for HTML expansion
- CSS color preview with rainbow-mode

## Miscellaneous

| Keybinding | Description |
|------------|-------------|
| `C-c r` | Quick run current file |
| `y/n` | Simplified yes/no prompts (instead of typing "yes" or "no") |

## UI Customization

- Minimal UI with toolbar, scrollbar, tooltip, and menu bar disabled
- Line numbers enabled globally
- Font set to Consolas, size 152, bold weight
- Custom theme configured in custom.el

---

This configuration uses a modular approach with language-specific settings in separate files under the `custom/` directory. The main configuration is in `init.el` with custom variables stored in `custom.el`.
