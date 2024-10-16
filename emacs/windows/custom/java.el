;;; Java Development Setup for Emacs

;; Carregar lsp-java para habilitar o LSP no java-mode
(use-package lsp-java
  :ensure t
  :config
  (add-hook 'java-mode-hook 'lsp) ;; Ativa o LSP para Java
  (setq lsp-java-vmargs
        '("-XX:+UseG1GC" "-XX:+UseStringDeduplication" "-Xmx2G"))
  ;; Ajuste o caminho do Java, se necessário
  ;; (setq lsp-java-java-path "path_to_your_java")
  (setq lsp-java-save-action-organize-imports t)
  (setq lsp-java-autobuild-enabled t))

;; DAP Mode para depuração de Java
(use-package dap-java
  :ensure nil
  :after lsp-java)

;; Funções e atalhos adicionais para LSP e DAP
(global-set-key (kbd "C-c l d") 'dap-java-debug)          ;; Depurar projeto Java
(global-set-key (kbd "C-c l D") 'dap-java-debug-test-class) ;; Depurar classe de teste
(global-set-key (kbd "C-c l M") 'dap-java-debug-test-method) ;; Depurar método de teste

;; Spring Initializer com LSP para criar projetos Spring Boot
(defun java/spring-initializer ()
  "Use lsp-java-spring-initializer to create a new Spring Boot project."
  (interactive)
  (lsp-java-spring-initializer))
