;;; ui.el --- Tema, fontes, dashboard, modeline -*- lexical-binding: t; -*-

(use-package nerd-icons
  :config
  (nerd-icons-set-font))

(use-package nerd-icons-dired
  :hook (dired-mode . nerd-icons-dired-mode))

(setq inhibit-startup-screen t)
(set-face-attribute 'default nil :family "Hack" :height 135)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(global-display-line-numbers-mode t)

(when (member "Segoe UI Emoji" (font-family-list))
  (set-fontset-font t 'unicode "Segoe UI Emoji" nil 'prepend))
(when (member "Symbola" (font-family-list))
  (set-fontset-font t 'unicode "Symbola" nil 'prepend))
(setq-default use-fallback-font t)

(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t doom-themes-enable-italic t)
  (load-theme 'doom-one t)
  (doom-themes-org-config))

(use-package doom-modeline
  :after nerd-icons
  :hook (after-init . doom-modeline-mode))

(use-package dashboard
  :init
  (setq initial-scratch-message nil)
  :config
  (setq dashboard-center-content t
        dashboard-show-shortcuts nil
        dashboard-startupify-list (delq 'dashboard-insert-footer dashboard-startupify-list)
        dashboard-set-heading-icons t
        dashboard-set-file-icons t
        dashboard-items '((recents . 5) (projects . 5) (bookmarks . 5)))
  (let ((banner-path (expand-file-name "images/lobo.png" user-emacs-directory)))
    (if (file-exists-p banner-path)
        (setq dashboard-startup-banner banner-path)
      (setq dashboard-startup-banner 'official)))
  (dashboard-setup-startup-hook))

(use-package dirvish
  :init
  (dirvish-override-dired-mode)
  :config
  (setq dirvish-use-icons t))

(use-package hl-todo
  :config
  (global-hl-todo-mode 1))

(use-package diff-hl
  :config
  (global-diff-hl-mode 1)
  :hook (magit-pre-refresh . diff-hl-magit-pre-refresh)
  :hook (magit-post-refresh . diff-hl-magit-post-refresh))

(provide 'ui)
;;; ui.el ends here
