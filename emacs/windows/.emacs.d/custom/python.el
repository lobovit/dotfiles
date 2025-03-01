;;; python.el --- Configuração para desenvolvimento em Python -*- lexical-binding: t -*-

;;; Commentary:
;; Configurações específicas para desenvolvimento em Python

;;; Code:

;; Hooks específicos para Python
(add-hook 'python-mode-hook 'lsp-deferred)

;; Configurações específicas para LSP com Python
(with-eval-after-load 'lsp-mode
  ;; Adicionar configuração de ID de linguagem para Python
  (add-to-list 'lsp-language-id-configuration '(python-mode . "python"))
  
  ;; Configurações específicas para pyright
  (setq lsp-pyright-typechecking-mode "basic"
        lsp-pyright-auto-import-completions t
        lsp-pyright-auto-search-paths t))

;; Keybindings específicos para Python
(with-eval-after-load 'python-mode
  (define-key python-mode-map (kbd "C-c C-r") 'python-shell-send-region)
  (define-key python-mode-map (kbd "C-c C-b") 'python-shell-send-buffer))

(provide 'python)
;;; python.el ends here
