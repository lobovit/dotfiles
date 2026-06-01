;;; csharp.el --- C# com csharp-ts-mode (built-in) e eglot -*- lexical-binding: t; -*-

(defun my/csharp-save-hook ()
  "Format C# buffer before save."
  (when (eglot-managed-p)
    (eglot-format-buffer)))

(add-hook 'csharp-ts-mode-hook
          (lambda ()
            (setq-local c-basic-offset 4)
            (setq-local tab-width 4)
            (add-hook 'before-save-hook #'my/csharp-save-hook nil t)))

;; ── Eglot ──────────────────────────────────────────────────────────
(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '(csharp-ts-mode . ("OmniSharp.exe" "-lsp"))))

(add-hook 'csharp-ts-mode-hook #'eglot-ensure)

;; ── Project files ──────────────────────────────────────────────────
(add-to-list 'auto-mode-alist '("\\.csproj\\'" . nxml-mode))
(add-to-list 'auto-mode-alist '("\\.crproj\\'" . nxml-mode))
(add-to-list 'auto-mode-alist '("\\.sln\\'" . text-mode))

(provide 'csharp)
;;; csharp.el ends here
