;;; lint.el --- Flycheck + ponte Eglot built-in -*- lexical-binding: t; -*-

(require 'flycheck)

;; ── Global ─────────────────────────────────────────────────────────
(add-hook 'after-init-hook #'global-flycheck-mode)

;; Diagnostico inline ao lado do codigo (estilo Error Lens)
(add-hook 'after-init-hook #'global-flycheck-annotate-mode)

;; Roteia diagnosticos do Eglot (LSP) pelo Flycheck; desliga o Flymake
;; no buffer gerido. Built-in desde Flycheck 38 — nao usar o pacote
;; antigo flycheck-eglot (clash de nomes).
(global-flycheck-eglot-mode 1)

;; ── Keybindings (C-c ! prefixo do Flycheck) ────────────────────────
;; Navegacao de erros no estilo flymake antigo (go.el usava flymake-*).
(define-key flycheck-mode-map (kbd "C-c ! n") #'flycheck-next-error)
(define-key flycheck-mode-map (kbd "C-c ! p") #'flycheck-previous-error)
(define-key flycheck-mode-map (kbd "C-c ! l") #'flycheck-list-errors)

(provide 'lint)
;;; lint.el ends here
