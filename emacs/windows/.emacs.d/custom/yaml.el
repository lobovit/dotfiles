;;; yaml.el --- YAML mode configuration -*- lexical-binding: t -*-

;;; Commentary:
;; Configuração para edição de arquivos YAML

;;; Code:

(use-package yaml-mode
  :ensure t
  :mode (("\\.yml\\'" . yaml-mode)
         ("\\.yaml\\'" . yaml-mode))
  :config
  ;; Definir a variável yaml-indent-offset para evitar warning
  (defvar yaml-indent-offset 2
    "Número de espaços para indentação em arquivos YAML.")
  
  ;; Definir a função yaml-indent para evitar warning
  (unless (fboundp 'yaml-indent)
    (defun yaml-indent ()
      "Indent current line as YAML code."
      (interactive)
      (let ((indent (+ (current-indentation) yaml-indent-offset)))
        (indent-line-to indent)))))

(provide 'yaml)
;;; yaml.el ends here 