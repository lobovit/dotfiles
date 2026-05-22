;;; ui.el --- Tema, fontes, mode-line, dired -*- lexical-binding: t; -*-

(setq inhibit-startup-screen t
      initial-scratch-message nil)

(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(global-display-line-numbers-mode 1)

;; ── Fontes ─────────────────────────────────────────────────────────
(set-face-attribute 'default nil :family "Hack" :height 135)
(when (member "Segoe UI Emoji" (font-family-list))
  (set-fontset-font t 'unicode "Segoe UI Emoji" nil 'prepend))
(setq-default use-fallback-font t)

;; ── Tema: Modus Vivendi (built-in) ─────────────────────────────────
(setq modus-themes-italic-constructs t
      modus-themes-bold-constructs t
      modus-themes-tabs-accent t
      modus-themes-region '(bg-only)
      modus-themes-completions 'opinionated)
(load-theme 'modus-vivendi t)

;; ── Dired (built-in, substitui dirvish) ────────────────────────────
(require 'dired)
(setq dired-listing-switches "-alh --group-directories-first"
      dired-dwim-target t
      dired-recursive-copies 'always
      dired-recursive-deletes 'always
      dired-kill-when-opening-new-dired-buffer t
      dired-hide-details-hide-absolute-location t)
(add-hook 'dired-mode-hook #'dired-hide-details-mode)
(setq delete-by-moving-to-trash t)

;; ── VC Gutter (codigo proprio) ─────────────────────────────────────
(load (expand-file-name "vc-gutter" my/lisp-dir) nil 'nomessage)
(add-hook 'prog-mode-hook #'vc-gutter-mode)

;; ── Mode-line minimal ──────────────────────────────────────────────
(setq-default mode-line-format
  '("%e"
    mode-line-front-space
    (:eval
     (if (buffer-modified-p)
         (propertize "*" 'face 'font-lock-warning-face)
       " "))
    "  "
    mode-line-buffer-identification
    "  "
    "(" mode-line-modes ")"
    "  "
    (:eval (propertize
            (format "L%d:C%d" (line-number-at-pos) (current-column))
            'face 'shadow))
    "  "
    (:eval (when vc-mode
             (propertize
              (replace-regexp-in-string
               "^ " "" (substring-no-properties vc-mode))
              'face 'font-lock-constant-face)))
    "  "))

(provide 'ui)
;;; ui.el ends here
