;;; json.el --- JSON com json-ts-mode (built-in) -*- lexical-binding: t; -*-

(defun my/json-format-buffer ()
  "Format current buffer with jq."
  (interactive)
  (when (executable-find "jq")
    (shell-command-on-region
     (point-min) (point-max) "jq ." nil t)))

(defun my/json-mode-hook ()
  "Configure JSON buffers: indent, keys, save hooks."
  (setq-local js-indent-level 2)
  (when (executable-find "jq")
    (add-hook 'before-save-hook #'my/json-format-buffer nil t)))

(add-hook 'json-ts-mode-hook #'my/json-mode-hook)

(provide 'json)
;;; json.el ends here
