;; clisp.el - Configuration for Common Lisp and LSP

;; Ensure `lsp-mode` is installed
(use-package lsp-mode
  :ensure t
  :hook (lisp-mode . lsp)
  :commands lsp)

;; Use-package for better package management
(use-package lisp-mode
  :ensure t
  :after lsp-mode
  :hook ((lisp-mode . lsp)
         (slime-mode . lsp)))

;; Optional: for better REPL integration
(use-package slime
  :ensure t
  :after lisp-mode
  :config
  (setq inferior-lisp-program "sbcl"))

;; Additional configuration for LSP (optional)
(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode)

;; If you manually installed cl-lsp and it's not on your PATH
;; (setq lsp-cl-lisp-server-command '("/path/to/cl-lsp"))

;; Finalizes the configuration of clisp.el
(provide 'clisp)
