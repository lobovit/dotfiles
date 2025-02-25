;;; clisp.el --- Configuration for Common Lisp -*- lexical-binding: t -*-

;;; Commentary:
;; Common Lisp development environment setup

;;; Code:

;; Basic lisp mode configuration (built-in)
(add-hook 'lisp-mode-hook #'show-paren-mode)
(add-hook 'lisp-mode-hook #'lsp-deferred)

;; Flycheck for syntax checking
(use-package flycheck
  :ensure t
  :init
  (global-flycheck-mode 1))

;; SLIME configuration
(use-package slime
  :ensure t
  :init
  (setq inferior-lisp-program "sbcl")
  :config
  (slime-setup '(slime-fancy slime-company))
  :hook (lisp-mode . slime-mode))

;; Company backend for SLIME
(use-package slime-company
  :ensure t
  :after (slime company)
  :config
  (setq slime-company-completion 'fuzzy))

;; LSP configuration for Common Lisp
(use-package lsp-mode
  :ensure t
  :hook (lisp-mode . lsp-deferred)
  :commands (lsp lsp-deferred)
  :config
  (setq lsp-enable-symbol-highlighting t
        lsp-enable-indentation t
        lsp-enable-on-type-formatting t))

;; LSP UI configuration
(use-package lsp-ui
  :ensure t
  :after lsp-mode
  :commands lsp-ui-mode
  :custom
  (lsp-ui-doc-enable t)
  (lsp-ui-peek-enable t)
  (lsp-ui-sideline-enable t))

;; If cl-lsp is not in PATH, uncomment and set the path:
;; (setq lsp-cl-lisp-server-command '("/path/to/cl-lsp"))

(provide 'clisp)
;;; clisp.el ends here
