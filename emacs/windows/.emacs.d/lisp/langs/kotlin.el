;; kotlin.el --- Kotlin com kotlin-ts-mode (MELPA) + kotlin-lsp -*- lexical-binding: t; -*-

;; ── Indentacao (padrao Kotlin: 4 espacos, sem tabs) ────────────────
(defun my/kotlin-mode-hook ()
  "Configure Kotlin buffers: indent 4 spaces, no tabs."
  (setq-local indent-tabs-mode nil
              tab-width 4
              standard-indent 4))

(add-hook 'kotlin-ts-mode-hook #'my/kotlin-mode-hook)

;; ── Auto-mode (.kt) caso o registro em treesitter.el nao occurra ───
;;;###autoload
(add-to-list 'auto-mode-alist '("\\.kt\\'" . kotlin-ts-mode))

;; ── Eglot + kotlin-lsp (JetBrains, standalone em D:\softwares) ─────
(defvar my/kotlin-lsp-command
  (let ((exe (expand-file-name "bin/intellij-server.exe" "D:/softwares/kotlin-lsp")))
    (if (file-exists-p exe) exe "intellij-server"))
  "Comando do Kotlin Language Server (intellij-server.exe).")

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               `(kotlin-ts-mode . (,my/kotlin-lsp-command))))

(add-hook 'kotlin-ts-mode-hook #'eglot-ensure)

(provide 'kotlin)
;;; kotlin.el ends here
