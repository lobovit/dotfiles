# AGENTS.md

Emacs configuration — mostly built-in code with GNU ELPA + MELPA packages
(`consult`, `vertico`, `orderless`, `request`, `org-modern`) and vendored
`company-mode` in `lisp/`. See `init.el` for the load order.

## Structure

- `init.el` — entrypoint; installs GNU ELPA packages, then loads modules via `(my/load "...")` from `lisp/`
- `lisp/` — all configuration, grouped by concern:
  - `editor.el`, `ui.el`, `completion.el`, `windows.el`, `leader.el`, `treesitter.el`, `dashboard.el`
  - `langs/` — per-language config (go, ts, csharp, markdown, docker, org)
  - `tools/` — git, eshell, ghostel
  - `ace-window.el`, `hl-todo.el`, `vc-gutter.el`, `dashboard.el` — custom implementations replacing popular packages
  - `company.el`, `company-capf.el`, `company-dabbrev.el`, `company-dabbrev-code.el` — vendored company-mode
  - `opencode/` — subproject: Emacs client for OpenCode (see `lisp/opencode/AGENTS.md`)

## Key Conventions

- **Requires**: built-ins first (`cl-lib`, `subr-x`, `project`, `treesit`, `eglot`, `url`, `vc`), then project modules, then external packages (GNU ELPA: `consult`, `vertico`, `orderless`; MELPA: `request`, `org-modern`).
- `;; -*- lexical-binding: t; -*-` in every `.el` file.
- Standard file header, `(provide '...)`, and `;;; <file>.el ends here` trailer.
- 2-space indentation (Emacs Lisp default). Lines wrap around 80–100 cols.
- Private helpers prefix with `my/` (e.g., `my/load`, `my/ace-window`). Minor mode and public-facing symbols use descriptive names like `vc-gutter-mode`.
- Docstrings for all public-facing defuns, defcustoms, defvars. First sentence ends with period. Args in ALL CAPS.

## External Packages

| Package     | Source   | Purpose |
|---|---|---|---|
| `vertico`   | GNU ELPA | Minibuffer vertical completion UI |
| `orderless` | GNU ELPA | Flexible space-separated matching |
| `consult`   | GNU ELPA | Enhanced commands (buffer, ripgrep, line, imenu, goto-line, bookmark) |
| `request`   | MELPA    | HTTP client library (required by `emacs-opencode`) |
| `org-modern`| MELPA    | Modern styling for Org mode buffers |
| `ghostel`   | MELPA    | Native terminal emulator (libghostty-vt); auto-downloads `ghostel-module.dll` on first use |

## Custom Implementations (replacing popular packages)

| Replaced package  | Replacement file / approach |
|---|---|
| `magit`           | `lisp/tools/git.el` — built-in `vc` (vc-dir, vc-print-log, vc-annotate, vc-git-stash) |
| `avy`             | `lisp/ace-window.el` — custom window chooser |
| `dirvish` / `ranger` | Dired with `dired-hide-details-mode`, `dired-dwim-target` |
| `yasnippet`       | Built-in abbrev + skeleton |
| `multiple-cursors`| Built-in kmacro |
| `which-key`       | Built-in `which-key-mode` (Emacs 30+) |
| `diff-hl`         | `lisp/vc-gutter.el` — fringe overlay |
| `projectile`      | Built-in `project.el` with `vc` backend + extra root markers (`go.mod`, `.project`) |
| `hl-todo`         | `lisp/hl-todo.el` — font-lock keywords |
| `dashboard`       | `lisp/dashboard.el` — custom startup buffer (logo + shortcuts); `initial-buffer-choice` is set to it |

## Testing / Verification

No test framework. To check a `.el` file for errors:

```sh
emacs -Q -L lisp -batch -f batch-byte-compile lisp/<module>.el
```

For the full config: `emacs --batch --eval '(load "~/.emacs.d/init.el")'`.

## Tree-Sitter Grammars

Defined in `lisp/treesitter.el` (`my/treesit-langs`). After a fresh Emacs install,
run `M-x my/treesit-install-grammars` to download and compile all grammars.

## Leader Keybindings

Leader is `M-SPC` (defined in `lisp/leader.el`):
- `.` find-file, `,` consult-buffer, `f f` find-file, `f r` recentf
- `b b` / `b s` / `b .` consult-buffer, `b r` consult-buffer-other-window, `b p` previous-buffer, `b n` next-buffer, `b k` kill-current-buffer
- `/` consult-ripgrep, `s r` consult-ripgrep, `s l` consult-line, `s i` consult-imenu
- `w /` split-right, `w -` split-below, `w d` delete-window, `w o` delete-other-windows; `w <dir>` buf-move
- `g g` vc-dir, `g l` vc-log-toggle, `g b` vc-blame, `g s` / `g S` stash/pop, `g ,` / `g .` goto-last-change
- `p p` project-switch-project, `p f` project-find-file
- `<tab>` workspace layout (dired + code + eshell)
- `d` dired, `'` / `e` eshell-toggle, `E` eval-buffer, `T` ghostel
- `t d` dired-sidebar toggle, `t l` / `t n` line-numbers toggle
- `j` ace-window, `l` consult-goto-line
- `m m/e/x` kmacro start/end/call
- `n` consult-bookmark
- `h f/v/k/d` describe-function/variable/key/local-help
- `a s` opencode, `a a` opencode-ask, `a c` opencode-ask-contextual, `a o` opencode-open-session

## OpenCode Subproject (`lisp/opencode/`)

The `emacs-opencode` client lives as a subproject with its own AGENTS.md, tests,
and conventions. The parent `init.el` installs its dependency (`request` from
MELPA) and loads it via:

```elisp
(add-to-list 'load-path (expand-file-name "lisp/opencode" user-emacs-directory))
(require 'emacs-opencode)
```

- **`request`** is installed by the parent `init.el` via `package.el` into
  `~/.emacs.d/elpa/request-<version>/`.
- Tests use ERT. See `lisp/opencode/AGENTS.md` for test commands and code
  style specific to that subproject.
- The opencode server uses a separate config file:
  `~/.config/opencode/opencode.emacs.jsonc` (set via `opencode-server-environment`
  in `init.el`).
