;;; init.el --- Configuração pessoal do Emacs -*- lexical-binding: t; -*-

;;; Commentary:

;; Configuração pessoal do Emacs incluindo temas, pacotes, LSP, magit,
;; markdown com mermaid, dashboards, e integração com opencode e mpvi.

;;; Code:

;; Otimização de GC: alto durante init, reduz depois
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold 80000000
                  gc-cons-percentage 0.1)))

;; Encoding: UTF-8 para suporte a acentos e caracteres especiais
(set-language-environment "Brazilian Portuguese")
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
;; No Windows o clipboard usa UTF-16; deixar o Emacs detectar automaticamente
;; (set-selection-coding-system 'utf-8-unix)
;; (set-clipboard-coding-system 'utf-8-unix)
(set-file-name-coding-system 'utf-8-unix)
(modify-coding-system-alist 'process "*" 'utf-8)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; COMPORTAMENTO BÁSICO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(electric-indent-mode 1)
(electric-pair-mode 1)		;; abre/fecha parênteses, chaves, colchetes, aspas
(global-subword-mode 1)
(delete-selection-mode 1)
(recentf-mode 1)
(show-paren-mode 1)
;; visual-line-mode só em buffers de texto, não globalmente
(add-hook 'text-mode-hook #'visual-line-mode)

;; Sem backups (~) ou auto-save (#) no diretório atual
(setq make-backup-files nil
      auto-save-default nil
      create-lockfiles nil)

;; F5: recarregar buffer do disco sem confirmação
(defun my/revert-buffer-no-confirm ()
  "Revert current buffer from disk without confirmation."
  (interactive)
  (revert-buffer nil t))
(global-set-key (kbd "<f5>") #'my/revert-buffer-no-confirm)

;; Configurações de rolagem
(setq scroll-error-top-bottom t
      scroll-conservatively 101
      scroll-margin 2)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; GERENCIAMENTO DE PACOTES
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("gnu" . "https://elpa.gnu.org/packages/")
			 ("nongnu" . "https://elpa.nongnu.org/nongnu/")))

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; TEMA E INTERFACE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package nerd-icons
  :config
  (with-no-warnings
    (nerd-icons-set-font)))

(use-package nerd-icons-dired
  :hook (dired-mode . nerd-icons-dired-mode))

(use-package dired-sidebar
  :bind (("<f9>" . dired-sidebar-toggle-sidebar))
  :config
  (setq dired-sidebar-theme 'nerd-icons
        dired-sidebar-use-custom-modeline nil
        dired-sidebar-width 35))

;; F6: eshell no rodapé
(defun my/eshell-toggle ()
  "Toggle eshell in a bottom window."
  (interactive)
  (let* ((buf-name "*eshell*")
         (win (get-buffer-window buf-name)))
    (if win
        (delete-window win)
      (let ((buf (get-buffer buf-name)))
        (if buf
            (with-current-buffer buf
              (cd default-directory))
          (save-window-excursion (eshell)))
        (display-buffer (get-buffer buf-name)
                        '(display-buffer-below-selected
                          . ((window-height . 0.25))))))))

(autoload 'eshell/pwd "esh-util")

(use-package eshell
  :ensure nil
  :hook ((eshell-mode . (lambda ()
                          (display-line-numbers-mode -1)
                          (setq-local buffer-face-mode-face
                                      (list :family "Consolas" :height 110))
                          (buffer-face-mode 1))))
  :config
  (with-no-warnings
    (setq eshell-prompt-function
          (lambda ()
            (concat "[" (user-real-login-name) "@"
                    (car (split-string (system-name) "\\."))
                    " " (abbreviate-file-name (eshell/pwd))
                    "]$\n"))
          eshell-highlight-prompt t
          eshell-prompt-regexp "^[^$#\n]*[$#] ?"
          eshell-scroll-to-bottom-on-input 'all
          eshell-scroll-show-maximum-output t
          eshell-hist-ignoredups t
          eshell-save-history-on-exit t)))
(global-set-key (kbd "<f6>") #'my/eshell-toggle)

(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t doom-themes-enable-italic t)
  (load-theme 'doom-one t)
  (doom-themes-org-config))

(use-package doom-modeline
  :after nerd-icons
  :hook (after-init . doom-modeline-mode))

;; Interface Clean
(setq inhibit-startup-screen t)
(set-face-attribute 'default nil :family "Hack" :height 135)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(global-display-line-numbers-mode t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DASHBOARD (CORRIGIDO PARA EVITAR ERROS NO WINDOWS)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package dashboard
  :ensure t
  :init
  (setq initial-scratch-message nil)
  :config
  (setq dashboard-center-content t
	dashboard-show-shortcuts nil
	dashboard-startupify-list (delq 'dashboard-insert-footer dashboard-startupify-list)
	dashboard-set-heading-icons t
	dashboard-set-file-icons t
	dashboard-items '((recents . 5) (projects . 5) (bookmarks . 5)))

  ;; Tenta carregar o lobo, se não existir, usa o logo oficial sem dar erro
  (let ((banner-path (expand-file-name "images/lobo.png" user-emacs-directory)))
    (if (file-exists-p banner-path)
	(setq dashboard-startup-banner banner-path)
      (setq dashboard-startup-banner 'official)))

  (dashboard-setup-startup-hook)
  (global-set-key (kbd "C-c d") #'dashboard-open))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; TYPESCRIPT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package typescript-mode
  :mode ("\\.ts\\'" "\\.tsx\\'")
  :config
  (with-eval-after-load 'eglot
    (with-no-warnings
      (add-to-list 'eglot-server-programs '(typescript-mode . ("typescript-language-server" "--stdio"))))))

(use-package eglot
  :ensure nil
  :config
  (with-no-warnings
    (add-to-list 'eglot-server-programs '(go-mode . ("gopls")))
    (add-to-list 'eglot-server-programs '(js-mode . ("typescript-language-server" "--stdio")))
    (add-to-list 'eglot-server-programs '(typescript-mode . ("typescript-language-server" "--stdio")))
    (add-to-list 'eglot-server-programs '(csharp-mode . ("OmniSharp.exe" "-lsp")))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; WEB: HTML, CSS, JSX, TSX
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package web-mode
  :mode (("\\.html?\\'" . web-mode)
         ("\\.css\\'" . web-mode)
         ("\\.jsx\\'" . web-mode)
         ("\\.tsx\\'" . web-mode))
  :config
  (setq web-mode-markup-indent-offset 2
        web-mode-css-indent-offset 2
        web-mode-code-indent-offset 2
        web-mode-enable-auto-pairing t
        web-mode-enable-auto-closing t
        web-mode-enable-auto-quoting t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; C# & DOTNET DEVELOPMENT CONFIGURATION
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package csharp-mode
  :ensure t
  :mode "\\.cs\\'"
  :config
  (setq-default c-basic-offset 4)
  (add-hook 'csharp-mode-hook
            (lambda ()
              (with-no-warnings
                (add-hook 'before-save-hook #'eglot-format-buffer nil t)
                (add-hook 'before-save-hook #'eglot-code-actions nil t)))))
(use-package nxml-mode
  :ensure nil
  :config
  (with-no-warnings
    (setq nxml-child-indent 4
          nxml-attribute-indent 4
          nxml-slash-auto-complete t)))

;; Associação de tipos de projeto C# para XML
(add-to-list 'auto-mode-alist '("\\.crproj\\'" . nxml-mode))
(add-to-list 'auto-mode-alist '("\\.csproj\\'" . nxml-mode))
(add-to-list 'auto-mode-alist '("\\.sln\\'" . text-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; GO (GOLANG)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package go-mode
  :mode ("\\.go\\'" . go-mode)
  :hook (go-mode . eglot-ensure)
  :config
  (setq-default go-tab-width 4)
  (setq indent-tabs-mode t)
  (setq tab-width 4)
  (add-hook 'go-mode-hook
            (lambda ()
              (with-no-warnings
                (add-hook 'before-save-hook #'eglot-format-buffer nil t)))))

(use-package flycheck
  :ensure t
  :config
  (global-flycheck-mode t))

(use-package flycheck-golangci-lint
  :ensure t
  :after (go-mode flycheck)
  :hook (go-mode . flycheck-golangci-lint-setup))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MARKDOWN
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar markdown-inline-image-overlays)
(defvar-local my/markdown-mermaid-overlays nil)

(defun my/markdown-render-mermaid ()
  "Render or clear mermaid diagram overlays in current buffer."
  (interactive)
  (if my/markdown-mermaid-overlays
      (progn
        (mapc #'delete-overlay my/markdown-mermaid-overlays)
        (setq markdown-inline-image-overlays
              (cl-set-difference markdown-inline-image-overlays
                                 my/markdown-mermaid-overlays))
        (setq my/markdown-mermaid-overlays nil))
    (save-excursion
      (goto-char (point-min))
      (while (re-search-forward "^```mermaid\\s-*\n\\(\\(?:.\\|\n\\)*?\\)\n```" nil t)
        (let* ((code (match-string 1))
               (start (match-beginning 0))
               (end (match-end 0))
               (hash (secure-hash 'md5 code))
               (cache-dir (expand-file-name "mermaid-cache" user-emacs-directory))
               (img-file (expand-file-name (concat hash ".png") cache-dir)))
          (unless (file-exists-p img-file)
            (unless (file-directory-p cache-dir) (mkdir cache-dir t))
            (let ((mmd-file (make-temp-file "mermaid-" nil ".mmd" code)))
              (call-process "mmdc" nil nil nil
                            "-i" mmd-file "-o" img-file
                            "--backgroundColor" "transparent")
              (delete-file mmd-file)))
          (when (file-exists-p img-file)
            (let ((image (create-image img-file)))
              (when image
                (let ((ov (make-overlay start end)))
                  (overlay-put ov 'display image)
                  (overlay-put ov 'face 'default)
                  (overlay-put ov 'mermaid t)
                  (push ov my/markdown-mermaid-overlays)
                  (push ov markdown-inline-image-overlays))))))))))

(defun my/markdown-display-html-images ()
  "Render HTML <img> tags as inline images."
  (save-excursion
    (save-restriction
      (widen)
      (goto-char (point-min))
      (while (re-search-forward "<img\\s-+src=\"\\([^\"]+\\)\"" nil t)
        (let* ((start (match-beginning 0))
               (end (match-end 0))
               (file (match-string-no-properties 1))
               (abspath (if (file-name-absolute-p file)
                            file
                          (expand-file-name file default-directory))))
          (when (file-exists-p abspath)
            (let ((image (create-image abspath)))
              (when image
                (let ((ov (make-overlay start end)))
                  (overlay-put ov 'display image)
                  (overlay-put ov 'face 'default)
                  (push ov markdown-inline-image-overlays))))))))))

(defun my/markdown-display-all-images ()
  "Display all inline images and HTML images in current buffer."
  (with-no-warnings
    (markdown-display-inline-images))
  (my/markdown-display-html-images))

(use-package markdown-mode
  :mode (("\\.md\\'" . gfm-mode)
         ("\\.markdown\\'" . gfm-mode))
  :commands (markdown-mode gfm-mode)
  :custom (markdown-display-remote-images t)
  :hook (markdown-mode . my/markdown-display-all-images)
  :bind (:map markdown-mode-command-map
         ("C-m" . my/markdown-render-mermaid)))

(use-package mermaid-mode
  :config
  (setq mermaid-output-format "png"
        mermaid-tmp-dir (expand-file-name "mermaid" temporary-file-directory))
  :bind (:map mermaid-mode-map
         ("C-c C-c" . mermaid-compile)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DOCKER
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package dockerfile-mode
  :mode ("Dockerfile\\'" "\\.dockerfile\\'"))

(use-package docker-compose-mode
  :mode ("docker-compose\\.ya?ml\\'"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; GIT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package magit
  :bind ("C-c g" . magit-status)
  :config
  (setq magit-display-buffer-function
        (with-no-warnings
          #'magit-display-buffer-same-window-except-diff-v1)))

(global-set-key (kbd "<f7>") #'my/magit-toggle-log)

(defun my/magit-toggle-log ()
  "Toggle magit log buffer in a bottom window."
  (interactive)
  (let* ((log-buf (cl-find-if (lambda (b)
                                (with-current-buffer b
                                  (derived-mode-p 'magit-log-mode)))
                              (buffer-list)))
         (log-win (and log-buf (get-buffer-window log-buf))))
    (if log-win
        (delete-window log-win)
      (unless (and log-buf (buffer-live-p log-buf))
        (save-window-excursion
          (magit-log-all '("--oneline" "--decorate" "-n30")))
        (setq log-buf (cl-find-if (lambda (b)
                                    (with-current-buffer b
                                      (derived-mode-p 'magit-log-mode)))
                                  (buffer-list))))
      (when (and log-buf (buffer-live-p log-buf))
        (display-buffer log-buf '(display-buffer-below-selected
                                  . ((window-height . 0.25))))))))

(use-package git-timemachine
  :bind ("C-c t" . git-timemachine-toggle))

(use-package git-messenger
  :bind ("C-c p" . git-messenger:popup-message)
  :config
  (setq git-messenger:show-detail t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MPVI - Watch videos and take interactive video notes in Emacs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package mpvi
  :ensure t
  :config
  (setq mpvi-mpv-ontop-p t)
  (setq mpvi-mpv-border-p t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; OPENCODE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; OPENCODE (cliente Emacs nativo via modo servidor SSE)
(use-package request
  :ensure t)
(use-package emacs-opencode
  :load-path "C:/Users/lobor/AppData/Roaming/.emacs.d/jdormit-emacs-opencode"
  :after request
  :commands (opencode opencode-ask opencode-ask-contextual)
  :custom
  (opencode-server-command "C:/Users/lobor/AppData/Roaming/npm/opencode.cmd"))
(global-set-key (kbd "<f8>")
  (lambda ()
    (interactive)
    (opencode default-directory)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; RECURSOS DE DEV
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package ivy
  :ensure t
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t
        ivy-count-format "(%d/%d) ")
  (setq enable-recursive-minibuffers t))

(use-package counsel
  :ensure t
  :after ivy
  :config
  (counsel-mode 1)
  ;; Atalhos recomendados para o Counsel
  :bind (("M-x" . counsel-M-x)
         ("C-x C-f" . counsel-find-file)
         ("C-x b" . counsel-switch-buffer)
         ("C-h v" . counsel-describe-variable)
         ("C-h f" . counsel-describe-function)
         ("C-c s" . counsel-rg)))


;; Tenta usar fontes específicas para emojis e símbolos se elas existirem no Windows
(when (member "Segoe UI Emoji" (font-family-list))
  (set-fontset-font t 'unicode "Segoe UI Emoji" nil 'prepend))

(when (member "Symbola" (font-family-list))
  (set-fontset-font t 'unicode "Symbola" nil 'prepend))

;; Melhora a renderização de ícones se você estiver usando nerd-icons/all-the-icons
(setq-default use-fallback-font t)

;; Buffer-move: mover janela atual para cima/baixo/esquerda/direita
(use-package buffer-move
  :ensure t
  :bind (("C-c <left>" . buf-move-left)
         ("C-c <right>" . buf-move-right)
         ("C-c <up>" . buf-move-up)
         ("C-c <down>" . buf-move-down)))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(browse-url-browser-function 'browse-url-firefox)
 '(package-selected-packages nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(provide 'init)
;;; init.el ends here
