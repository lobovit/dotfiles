;;; init.el --- Configuracao Emacs Solo (OpenBSD) -*- lexical-binding: t; -*-

;;; Commentary:
;; Configuracao pessoal do Emacs seguindo a filosofia Emacs Solo:
;; zero pacotes externos. Tudo built-in ou codigo proprio em lisp/.

;;; Code:

;; ── Performance ────────────────────────────────────────────────────
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold 80000000
                  gc-cons-percentage 0.1)))

;; ── Encoding ───────────────────────────────────────────────────────
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-file-name-coding-system 'utf-8-unix)
(modify-coding-system-alist 'process "*" 'utf-8)

;; ── Package system (GNU ELPA + MELPA for opencode deps) ────────────
(require 'package)
(add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(setq package-install-upgrade-built-in t)
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))
(dolist (p '(consult vertico orderless request org-modern))
  (unless (package-installed-p p)
    (package-install p)))

;; ── Load Modules ───────────────────────────────────────────────────
(defvar my/lisp-dir (expand-file-name "lisp" user-emacs-directory))

(defun my/load (file)
  "Load a config FILE from lisp/ directory."
  (load (expand-file-name file my/lisp-dir) nil 'nomessage))

(require 'consult)
(setq consult-ripgrep-args
      "rg --null --color=never --no-heading --line-number --smart-case --max-columns=1000")
(add-hook 'completion-list-mode-hook #'consult-preview-at-point-mode)

(require 'vertico)
(require 'orderless)

;; ── OpenCode (Emacs client) ────────────────────────────────────────
(add-to-list 'load-path (expand-file-name "lisp/opencode" user-emacs-directory))
(require 'emacs-opencode)
(setq opencode-server-environment
      `(("OPENCODE_CONFIG" . ,(expand-file-name "~/.config/opencode/opencode.emacs.jsonc"))))

(my/load "editor")
(my/load "ace-window")
(my/load "hl-todo")
(my/load "ui")
(my/load "completion")
(my/load "windows")
(my/load "treesitter")
(my/load "langs/go")
(my/load "langs/ts")
(my/load "langs/csharp")
(my/load "langs/markdown")
(my/load "langs/docker")
(my/load "langs/org")
(my/load "tools/git")
(my/load "tools/eshell")

;; ── AI Tools (OpenBSD-specific) ────────────────────────────────────
(unless (null (file-exists-p (expand-file-name "tools/ai" my/lisp-dir)))
  (my/load "tools/ai"))

(my/load "leader")

(provide 'init)
;;; init.el ends here

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(change-log-acknowledgment ((((class color) (min-colors 256)) :foreground "#b4befe")))
 '(change-log-date ((((class color) (min-colors 256)) :foreground "#a6e3a1")))
 '(change-log-name ((((class color) (min-colors 256)) :foreground "#fab387")))
 '(diff-context ((((class color) (min-colors 256)) :foreground "#89b4fa")))
 '(diff-file-header ((((class color) (min-colors 256)) :foreground "#f5c2e7")))
 '(diff-header ((((class color) (min-colors 256)) :foreground "#89b4fa")))
 '(diff-hunk-header ((((class color) (min-colors 256)) :foreground "#fab387")))
 '(gnus-button ((((class color) (min-colors 256)) :foreground "#8aadf4")))
 '(gnus-group-mail-3 ((((class color) (min-colors 256)) :foreground "#8aadf4")))
 '(gnus-group-mail-3-empty ((((class color) (min-colors 256)) :foreground "#8aadf4")))
 '(gnus-header-content ((((class color) (min-colors 256)) :foreground "#7dc4e4")))
 '(gnus-header-from ((((class color) (min-colors 256)) :foreground "#cba6f7")))
 '(gnus-header-name ((((class color) (min-colors 256)) :foreground "#a6e3a1")))
 '(gnus-header-subject ((((class color) (min-colors 256)) :foreground "#8aadf4")))
 '(log-view-message ((((class color) (min-colors 256)) :foreground "#b4befe")))
 '(match ((((class color) (min-colors 256)) :background "#3e5768" :foreground "#cdd6f5")))
 '(modus-themes-search-current ((((class color) (min-colors 256)) :background "#f38ba8" :foreground "#11111b")) t)
 '(modus-themes-search-lazy ((((class color) (min-colors 256)) :background "#3e5768" :foreground "#cdd6f5")) t)
 '(newsticker-extra-face ((((class color) (min-colors 256)) :foreground "#9399b2" :height 0.8 :slant italic)))
 '(newsticker-feed-face ((((class color) (min-colors 256)) :foreground "#f38ba8" :height 1.2 :weight bold)))
 '(newsticker-treeview-face ((((class color) (min-colors 256)) :foreground "#cdd6f4")))
 '(newsticker-treeview-selection-face ((((class color) (min-colors 256)) :background "#3e5768" :foreground "#cdd6f5")))
 '(tab-bar ((((class color) (min-colors 256)) :background "#1e1e2e" :foreground "#bac2de")))
 '(tab-bar-tab ((((class color) (min-colors 256)) :background "#1e1e2e" :underline t)))
 '(tab-bar-tab-group-current ((((class color) (min-colors 256)) :background "#1e1e2e" :foreground "#bac2de" :underline t)))
 '(tab-bar-tab-group-inactive ((((class color) (min-colors 256)) :background "#1e1e2e" :foreground "#9399b2")))
 '(tab-bar-tab-inactive ((((class color) (min-colors 256)) :background "#1e1e2e" :foreground "#a6adc8")))
 '(vc-dir-file ((((class color) (min-colors 256)) :foreground "#89b4fa")))
 '(vc-dir-header-value ((((class color) (min-colors 256)) :foreground "#b4befe"))))
