;;; java.el --- Configurações para desenvolvimento Java

;;; Commentary:

;; Este arquivo configura o Emacs para desenvolvimento em Java,
;; utilizando lsp-mode e lsp-java para funcionalidades avançadas.

;;; Code:

(require 'use-package)

;; Configuração do lsp-mode (já deve estar instalado)
(use-package lsp-mode
  :ensure t
  :commands lsp
  :init
  ;; Opcional: Ativa o lsp-mode para todos os modos suportados
  ;; (add-hook 'prog-mode-hook #'lsp)
  )

;; Configuração do lsp-java
(use-package lsp-java
  :ensure t
  :after lsp-mode
  :config
  ;; Adiciona o lsp ao java-mode
  (add-hook 'java-mode-hook #'lsp)
  ;; Configurações específicas do lsp-java
  ;; Especifica o caminho para o executável do Java
  ;; (setq lsp-java-java-path "C:/Program Files/Java/jdk-17/bin/java.exe")
  ;; Especifica argumentos para a JVM
  ;; (setq lsp-java-vmargs '("-Xmx2G" "-XX:+UseG1GC" "-XX:+UseStringDeduplication"))
  )

;; Configuração do dap-mode para depuração
(use-package dap-mode
  :ensure t
  :after lsp-mode
  :config
  ;; Ativa o dap-mode globalmente
  (dap-mode t)
  (dap-auto-configure-mode)
  ;; Carrega o suporte ao Java no dap-mode
  (require 'dap-java)
  ;; Configurações adicionais podem ser feitas aqui
  )

;; Configuração do lsp-ui para melhorias na interface
(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode
  :config
  ;; Ativa o lsp-ui no lsp-mode
  (add-hook 'lsp-mode-hook 'lsp-ui-mode)
  ;; Configurações personalizadas para o lsp-ui
  (setq lsp-ui-doc-enable t
        lsp-ui-doc-position 'at-point
        lsp-ui-sideline-enable t
        lsp-ui-sideline-show-hover t)
  )

;; Configuração do company-mode para autocompletar
(use-package company
  :ensure t
  :config
  ;; Ativa o company-mode globalmente
  (global-company-mode t)
  ;; Diminui o tempo para aparecer as sugestões
  (setq company-idle-delay 0.1)
  ;; Número mínimo de caracteres para acionar o autocompletar
  (setq company-minimum-prefix-length 1)
  ;; Configurações adicionais do company-mode
  )

;; Configuração do which-key para ajuda com atalhos
(use-package which-key
  :ensure t
  :config
  ;; Ativa o which-key-mode
  (which-key-mode)
  ;; Tempo de exibição das dicas
  (setq which-key-idle-delay 0.5)
  )

;;; java.el ends here
