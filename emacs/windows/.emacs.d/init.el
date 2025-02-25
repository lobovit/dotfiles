;;; init.el --- Emacs configuration -*- lexical-binding: t -*-

;;; Commentary:
;;; Configuração do Emacs para Windows

;;; Code:

;; Package Management (keep this at the top)
(require 'package)

;; Add package repositories
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("gnu" . "https://elpa.gnu.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")))

;; Initialize package system
(package-initialize)

;; Refresh package contents if needed
(unless package-archive-contents 
  (package-refresh-contents))

;; Bootstrap use-package
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; Set up custom file early
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(unless (file-exists-p custom-file)
  (write-region "" nil custom-file))
(load custom-file)

;; Debug settings
(setq debug-on-warning t)

;; Define dotfiles directory
(defvar dotfiles-dir (expand-file-name "site-lisp" "C:\\Users\\lobor\\AppData\\Roaming\\.emacs.d"))

;; Add this near the top of your init.el, after use-package setup
(use-package cl-lib
  :ensure t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Basic config
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq backup-directory-alist `(("." . "~/.saves")))

(setq inhibit-startup-screen t
      initial-scratch-message nil
      ring-bell-function 'ignore
      cursor-type 'box
      blink-cursor-mode nil
      create-lockfiles nil
      save-interprogram-paste-before-kill nil
      select-enable-primary nil
      electric-pair-mode 1
      electric-indent-mode 1
      line-number-mode t
      column-number-mode t
      select-enable-clipboard t
      bidi-display-reordering 'left-to-right)

;; Display time settings
(setq display-time-format "%a %b %d %R"
      display-time-interval 60
      display-time-default-load-average nil)
(display-time-mode 1)

;; Global modes
(add-hook 'before-save-hook 'whitespace-cleanup)
(auto-compression-mode t)
(global-display-line-numbers-mode t)
(global-font-lock-mode t)
(global-subword-mode 1)
(recentf-mode 1)
(show-paren-mode 1)
(global-visual-line-mode 1)
(delete-selection-mode 1)
(column-number-mode t)
(auto-fill-mode 1)

;; font type
(set-face-attribute 'default nil :family "Consolas" :height 152 :weight 'bold)


;; hotkey custom ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(global-set-key (kbd "C-c C-c") 'comment-or-uncomment-region)

;; treemacs keybind
(global-set-key (kbd "<f5>") 'treemacs)

;; packages keybind
;; Helm keybindings
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-x b") 'helm-mini)
(global-set-key (kbd "C-s") 'helm-occur)

;; Projectile keybindings
;; First define the prefix key map, then bind individual commands
(define-key global-map (kbd "C-c p") 'projectile-command-map)
;; Don't bind these individually as they're already in the command map
;; (projectile-find-file is bound to 'f' in projectile-command-map)
;; (projectile-switch-project is bound to 'p' in projectile-command-map)
;; (projectile-ripgrep is bound to 's r' in projectile-command-map)

;; Magit keybindings
(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key (kbd "C-x M-g") 'magit-dispatch)

;; Multiple-cursors keybindings
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

;; LSP mode keybindings
;; First define the prefix key map
(define-prefix-command 'lsp-command-map)
(global-set-key (kbd "C-c l") 'lsp-command-map)
;; Then bind individual commands to the prefix map
(define-key lsp-command-map (kbd "r") 'lsp-rename)
(define-key lsp-command-map (kbd "d") 'lsp-find-definition)
(define-key lsp-command-map (kbd "a") 'lsp-execute-code-action)

;; Company keybindings
(global-set-key (kbd "C-<tab>") 'company-complete)

;; Expand-region keybindings
(global-set-key (kbd "C-=") 'er/expand-region)

;; Dumb-jump keybindings
(global-set-key (kbd "M-g j") 'dumb-jump-go)
(global-set-key (kbd "M-g b") 'dumb-jump-back)

;; Ripgrep keybindings
(global-set-key (kbd "C-c s") 'ripgrep-regexp)





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; UI simplification
(defalias 'yes-or-no-p 'y-or-n-p)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(tooltip-mode -1)
(menu-bar-mode -1)

;; Load all custom configuration files
(defvar custom-dir (expand-file-name "custom" user-emacs-directory))
(when (file-exists-p custom-dir)
  (dolist (file (directory-files custom-dir t "\\.el$"))
    (load-file file)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Package configurations
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Web mode
(use-package web-mode
  :ensure t
  :mode (("\\.html?\\'" . web-mode)
         ("\\.tsx\\'" . web-mode)
         ("\\.jsx\\'" . web-mode)
         ("\\.css\\'" . web-mode)
         ("\\.scss\\'" . web-mode)
         ("\\.php\\'" . web-mode))
  :config
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-enable-auto-pairing t)
  (setq web-mode-enable-css-colorization t)
  (setq web-mode-enable-current-element-highlight t)
  :hook (web-mode . (lambda ()
                      (setq web-mode-markup-indent-offset 2)
                      (setq web-mode-css-indent-offset 2)
                      (setq-local electric-pair-inhibit-predicate
                                  (lambda (c)
                                    (if (char-equal c ?{) t
                                      (when (fboundp 'electric-pair-default-inhibit)
                                        (funcall 'electric-pair-default-inhibit c))))))))

;; Flycheck
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

;; Company
(use-package company
  :ensure t
  :config
  (global-company-mode))

;; Rainbow-mode
(use-package rainbow-mode
  :ensure t)

;; Pkgbuild
(use-package pkgbuild-mode
  :ensure t
  :mode "PKGBUILD")

;; YAML
(use-package yaml-mode
  :ensure t
  :mode (("\\.yml\\'" . yaml-mode)
         ("\\.yaml\\'" . yaml-mode)))

;; Powershell
(use-package powershell
  :ensure t)

;; Magit
(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)))

;; Quickrun
(use-package quickrun
  :ensure t
  :bind ("C-c r" . quickrun))

;; Projectile
(use-package projectile
  :ensure t
  :config
  (projectile-mode +1)
  (setq projectile-completion-system 'ivy)
  :bind-keymap ("C-c p" . projectile-command-map))

;; Counsel-projectile
(use-package counsel-projectile
  :ensure t
  :config
  (counsel-projectile-mode))

;; Dumb-jump
(use-package dumb-jump
  :ensure t
  :config
  (setq dumb-jump-selector 'ivy)
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate))

;; Ripgrep
(use-package ripgrep
  :ensure t)

;; LSP-treemacs
(use-package lsp-treemacs
  :ensure t)

;; Treemacs
(use-package treemacs
  :ensure t)

;; Markdown mode
(use-package markdown-mode
  :ensure t
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode)))

;; Unfill paragraph functions
(defun unfill-paragraph ()
  "Unfill paragraph at or after point."
  (interactive)
  (let ((fill-column (point-max)))
    (fill-paragraph nil)))

(defun unfill-region ()
  "Unfill region from BEGIN to END."
  (interactive)
  (let ((fill-column (point-max)))
    (fill-region (region-beginning) (region-end) nil)))

;; Add this if you want to use helm
(use-package helm
  :ensure t
  :config
  (helm-mode 1))

;; Add this function to your init.el to fix point-at-bol references
(defalias 'point-at-bol 'line-beginning-position)
(defalias 'point-at-eol 'line-end-position)

;; Add compatibility for 'first' function
(defalias 'first 'cl-first)

;; Add this to fix the find-function-source-path warning
(setq find-library-source-path load-path)

(provide 'init)
;;; init.el ends here
