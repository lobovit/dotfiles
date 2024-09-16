;;; Code

;;; Configuração do Emacs para Windows

(setq debug-on-warning t)


(defvar dotfiles-dir (expand-file-name "site-lisp" "C:\\Users\\lobor\\AppData\\Roaming\\.emacs.d"))

(defun lobo-require-packages (packages)
  (dolist (package packages)
    (when (not (package-installed-p package))
      (package-install package))))

(defun lobo-recentf-ido-find-file ()
  "Encontra um arquivo recente usando ido."
  (interactive)
  (let ((file (ido-completing-read "Escolha um arquivo recente: " recentf-list nil t)))
    (when file
      (find-file file))))

(defun custom-isearch-toggle ()
  "Alternar entre isearch-forward e isearch-backward."
  (interactive)
  (if (eq isearch-forward t)
      (progn
        (isearch-exit)
        (isearch-backward))
    (progn
      (isearch-exit)
      (isearch-forward))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Vinculação de Chaves

(global-set-key (kbd "C-x f") 'lobo-recentf-ido-find-file)

;; Saindo
;; O acrônimo é C-x REALLY QUIT
(global-set-key (kbd "C-x r q") 'save-buffers-kill-terminal)
;(global-set-key (kbd "C-x C-c") 'delete-frame)

;; Configuração personalizada de chaves

;; Salvar arquivos
(global-set-key (kbd "C-s") 'save-buffer)

;; Ctrl + a para selecionar tudo
(global-set-key (kbd "C-a") 'mark-whole-buffer)

;; Pesquisa
(global-set-key (kbd "C-f") 'custom-isearch-toggle)

;; Colar
(global-set-key (kbd "C-v") 'yank)

;; Cortar
(global-set-key (kbd "C-S-x") 'kill-region)

;; Substituir
(global-set-key (kbd "C-r") 'query-replace)

;; Desfazer
(global-set-key (kbd "C-z") 'undo)

;; Refazer
(global-set-key (kbd "C-S-z") 'undo-redo)

;; Recarregar configuração do Emacs
(global-set-key [f5] 'eval-buffer)
(global-set-key [f6] 'dired)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Global Modes

(require 'ansi-color)
(require 'recentf)
(require 'ffap)
(require 'uniquify)

(auto-compression-mode t)
(auto-fill-mode 1)
(delete-selection-mode 1)
(global-font-lock-mode t)
;(global-whitespace-mode 1)

;; Line Numbers
(global-display-line-numbers-mode t)

;; Navigate sillycased words
(global-subword-mode 1)

(ido-mode t)
(recentf-mode 1)
(show-paren-mode 1)
(global-visual-line-mode 1)

;;;;;;;;;;;;;;;;;;;;;;;
;;; projectile
;;;;;;;;;;;;;;;;;;;;;;

(use-package projectile
    :ensure t
    :init
    (projectile-mode 1))

(global-set-key (kbd "<f7>") 'projectile-compile-project)

;; utf8
(set-language-environment "UTF-8")
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(setq-default buffer-file-coding-system 'utf-8)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Custom Settings

;; backup in.saves directory
(setq backup-directory-alist `(("." . "~/.saves")))

;; force bash with my shell
(defvar my-term-shell "/usr/local/bin/bash")
(defadvice ansi-term (before force-bash)
    (interactive (list my-term-shell)))
(ad-activate 'ansi-term)

(global-set-key (kbd "<s-return>") 'ansi-term)

(column-number-mode t)
;(custom-file (concat user-emacs-directory "custom.el"))

(indent-tabs-mode nil)

;; When on a tab, make the cursor the tab length…
(setq-default x-stretch-cursor t)

;; But never insert tabs…
(set-default 'indent-tabs-mode nil)

;; Except in Makefiles.
(add-hook 'makefile-mode-hook 'indent-tabs-mode)

;; Keep files clean.
(setq-default require-final-newline t)

(setq-default show-trailing-whitespace t)
(add-hook 'before-save-hook 'whitespace-cleanup)

;; Don't write lock-files
(setq create-lockfiles nil)

;; Fix empty clipboard error
(setq save-interprogram-paste-before-kill nil)

;; Remove text in active region if inserting text
(delete-selection-mode 1)

;; Don't automatically copy selected text
(setq select-enable-primary nil)

;; Auto-close brackets and double quotes
(electric-pair-mode 1)

;; Don't automatically indent lines
(electric-indent-mode 1)

;; Always display line and column numbers
(setq line-number-mode t)
(setq column-number-mode t)

;; Word wrap (t is no wrap, nil is wrap)
(setq-default truncate-lines nil)

;; Don't use shift to mark things.
;(setq shift-select-mode nil)

;; Allow clipboard from outside emacs
(setq select-enable-clipboard t
        save-interprogram-paste-before-kill t
        apropos-do-all t
        mouse-yank-at-point t)

;; Improve performance of very long lines
(setq-default bidi-display-reordering 'left-to-right)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Mode-line

;; Remove all minor modes (mode-line-modes)
(setq-default mode-line-format
        '("%e"
        mode-line-front-space
        mode-line-mule-info
        mode-line-client
        mode-line-modified
        mode-line-remote
        mode-line-frame-identification
        mode-line-buffer-identification
        "    "
        mode-line-position
        (vc-mode vc-mode)
        " (" mode-name ") "
        mode-line-misc-info
        mode-line-end-spaces))

;; Add Date
(setq display-time-day-and-date t
        display-time-format "%a %b %d %R"
        display-time-interval 60
        display-time-default-load-average nil)
(display-time)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; UI

;; inhibit emacs initial messages
(setq inhibit-startup-screen t)
(setq initial-scratch-message nil)

;; No alarms.
(setq ring-bell-function 'ignore)

;; Productive default mode.
;(setq initial-major-mode 'org-mode)

;; Change cursor.
(setq-default cursor-type 'box)
(blink-cursor-mode -1)

(defalias 'yes-or-no-p 'y-or-n-p)
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(when (fboundp 'tooltip-mode) (tooltip-mode -1))
(when (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(when (fboundp 'x-cut-buffer-or-selection-value)
  (setq x-select-enable-clipboard t
        interprogram-paste-function 'x-cut-buffer-or-selection-value))

(condition-case exc
    (progn
      (add-to-list 'custom-theme-load-path
                   (concat user-emacs-directory "themes"))
      (when window-system
        (mouse-wheel-mode t)
        (blink-cursor-mode 1)
        (add-to-list 'default-frame-alist '(height . 40))
        (add-to-list 'default-frame-alist '(width . 100))
        ;; fonts
        (let ((myfont "Martian mono cn bd-14")
              (fallback-font "Consolas Bold-14"))
          (if (member myfont (font-family-list))
              (set-frame-font myfont)
            (set-frame-font fallback-font))
          (add-to-list 'default-frame-alist (cons 'font (frame-parameter nil 'font))))
        ;; themes
        (require 'package)
        (unless (package-installed-p 'gruvbox-theme)
          (package-refresh-contents)
          (package-install 'gruvbox-theme))
        (load-theme 'gruvbox-dark-hard t))
      (if (string= (getenv "TERM") "xterm-256color")
          (load-theme 'gruvbox-dark-hard t)
        (load-theme 'tango-dark t)))
  (error
   (warn (format "Caught exception: [%s]" exc))))

(delete 'try-expand-line hippie-expand-try-functions-list)
(delete 'try-expand-list hippie-expand-try-functions-list)
(add-to-list 'completion-ignored-extensions ".d")  ;; "cc -MD" depends files
(add-to-list 'completion-ignored-extensions ".test")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Initialization

(random t)
;(add-to-list 'load-path (concat dotfiles-dir "lisp"))
(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

(setq-default
 c-basic-offset 2
 c-file-style nil
 coffee-tab-width 2
 css-indent-offset 2
 fill-column 80
 save-place t
 tab-width 2
 truncate-lines t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Package Management

(require 'package)

(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)

(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))

;; Ensure use-package is installed
(when (not (package-installed-p 'use-package))
    (package-refresh-contents)
    (package-install 'use-package))

(eval-when-compile
    (require 'use-package))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; Rgrep
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package rg
    :ensure t
    :config
    (rg-define-search my/rg-project
    "Search for any files in project or current directory"
    :query ask
    :format literal
    :confirm prefix
    :files "everything"
    :flags ("--hidden -g!.git")
    :dir (if (vc-root-dir)
             (vc-root-dir)
             default-directory))
    :bind
    ("C-S-h" . my/rg-project))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CUSTOM LANGS

;; load custom langs *.el files
(dolist (file (directory-files (expand-file-name "custom" user-emacs-directory) t "\\.el$"))
  (load-file file))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(gruvbox-dark-hard))
 '(custom-safe-themes
   '("0971e976bc1092a52cf092bec03f3adf63dfdb7c1a2820ab9e214845a0f5eb72" "a5270d86fac30303c5910be7403467662d7601b821af2ff0c4eb181153ebfc0a" "d445c7b530713eac282ecdeea07a8fa59692c83045bf84dd112dd738c7bcad1d" "7422e5b955cf72a2657e0b932ce00efcaee3cffd663f5d701d2442a74ab17dbf" default))
 '(package-selected-packages
   '(yasnippet ccls flycheck-pos-tip company-box lsp-ivy rainbow-delimiters ivy projectile wgrep-ag multiple-cursors gruvbox-theme dap-mode go-add-tags go-fill-struct lsp-mode web-mode rg rainbow-mode paredit markdown-mode magit htmlize go-mode flymake-shellcheck expand-region emmet-mode))
 '(warning-suppress-types '((use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
