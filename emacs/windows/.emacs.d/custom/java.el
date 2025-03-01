;;; java.el --- Configuração para desenvolvimento em Java -*- lexical-binding: t -*-

;;; Commentary:
;; Configurações específicas para desenvolvimento em Java

;;; Code:

;; Hooks específicos para Java
(add-hook 'java-mode-hook 'lsp)

;; Configurações específicas para LSP com Java
(with-eval-after-load 'lsp-java
  ;; Configurações específicas para o Java Language Server
  (setq lsp-java-format-settings-url "https://raw.githubusercontent.com/google/styleguide/gh-pages/eclipse-java-google-style.xml")
  (setq lsp-java-format-settings-profile "GoogleStyle"))

;; Keybindings específicos para Java e DAP
(with-eval-after-load 'java-mode
  (define-key java-mode-map (kbd "C-c l d") 'dap-java-debug)
  (define-key java-mode-map (kbd "C-c l D") 'dap-java-debug-test-class)
  (define-key java-mode-map (kbd "C-c l M") 'dap-java-debug-test-method))

;; Função para criar projetos Spring Boot
(defun java/spring-initializer ()
  "Use lsp-java-spring-initializer to create a new Spring Boot project."
  (interactive)
  (lsp-java-spring-initializer))

(provide 'java)
;;; java.el ends here
