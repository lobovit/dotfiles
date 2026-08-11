;;; yaml.el --- YAML com yaml-ts-mode (built-in) -*- lexical-binding: t; -*-

(defun my/yaml-indent ()
  "Set YAML indentation to 2 spaces."
  (setq-local yaml-indent-offset 2))

(add-hook 'yaml-ts-mode-hook #'my/yaml-indent)

(provide 'yaml)
;;; yaml.el ends here
