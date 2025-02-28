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

;; Use python-mode package instead of built-in python.el to avoid warnings
(use-package python
  :ensure nil  ;; Já vem com o Emacs
  :mode ("\\.py\\'" . python-mode)
  :hook (python-mode . lsp-deferred)
  :config
  ;; Define funções que estão gerando warnings
  (unless (fboundp 'python-indent)
    (defun python-indent ()
      "Indent current line as Python code."
      (interactive)
      (indent-line-to (python-indent-calculate-indentation))))
  
  (unless (fboundp 'python-info-ppss-context)
    (defun python-info-ppss-context (type &optional syntax-ppss)
      "Return non-nil if point is on TYPE using SYNTAX-PPSS.
TYPE can be 'comment, 'string or 'paren."
      (let ((ppss (or syntax-ppss (syntax-ppss))))
        (cond ((eq type 'comment)
               (nth 4 ppss))
              ((eq type 'string)
               (nth 3 ppss))
              ((eq type 'paren)
               (nth 1 ppss))
              (t nil))))))

;; Additional configuration for LSP UI (optional but recommended for better UX)
(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode)

;; Finalizes the configuration of python.el
(provide 'python)
