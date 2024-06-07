;; clojure.el - Configuration for Clojure and LSP

;; Ensure `lsp-mode` is installed
(use-package lsp-mode
  :ensure t
  :hook (clojure-mode . lsp)
  :commands lsp)

;; Use-package for better package management
(use-package clojure-mode
  :ensure t
  :after lsp-mode
  :hook ((clojure-mode . lsp)
         (clojurec-mode . lsp)
         (clojurescript-mode . lsp)))

;; Optional: for better REPL integration
(use-package cider
  :ensure t
  :after clojure-mode)

;; Additional configuration for LSP (optional)
(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode)

;; If you manually installed clojure-lsp and it's not on your PATH
;; (setq lsp-clojure-server-command '("/path/to/clojure-lsp"))

;; Finalizes the configuration of clojure.el
(provide 'clojure)
