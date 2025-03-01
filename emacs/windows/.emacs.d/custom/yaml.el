;;; yaml.el --- Configuração para YAML -*- lexical-binding: t -*-

;;; Commentary:
;; Configurações específicas para edição de arquivos YAML

;;; Code:

;; Hooks específicos para YAML
(add-hook 'yaml-mode-hook
          (lambda ()
            ;; Configurar indentação para YAML
            (setq tab-width 2)
            (setq indent-tabs-mode nil)))

;; Configurações específicas para YAML
(with-eval-after-load 'yaml-mode
  ;; Configurar faces específicas para YAML
  (set-face-attribute 'yaml-tab-face nil :background "red" :foreground "white")
  
  ;; Configurar keybindings específicos
  (define-key yaml-mode-map (kbd "C-c C-v") 'yaml-mode-validate-buffer))

(provide 'yaml)
;;; yaml.el ends here 