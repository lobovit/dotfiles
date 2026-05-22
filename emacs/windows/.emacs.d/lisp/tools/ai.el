;;; ai.el --- OpenCode integration (sem dependencias externas) -*- lexical-binding: t; -*-

(defvar my/opencode-dir
  (expand-file-name "jdormit-emacs-opencode" user-emacs-directory))

(defvar my/opencode-cmd
  (expand-file-name "npm/opencode.cmd" (getenv "APPDATA")))

;; ── request shim (built-in, substitui request.el) ──────────────────
(load (expand-file-name "request-shim" my/lisp-dir) nil 'nomessage)

;; ── Load emacs-opencode ────────────────────────────────────────────
(add-to-list 'load-path my/opencode-dir)
(require 'emacs-opencode)
(setq opencode-server-command my/opencode-cmd)

;; ── Command ────────────────────────────────────────────────────────
(defun my/opencode ()
  "Open OpenCode in the current project."
  (interactive)
  (let ((default-directory (or (cdr-safe (project-current))
                               default-directory)))
    (opencode default-directory)))

(provide 'ai)
;;; ai.el ends here
