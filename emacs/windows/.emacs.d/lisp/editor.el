;;; editor.el --- Comportamento basico do editor -*- lexical-binding: t; -*-

(electric-indent-mode 1)
(electric-pair-mode 1)
(global-subword-mode 1)
(delete-selection-mode 1)
(recentf-mode 1)
(show-paren-mode 1)
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

;; ── Smartparens ────────────────────────────────────────────────────
(use-package smartparens
  :config
  (require 'smartparens-config)
  (smartparens-global-mode 1))

;; ── WS Butlet ──────────────────────────────────────────────────────
(use-package ws-butler
  :hook (prog-mode . ws-butler-mode)
  :hook (text-mode . ws-butler-mode))

;; ── Goto Last Change ───────────────────────────────────────────────
(use-package goto-chg)

;; ── Multiple Cursors ───────────────────────────────────────────────
(use-package multiple-cursors)

;; ── Ctrlf ─────────────────────────────────────────────────────────
(use-package ctrlf
  :config
  (ctrlf-mode 1))

;; ── Undo Tree ──────────────────────────────────────────────────────
(use-package undo-tree
  :init
  (setq undo-tree-history-directory-alist
        `(("." . ,(expand-file-name "undo-tree" user-emacs-directory))))
  :config
  (global-undo-tree-mode 1))

;; ── Avy ────────────────────────────────────────────────────────────
(use-package avy)

;; ── Yasnippet ──────────────────────────────────────────────────────
(use-package yasnippet
  :config
  (yas-global-mode 1))

;; ── Org Modern ─────────────────────────────────────────────────────
(use-package org-modern
  :hook (org-mode . org-modern-mode))

(provide 'editor)
;;; editor.el ends here
