;;; editor.el --- Comportamento basico do editor -*- lexical-binding: t; -*-

(electric-indent-mode 1)
(electric-pair-mode 1)
(global-subword-mode 1)
(delete-selection-mode 1)
(recentf-mode 1)
(show-paren-mode 1)
(savehist-mode 1)
(add-hook 'text-mode-hook #'visual-line-mode)

(setq ring-bell-function 'ignore)
(setq make-backup-files nil
      auto-save-default nil
      create-lockfiles nil)

(global-auto-revert-mode 1)
(setq auto-revert-use-notify nil
      auto-revert-interval 1
      auto-revert-verbose nil)

(setq scroll-error-top-bottom t
      scroll-conservatively 101
      scroll-margin 2)

(add-hook 'before-save-hook #'delete-trailing-whitespace)

;; ── Eval ────────────────────────────────────────────────────────────
(defun my/eval-dwim ()
  "Evaluate the defun or source block at point, depending on mode.
In Org mode, evals the source block at point.  In prog-mode derived
buffers (including emacs-lisp-mode), evals the top-level form."
  (interactive)
  (cond
   ((and (derived-mode-p 'org-mode)
         (org-in-src-block-p))
    (org-babel-execute-src-block))
   ((derived-mode-p 'prog-mode)
    (condition-case nil
        (eval-defun nil)
      (end-of-file (user-error "No expression to evaluate at point"))))
   (t
    (user-error "No eval context here (use in elisp or Org src block)"))))

(global-set-key (kbd "<f5>") #'my/eval-dwim)

;; ── Goto last change (usando marker ring) ──────────────────────────
(defun my/goto-last-change ()
  "Go to the last buffer change position using the mark ring."
  (interactive)
  (set-mark-command 1))

(defun my/goto-last-change-reverse ()
  "Go forward through the mark ring."
  (interactive)
  (set-mark-command 0))

;; ── Abbrev + Skeleton (substitui yasnippet) ────────────────────────
(setq abbrev-file-name (expand-file-name "abbrev_defs" user-emacs-directory))
(setq save-abbrevs 'silently)

(dolist (hook '(prog-mode-hook text-mode-hook org-mode-hook))
  (add-hook hook (lambda () (setq local-abbrev-table (make-abbrev-table)))))

;; ── Enhance completion-at-point ─────────────────────────────────────
(setq tab-always-indent 'complete
      completion-cycle-threshold 3)

(provide 'editor)
;;; editor.el ends here
