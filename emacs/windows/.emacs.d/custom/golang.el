;;; golang.el --- Configuração para desenvolvimento em Go -*- lexical-binding: t -*-

;;; Commentary:
;; Configurações específicas para desenvolvimento em Go

;;; Code:

;; Definir variável 'error' para evitar warning de variável livre
(defvar error nil "Variável para evitar warning de variável livre.")

;; Hooks específicos para Go
(add-hook 'go-mode-hook 'lsp-deferred)

;; Configurações específicas para Go
(defun my-go-mode-setup ()
  "Custom Go mode settings."
  ;; Configurar indentação para Go
  (setq tab-width 4)
  ;; Configurar formatação automática
  (setq gofmt-command "goimports")
  (add-hook 'before-save-hook 'gofmt-before-save nil t))

(add-hook 'go-mode-hook 'my-go-mode-setup)

;; Configurações específicas para LSP com Go
(with-eval-after-load 'lsp-mode
  ;; Adicionar configuração de ID de linguagem para Go
  (add-to-list 'lsp-language-id-configuration '(go-mode . "go"))
  
  ;; Configurações específicas para gopls
  (setq lsp-gopls-staticcheck t
        lsp-gopls-complete-unimported t))

;; Keybindings específicos para Go
(with-eval-after-load 'go-mode
  (define-key go-mode-map (kbd "C-c C-f") 'go-fill-struct)
  (define-key go-mode-map (kbd "C-c C-t") 'go-add-tags))

;; Lidar com funções obsoletas
(with-eval-after-load 'go-mode
  ;; Substituir a função obsoleta go-guess-gopath
  (defun my-go-guess-gopath ()
    "Substituição para go-guess-gopath que foi descontinuada."
    (warn "GOPATH foi descontinuado em favor dos módulos Go"))
  
  ;; Definir funções que podem não estar disponíveis
  (unless (fboundp 'lsp-rename)
    (defun lsp-rename ()
      "Stub para lsp-rename quando não disponível."
      (interactive)
      (message "lsp-rename não está disponível")))
  
  (unless (fboundp 'eglot-rename)
    (defun eglot-rename ()
      "Stub para eglot-rename quando não disponível."
      (interactive)
      (message "eglot-rename não está disponível")))
  
  (unless (fboundp 'lsp-execute-code-action-by-kind)
    (defun lsp-execute-code-action-by-kind (kind)
      "Stub para lsp-execute-code-action-by-kind quando não disponível."
      (message "lsp-execute-code-action-by-kind não está disponível")))
  
  (unless (fboundp 'eglot-code-actions)
    (defun eglot-code-actions (beg end)
      "Stub para eglot-code-actions quando não disponível."
      (message "eglot-code-actions não está disponível")))
  
  (unless (fboundp 'eglot--code-action-bounds)
    (defun eglot--code-action-bounds ()
      "Stub para eglot--code-action-bounds quando não disponível."
      (cons (point) (point)))))

;; Corrigir docstrings muito longas
(with-eval-after-load 'go-mode
  (dolist (sym '(go-mode go-get-root go-goto-function-name))
    (when (fboundp sym)
      (let ((doc (documentation sym)))
        (when (and doc (> (length doc) 80))
          (put sym 'function-documentation 
               (with-temp-buffer
                 (insert doc)
                 (goto-char (point-min))
                 (while (re-search-forward "\\(.\\{70,79\\}\\) " nil t)
                   (replace-match "\\1\n" nil nil))
                 (buffer-string))))))))

(provide 'golang)
;;; golang.el ends here
