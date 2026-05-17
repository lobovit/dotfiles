;;; csharp.el --- C# e .NET: omnisharp, eglot -*- lexical-binding: t; -*-

(use-package csharp-mode
  :mode "\\.cs\\'"
  :config
  (setq-default c-basic-offset 4)
  (defun my/csharp-save-hook ()
    (when (eglot-managed-p)
      (eglot-format-buffer)
      (eglot-code-actions (point-min) (point-max))))
  (dolist (hook '(csharp-mode-hook csharp-ts-mode-hook))
    (add-hook hook
              (lambda ()
                (add-hook 'before-save-hook #'my/csharp-save-hook nil t)))))

(use-package nxml-mode
  :ensure nil
  :config
  (setq nxml-child-indent 4
        nxml-attribute-indent 4
        nxml-slash-auto-complete t))

(add-to-list 'auto-mode-alist '("\\.crproj\\'" . nxml-mode))
(add-to-list 'auto-mode-alist '("\\.csproj\\'" . nxml-mode))
(add-to-list 'auto-mode-alist '("\\.sln\\'" . text-mode))

(provide 'csharp)
;;; csharp.el ends here
