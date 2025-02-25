;; python.el - Configuration for Python development

;; Ensure lsp-mode is installed for LSP support
(use-package lsp-mode
  :ensure t
  :hook (python-mode . lsp-deferred)
  :commands (lsp lsp-deferred))

;; Configuration for lsp-python, using pyright or pylsp as the backend
(use-package lsp-pyright
  :ensure t
  :hook (python-mode . (lambda ()
                         (require 'lsp-pyright)
                         (lsp-deferred))) ; or lsp to start immediately
  :init
  ;; Set this to the Python interpreter you wish to use
  ;; You can also configure per-project interpreters with .dir-locals.el
  (setq lsp-pyright-python-executable-cmd "python3"))

;; Optional: Use-package for better package management
(use-package python-mode
  :ensure t
  :hook (python-mode . lsp-deferred)
  :config
  (setq python-indent-offset 4))

;; Additional configuration for LSP UI (optional but recommended for better UX)
(use-package lsp-ui
  :ensure t
  :after lsp-mode
  :commands lsp-ui-mode
  :config
  (setq lsp-ui-doc-enable t
        lsp-ui-peek-enable t
        lsp-ui-sideline-enable t))

;; Finalizes the configuration of python.el
(provide 'python)
