;; Ensure use-package is available
(require 'use-package)

;; Basic settings for shell script editing
(defun my-shell-mode-setup ()
  "Custom setup for shell-mode (shell scripts)."
  (setq sh-basic-offset 2) ;; Set indentation offset to 2 spaces
  (setq sh-indentation 2)  ;; Indentation level for shell scripts
  (setq tab-width 2)       ;; Display tabs as 2 spaces
  ;; Enable electric-pair-mode for automatic closing of quotes and brackets
  (electric-pair-mode 1))

;; Add the setup function to sh-mode-hook
(add-hook 'sh-mode-hook 'my-shell-mode-setup)

;; lsp-mode configuration for shell scripts
(use-package lsp-mode
  :ensure t
  :commands (lsp lsp-deferred)
  :hook (sh-mode . lsp-deferred) ;; Automatically start lsp-mode in sh-mode
  :config
  ;; Additional lsp-mode configurations can go here
  (setq lsp-prefer-flymake nil)) ;; Prefer lsp-ui (flycheck) over flymake if available

;; Optional: lsp-ui for enhanced UI elements like pop-up documentation
(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode
  :config
  (setq lsp-ui-doc-enable t
        lsp-ui-doc-position 'top
        lsp-ui-doc-include-signature t
        lsp-ui-sideline-enable nil))

;; Install and configure bash-language-server for lsp-mode
;; Ensure you have bash-language-server installed on your system:
;; npm i -g bash-language-server
;; This provides LSP features like auto-completion and hover documentation for shell scripts.
