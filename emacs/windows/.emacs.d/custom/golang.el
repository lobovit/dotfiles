;; Ensure use-package is available
(require 'use-package)

;; LSP Mode for Golang
(use-package lsp-mode
  :ensure t
  :commands (lsp lsp-deferred)
  :hook (go-mode . lsp-deferred) ;; Automatically start lsp-mode with Go files
  :config
  ;; Set specific LSP configurations for Golang development
  (setq lsp-prefer-flymake nil) ;; Prefer using lsp-ui (flycheck) over flymake
  (setq lsp-gopls-staticcheck t) ;; Enable staticcheck for extra analysis
  (setq lsp-gopls-complete-unimported t)) ;; Auto-complete even unimported packages

;; Additional LSP UI improvements
(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode
  :config
  (setq lsp-ui-doc-enable t
        lsp-ui-doc-position 'top
        lsp-ui-sideline-enable false)) ;; Configure as needed

;; Company mode for autocompletion
(use-package company
  :ensure t
  :config
  (global-company-mode)
  (setq company-minimum-prefix-length 1
        company-idle-delay 0.0)) ;; Immediate suggestions

;; Go specific settings
(defun my-go-mode-setup ()
  "Custom Go mode settings."
  ;; Use goimports for formatting if available, otherwise gofmt
  (setq gofmt-command "goimports")
  (add-hook 'before-save-hook 'gofmt-before-save) ;; Format before saving

  ;; Set tab width for Go files (Go uses tabs)
  (setq tab-width 4))

(add-hook 'go-mode-hook 'my-go-mode-setup)

;; Optional: Use go-fill-struct and go-add-tags for struct manipulation
(use-package go-fill-struct
  :ensure t)

(use-package go-add-tags
  :ensure t)

;; Ensure the Go language server is installed for LSP:
;; Run 'go install golang.org/x/tools/gopls@latest' in your terminal.
