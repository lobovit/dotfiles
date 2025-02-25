;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Basic package manager
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("elpa" . "https://elpa.gnu.org/packages/")
			 ("org" . "https://orgmode.org/elpa/")))
(package-initialize)

(unless package-archive-contents (package-refresh-contents))
;;; init.el --- Emacs configuration -*- lexical-binding: t -*-

;;; Commentary:
;;; Configuração do Emacs para Windows

;;; Code:

;; Package Management (keep this at the top)
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/") t)

;; Bootstrap use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(setq debug-on-warning t)

(defvar dotfiles-dir (expand-file-name "site-lisp" "C:\\Users\\lobor\\AppData\\Roaming\\.emacs.d"))

(defun lobo-require-packages (packages)
  (dolist (package packages)
    (when (not (package-installed-p package))
      (package-install package))))

(defvar package-list '(projectile
		       lsp-treemacs
		       treemacs
		       markdown-mode
		       web-mode
		       flycheck
		       company
		       rainbow-mode
		       pkgbuild-mode
		       yaml-mode
		       powershell
		       magit
		       quickrun
		       counsel-projectile
		       dumb-jump
		       ripgrep))

(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))


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

(defvar display-time-format)
(defvar display-time-interval)
(defvar display-time-default-load-average)

(display-time-mode 1)

(setq display-time-format "%a %b %d %R"
      display-time-interval 60
      display-time-default-load-average nil)

(display-time)
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

(defalias 'yes-or-no-p 'y-or-n-p)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(tooltip-mode -1)
(menu-bar-mode -1)

(defalias 'yes-or-no-p 'y-or-n-p)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(tooltip-mode -1)
(menu-bar-mode -1)


;; Theme
(use-package tangotango-theme
  :ensure t
  :init (load-theme 'tangotango t))

;; Font
(set-face-attribute 'default nil :family "Consolas" :height 152 :weight 'bold)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Personal custom hotkeys config
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(global-set-key [f2] 'eval-buffer)
(global-set-key [f6] 'dired)
(global-set-key [f4] 'treemacs)


;; Eshell Config

(defun disable-company-in-eshell ()
  "Disable company-mode in eshell."
  (company-mode -1))

(add-hook 'eshell-mode-hook 'disable-company-in-eshell)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Plugins
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Treemacs
(use-package lsp-treemacs
  :ensure t
  :commands lsp-treemacs-errors-list
  :bind (:map lsp-mode-map
	      ("M-9" . lsp-treemacs-errors-list)))

(use-package treemacs
  :ensure t
  :defer t
  :init
  (setq treemacs-follow-after-init t)
  :config
  (when (fboundp 'treemacs-follow-mode)
    (treemacs-follow-mode 1))
  (when (fboundp 'treemacs-project-follow-mode)
    (treemacs-project-follow-mode 1)))

(use-package treemacs
  :ensure t
  :commands (treemacs)
  :after (lsp-mode))

;; Markdown
(use-package markdown-mode
  :ensure t
  :commands
  (markdown-mode gfm-mode)
  :bind (:map markdown-mode-map ("C-<tab>" . yas-expand))
  :mode
  (("README\\.md\\'" . gfm-mode)
   ("\\.md\\'" . markdown-mode)
   ("\\.text\\'" . markdown-mode)
   ("\\.markdown\\'" . markdown-mode))
  :init
  (setq markdown-command "markdown")
  :config
  (add-hook 'markdown-mode-hook (lambda () (auto-fill-mode t)))
  (add-hook 'markdown-mode-hook 'flyspell-mode))

;; HTML

(use-package web-mode
  :ensure t
  :mode
  (("\\.html?\\'" . web-mode)
   ("\\.htm?\\'" . web-mode))
  :config
  (defun my-web-mode-hooks ()
    "Hooks for Web mode."
    (setq web-mode-markup-indent-offset 2)
    (setq web-mode-css-indent-offset 2)
    (setq-local electric-pair-inhibit-predicate
		(lambda (c)
		  (if (char-equal c ?{) t
		    (when (fboundp 'electric-pair-default-inhibit)
		      (funcall 'electric-pair-default-inhibit c))))))
    )
  (add-hook 'web-mode-hook #'my-web-mode-hooks)


;; Flycheck
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

;; Company
(use-package company
  :ensure t)

;; Rainbow-mode
(use-package rainbow-mode
  :ensure t)

;; Pkgbuild
(use-package pkgbuild-mode
  :ensure t
  :mode "PKGBUILD")

;; YAML
(use-package yaml-mode
  :defer t
  :ensure t
  :mode (("\\.yml$" . yaml-mode)
	 ("\\.yaml$" . yaml-mode)))

;; Powershell
(use-package powershell
  :ensure t)

;; Unfill paragraph
(defun unfill-paragraph ()
  (interactive)
  (let ((fill-column (point-max)))
    (fill-paragraph nil)))

(defun unfill-region ()
  (interactive)
  (let ((fill-column (point-max)))
    (fill-region (region-beginning) (region-end) nil)))

;; Magit
(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)))

;; Company
(use-package company
  :ensure t)

;; Flycheck
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Package Management

;; Add MELPA repository
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives
             '("gnu" . "https://elpa.gnu.org/packages/") t)

;; Initialize package system
(package-initialize)

;; Quickrun
(use-package quickrun
  :ensure t
  :bind ("C-c r" . quickrun))

;; Projectile
(use-package projectile
  :ensure t
  :config
  (projectile-mode +1)
  (setq projectile-completion-system 'ivy))
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

(use-package counsel-projectile
  :ensure t
  :config
  (counsel-projectile-mode))

(use-package dumb-jump
  :ensure t
  :config
  (setq dumb-jump-selector 'ivy) ;; ou 'helm, se preferir o Helm
  ;; Ativa o dumb-jump como backend do xref para navegação entre definições
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate))

;; Ripgrep
(use-package ripgrep
  :ensure t)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(dumber-jump counsel-projectile projectile quickrun flycheck magit powershell yaml-mode pkgbuild-mode rainbow-mode slime-company web-mode highlight-indent-guides lsp-treemacs tangotango-theme)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'upcase-region 'disabled nil)
