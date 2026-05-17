;;; ai.el --- OpenCode e mpvi -*- lexical-binding: t; -*-

(defvar my/opencode-dir (expand-file-name "jdormit-emacs-opencode" user-emacs-directory))
(defvar my/opencode-cmd (expand-file-name "npm/opencode.cmd" (getenv "APPDATA")))

(use-package request
  :ensure t)

(use-package emacs-opencode
  :ensure nil
  :load-path my/opencode-dir
  :after request
  :commands (opencode opencode-ask opencode-ask-contextual)
  :custom
  (opencode-server-command my/opencode-cmd))

(use-package mpvi
  :config
  (setq mpvi-mpv-ontop-p t)
  (setq mpvi-mpv-border-p t))

(provide 'ai)
;;; ai.el ends here
