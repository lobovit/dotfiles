;; rust.el - Emacs configuration for Rust LSP server (rust-analyzer)

;; Ensure lsp-mode is installed
(use-package lsp-mode
  :ensure t
  :hook ((rust-mode . lsp))  ;; Enable LSP for Rust files
  :commands lsp
  :config
  ;; Customize the behavior of lsp-mode
  (setq lsp-prefer-flymake nil)  ;; Use lsp-ui instead of flymake
  (setq lsp-rust-server 'rust-analyzer))

;; Optionally, install and configure lsp-ui for better visuals
(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode)

;; Optionally, install company for autocompletion
(use-package company
  :ensure t
  :config
  (setq company-idle-delay 0.1)
  (setq company-minimum-prefix-length 1)
  :hook ((rust-mode . company-mode)))

;; Rust-mode setup
(use-package rust-mode
  :ensure t
  :mode "\\.rs\\'"
  :hook (rust-mode . lsp))

;; Keybindings for rust-mode
(use-package cargo
  :ensure t
  :hook (rust-mode . cargo-minor-mode))
