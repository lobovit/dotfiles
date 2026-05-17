;;; init.el --- Configuracao pessoal do Emacs -*- lexical-binding: t; -*-

;;; Commentary:

;; Configuracao pessoal do Emacs -- modular, com vertico, tree-sitter,
;; leader key (M-SPC), e tooling moderno.

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

;; ── Package Management ─────────────────────────────────────────────
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("gnu" . "https://elpa.gnu.org/packages/")
                         ("nongnu" . "https://elpa.nongnu.org/nongnu/")))

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; ── Load Modules ───────────────────────────────────────────────────
(defvar my/lisp-dir (expand-file-name "lisp" user-emacs-directory))

(defun my/load (file)
  "Load a config FILE from lisp/ directory."
  (load (expand-file-name file my/lisp-dir) nil 'nomessage))

(my/load "editor")
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
(my/load "tools/ai")
(my/load "tools/eshell")
(my/load "leader")

;; ── Custom Variables ───────────────────────────────────────────────
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(browse-url-browser-function 'browse-url-firefox)
 '(package-selected-packages nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(provide 'init)
;;; init.el ends here
