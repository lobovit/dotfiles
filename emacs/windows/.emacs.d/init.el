;;; init.el --- Configuracao Emacs Solo (100% built-in) -*- lexical-binding: t; -*-

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

;; ── Package system (built-in, GNU ELPA only) ──────────────────────
(require 'package)
(add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/"))
(setq package-install-upgrade-built-in t)
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))
(dolist (p '(consult vertico orderless))
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
(my/load "tools/git")
(my/load "tools/eshell")

(my/load "leader")

(provide 'init)
;;; init.el ends here
