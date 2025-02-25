;;; clojure.el --- Configurações para desenvolvimento em Clojure

;;; Commentary:

;; Este arquivo configura o Emacs para desenvolvimento em Clojure,
;; utilizando lsp-mode, clojure-lsp e CIDER para funcionalidades avançadas.

;;; Code:

(require 'use-package)

;; Configuração do clojure-mode
(use-package clojure-mode
  :ensure t
  :defer t)

;; Configuração do lsp-mode para Clojure
(use-package lsp-mode
  :ensure t
  :commands lsp
  :hook ((clojure-mode . lsp)
         (clojurescript-mode . lsp)
         (clojurec-mode . lsp))
  :config
  ;; Especifica o caminho para o clojure-lsp se não estiver no PATH
  ;; (setq lsp-clojure-server-command '("c:/caminho/para/clojure-lsp.exe"))
  ;; Desativa indentação automática para evitar conflitos com o CIDER
  (setq lsp-enable-indentation nil)
  ;; Desativa snippets se não os utiliza
  (setq lsp-enable-snippet nil))

;; Configuração do lsp-ui para melhorias na interface
(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode
  :after lsp-mode
  :config
  ;; Ativa o lsp-ui-mode
  (add-hook 'lsp-mode-hook 'lsp-ui-mode)
  ;; Configurações personalizadas para o lsp-ui
  (setq lsp-ui-doc-enable t
        lsp-ui-doc-position 'at-point
        lsp-ui-sideline-enable t
        lsp-ui-sideline-show-hover t))

;; Configuração do company-mode para autocompletar
(use-package company
  :ensure t
  :config
  ;; Ativa o company-mode globalmente
  (global-company-mode t)
  ;; Configurações adicionais do company-mode
  (setq company-idle-delay 0.1
        company-minimum-prefix-length 1))

;; Configuração do which-key para ajuda com atalhos
(use-package which-key
  :ensure t
  :config
  ;; Ativa o which-key-mode
  (which-key-mode)
  (setq which-key-idle-delay 0.5))

;; Configuração do CIDER para integração com REPL
(use-package cider
  :ensure t
  :after clojure-mode
  :config
  ;; Remove a mensagem de boas-vindas do REPL
  (setq cider-repl-display-help-banner nil)
  ;; Controla como o buffer do REPL é exibido
  (setq cider-repl-pop-to-buffer-on-connect 'display-only)
  ;; Salva o buffer ao compilar ou carregar código
  (setq cider-save-file-on-load t)
  ;; Usa pretty-print no REPL
  (setq cider-repl-use-pretty-printing t)
  ;; Configura o histórico do REPL
  (setq cider-repl-wrap-history t)
  (setq cider-repl-history-size 1000)
  (setq cider-repl-history-file "~/.emacs.d/cider-history")
  ;; Integração com eldoc
  (add-hook 'cider-mode-hook #'eldoc-mode)
  (add-hook 'cider-repl-mode-hook #'eldoc-mode))

;;; clojure.el ends here
