;;; clojure.el --- Configurações para desenvolvimento em Clojure

;;; Commentary:

;; Este arquivo configura o Emacs para desenvolvimento em Clojure,
;; utilizando lsp-mode e CIDER para funcionalidades avançadas.

;;; Code:

;; Hooks específicos para Clojure
(add-hook 'clojure-mode-hook 'lsp)
(add-hook 'clojurescript-mode-hook 'lsp)
(add-hook 'clojurec-mode-hook 'lsp)
(add-hook 'cider-mode-hook #'eldoc-mode)
(add-hook 'cider-repl-mode-hook #'eldoc-mode)

;; Configurações específicas para LSP com Clojure
(with-eval-after-load 'lsp-mode
  ;; Especifica o caminho para o clojure-lsp se não estiver no PATH
  ;; (setq lsp-clojure-server-command '("c:/caminho/para/clojure-lsp.exe"))
  ;; Desativa indentação automática para evitar conflitos com o CIDER
  (setq lsp-enable-indentation nil)
  ;; Desativa snippets se não os utiliza
  (setq lsp-enable-snippet nil)
  ;; Adiciona configuração de ID de linguagem para Clojure
  (add-to-list 'lsp-language-id-configuration '(clojure-mode . "clojure"))
  (add-to-list 'lsp-language-id-configuration '(clojurescript-mode . "clojurescript"))
  (add-to-list 'lsp-language-id-configuration '(clojurec-mode . "clojurec")))

;; Keybindings específicos para Clojure
(with-eval-after-load 'clojure-mode
  (define-key clojure-mode-map (kbd "C-c C-e") 'cider-eval-last-sexp)
  (define-key clojure-mode-map (kbd "C-c C-c") 'cider-eval-defun-at-point))

;;; clojure.el ends here
