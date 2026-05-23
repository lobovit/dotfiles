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

;; ── Tema: Modus Vivendi + Catppuccin Mocha ─────────────────────────
;; Baseado em: https://www.rahuljuliato.com/posts/modus-catppuccin
;; Paleta: https://github.com/catppuccin/catppuccin (Mocha)
(setq modus-themes-italic-constructs t
      modus-themes-bold-constructs t
      modus-themes-mixed-fonts nil
      modus-themes-prompts '(bold intense)
      modus-themes-common-palette-overrides
      '((accent-0 "#89b4fa")
        (accent-1 "#89dceb")
        (bg-active bg-main)
        (bg-added "#364144")
        (bg-added-refine "#4A5457")
        (bg-changed "#3e4b6c")
        (bg-changed-refine "#515D7B")
        (bg-completion "#45475a")
        (bg-completion-match-0 "#1e1e2e")
        (bg-completion-match-1 "#1e1e2e")
        (bg-completion-match-2 "#1e1e2e")
        (bg-completion-match-3 "#1e1e2e")
        (bg-hl-line "#2a2b3d")
        (bg-hover-secondary "#585b70")
        (bg-line-number-active unspecified)
        (bg-line-number-inactive "#1e1e2e")
        (bg-main "#1e1e2e")
        (bg-mark-delete "#443245")
        (bg-mark-select "#3e4b6c")
        (bg-mode-line-active "#181825")
        (bg-mode-line-inactive "#181825")
        (bg-prominent-err "#443245")
        (bg-prompt unspecified)
        (bg-prose-block-contents "#313244")
        (bg-prose-block-delimiter bg-prose-block-contents)
        (bg-region "#585b70")
        (bg-removed "#443245")
        (bg-removed-refine "#574658")
        (bg-tab-bar      "#1e1e2e")
        (bg-tab-current  bg-main)
        (bg-tab-other    "#1e1e2e")
        (border-mode-line-active nil)
        (border-mode-line-inactive nil)
        (builtin "#89b4fa")
        (comment "#9399b2")
        (constant  "#f38ba8")
        (cursor  "#f5e0dc")
        (date-weekday "#89b4fa")
        (date-weekend "#fab387")
        (docstring "#a6adc8")
        (err     "#f38ba8")
        (fg-active fg-main)
        (fg-completion "#cdd6f4")
        (fg-completion-match-0 "#89b4fa")
        (fg-completion-match-1 "#f38ba8")
        (fg-completion-match-2 "#a6e3a1")
        (fg-completion-match-3 "#fab387")
        (fg-heading-0 "#f38ba8")
        (fg-heading-1 "#fab387")
        (fg-heading-2 "#f9e2af")
        (fg-heading-3 "#a6e3a1")
        (fg-heading-4 "#74c7ec")
        (fg-line-number-active "#b4befe")
        (fg-line-number-inactive "#7f849c")
        (fg-link  "#89b4fa")
        (fg-main "#cdd6f4")
        (fg-mark-delete "#f38ba8")
        (fg-mark-select "#89b4fa")
        (fg-mode-line-active "#bac2de")
        (fg-mode-line-inactive "#585b70")
        (fg-prominent-err "#f38ba8")
        (fg-prompt "#cba6f7")
        (fg-prose-block-delimiter "#9399b2")
        (fg-prose-verbatim "#a6e3a1")
        (fg-region "#cdd6f4")
        (fnname    "#89b4fa")
        (fringe "#1e1e2e")
        (identifier "#cba6f7")
        (info    "#94e2d5")
        (keyword   "#cba6f7")
        (name "#89b4fa")
        (number "#fab387")
        (property "#89b4fa")
        (string "#a6e3a1")
        (type      "#f9e2af")
        (variable  "#fab387")
        (warning "#f9e2af")))

(load-theme 'modus-vivendi t)

(modus-themes-with-colors
  (custom-set-faces
   `(change-log-acknowledgment ((,c :foreground "#b4befe")))
   `(change-log-date ((,c :foreground "#a6e3a1")))
   `(change-log-name ((,c :foreground "#fab387")))
   `(diff-context ((,c :foreground "#89b4fa")))
   `(diff-file-header ((,c :foreground "#f5c2e7")))
   `(diff-header ((,c :foreground "#89b4fa")))
   `(diff-hunk-header ((,c :foreground "#fab387")))
   `(gnus-button ((,c :foreground "#8aadf4")))
   `(gnus-group-mail-3 ((,c :foreground "#8aadf4")))
   `(gnus-group-mail-3-empty ((,c :foreground "#8aadf4")))
   `(gnus-header-content ((,c :foreground "#7dc4e4")))
   `(gnus-header-from ((,c :foreground "#cba6f7")))
   `(gnus-header-name ((,c :foreground "#a6e3a1")))
   `(gnus-header-subject ((,c :foreground "#8aadf4")))
   `(log-view-message ((,c :foreground "#b4befe")))
   `(match ((,c :background "#3e5768" :foreground "#cdd6f5")))
   `(modus-themes-search-current ((,c :background "#f38ba8" :foreground "#11111b")))
   `(modus-themes-search-lazy ((,c :background "#3e5768" :foreground "#cdd6f5")))
   `(newsticker-extra-face ((,c :foreground "#9399b2" :height 0.8 :slant italic)))
   `(newsticker-feed-face ((,c :foreground "#f38ba8" :height 1.2 :weight bold)))
   `(newsticker-treeview-face ((,c :foreground "#cdd6f4")))
   `(newsticker-treeview-selection-face ((,c :background "#3e5768" :foreground "#cdd6f5")))
   `(tab-bar ((,c :background "#1e1e2e" :foreground "#bac2de")))
   `(tab-bar-tab ((,c :background "#1e1e2e" :underline t)))
   `(tab-bar-tab-group-current ((,c :background "#1e1e2e" :foreground "#bac2de" :underline t)))
   `(tab-bar-tab-group-inactive ((,c :background "#1e1e2e" :foreground "#9399b2")))
   `(tab-bar-tab-inactive ((,c :background "#1e1e2e" :foreground "#a6adc8")))
    `(vc-dir-file ((,c :foreground "#89b4fa")))
    `(vc-dir-header-value ((,c :foreground "#b4befe")))))


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
