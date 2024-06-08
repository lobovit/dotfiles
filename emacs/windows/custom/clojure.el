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
  :after clojure-mode
  :config
  ;; Use cljfmt for formatting
  (setq cider-format-code-options '(("cljfmt" ("--config" ".cljfmt.edn"))))
  (add-hook 'cider-mode-hook #'cider-format-buffer))

;; Additional configuration for LSP (optional)
(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode)

;; Ensure `clj-refactor` is installed for better refactoring and formatting
(use-package clj-refactor
  :ensure t
  :after clojure-mode
  :config
  (add-hook 'clojure-mode-hook (lambda ()
                                 (clj-refactor-mode 1)
                                 (yas-minor-mode 1) ; for adding namespace requires
                                 (cljr-add-keybindings-with-prefix "C-c C-r"))))

;; Enable auto-closing of brackets and double quotes
(add-hook 'clojure-mode-hook
          (lambda ()
            (electric-pair-local-mode 1)))

;; Automatically format code on save
(add-hook 'clojure-mode-hook
          (lambda ()
            (add-hook 'before-save-hook #'cider-format-buffer nil 'local)))

;; If you manually installed clojure-lsp and it's not on your PATH
;; (setq lsp-clojure-server-command '("/path/to/clojure-lsp"))

;; Finalizes the configuration of clojure.el
(provide 'clojure)
