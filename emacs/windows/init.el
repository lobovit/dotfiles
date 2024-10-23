;;; Configuração do Emacs para Windows

(setq debug-on-warning nil) ; Desativado para evitar muitos logs de depuração

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Vinculação de Chaves

;; Recarregar configuração do Emacs
(global-set-key [f2] 'eval-buffer)
(global-set-key [f6] 'dired)
(global-set-key [f4] 'treemacs)


;; powershell
(use-package powershell
  :ensure t
  :bind ("C-x t" . powershell)
  :config
  ;; Configurações adicionais para o PowerShell
  (setq explicit-shell-file-name "C:/Windows/System32/WindowsPowerShell/v1.0/powershell.exe")
  (setq shell-command-switch "-Command"))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Global Settings

(auto-compression-mode t)
(global-display-line-numbers-mode t)
(global-font-lock-mode t)
(global-subword-mode 1)
(ido-mode t)
(recentf-mode 1)
(show-paren-mode 1)
(global-visual-line-mode 1)
(delete-selection-mode 1)
(column-number-mode t)
(auto-fill-mode 1)

(setq-default indent-tabs-mode nil
              require-final-newline t
              show-trailing-whitespace t
              x-stretch-cursor t
              truncate-lines nil)

(setq create-lockfiles nil
      save-interprogram-paste-before-kill nil
      select-enable-primary nil
      electric-pair-mode 1
      electric-indent-mode 1
      line-number-mode t
      column-number-mode t
      select-enable-clipboard t
      bidi-display-reordering 'left-to-right)

(add-hook 'before-save-hook 'whitespace-cleanup)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; LSP, Helm, Projectile, etc.

(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa" . "https://elpa.gnu.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")))

(package-initialize)

(unless package-archive-contents (package-refresh-contents))

(setq package-list '(use-package))
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))


;; Chords
(use-package use-package-chords
  :ensure t
  :init
  :config (key-chord-mode 1)
(setq key-chord-two-keys-delay 0.4)
(setq key-chord-one-key-delay 0.5))

;; Projectile
(use-package projectile
  :ensure t
  :init (projectile-mode +1)
  :config
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))

;; Helm
(use-package helm
  :ensure t
  :init (helm-mode 1)
  :bind
  (("C-c h" . helm-command-prefix)
   ("M-x" . helm-M-x)
   ("C-x C-f" . helm-find-files)
   ("C-x b" . helm-buffers-list)
   ("C-c b" . helm-bookmarks)
   ("C-c f" . helm-recentf)
   ("C-c g" . helm-grep-do-git-grep)))

(use-package helm-descbinds
  :ensure t
  :bind ("C-h b" . helm-descbinds))

(use-package helm-swoop
:ensure t
:chords
("js" . helm-swoop)
("jp" . helm-swoop-back-to-last-point)
:init
(bind-key "M-m" 'helm-swoop-from-isearch isearch-mode-map)

;; If you prefer fuzzy matching
(setq helm-swoop-use-fuzzy-match t)

;; Save buffer when helm-multi-swoop-edit complete
(setq helm-multi-swoop-edit-save t)

;; If this value is t, split window inside the current window
(setq helm-swoop-split-with-multiple-windows nil)

;; Split direction. 'split-window-vertically or 'split-window-horizontally
(setq helm-swoop-split-direction 'split-window-vertically)

;; If nil, you can slightly boost invoke speed in exchange for text color
(setq helm-swoop-speed-or-color nil)

;; ;; Go to the opposite side of line from the end or beginning of line
(setq helm-swoop-move-to-line-cycle t)

)

;; magit
(unless (package-installed-p 'magit)
  (package-refresh-contents)
  (package-install 'magit))

;; Carrega o Magit automaticamente
(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)))

(use-package yasnippet-snippets :ensure t)

;; Avy
(use-package avy
  :ensure t
  :chords
  (("jc" . avy-goto-char)
   ("jw" . avy-goto-word-1)
   ("jl" . avy-goto-line)))

;; Company
(use-package company
  :ensure t)

;; Flycheck
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

;; DAP Mode
(use-package dap-mode
  :ensure t
  :after lsp-mode
  :bind (:map lsp-mode-map
              ("<f5>" . dap-debug)
              ("M-<f5>" . dap-hydra))
  :hook ((dap-mode . dap-ui-mode)
         (dap-session-created . (lambda (&_rest) (dap-hydra)))
         (dap-terminated . (lambda (&_rest) (dap-hydra/nil)))))

(use-package dap-java :ensure nil)

;; LSP Mode
(use-package lsp-mode
  :ensure t
  :hook ((java-mode . #'lsp-deferred))
  :init (setq lsp-keymap-prefix "C-c l"
              lsp-enable-file-watchers nil
              read-process-output-max (* 1024 1024)
              lsp-completion-provider :capf
              lsp-idle-delay 0.500)
  :config (define-key lsp-mode-map (kbd "C-c l") lsp-command-map))

;; LSP UI
(use-package lsp-ui
  :ensure t
  :bind (:map lsp-ui-mode-map
              ([remap xref-find-definitions] . lsp-ui-peek-find-definitions)
              ([remap xref-find-references] . lsp-ui-peek-find-references))
  :init (setq lsp-ui-doc-delay 1.5
              lsp-ui-doc-position 'bottom
              lsp-ui-doc-max-width 100))

;; Treemacs
(use-package lsp-treemacs
  :ensure t
  :commands lsp-treemacs-errors-list
  :bind (:map lsp-mode-map
              ("M-9" . lsp-treemacs-errors-list)))

(with-eval-after-load 'treemacs
  (setq treemacs-follow-after-init t)
  (treemacs-follow-mode t)
  (treemacs-project-follow-mode t))


(use-package treemacs
  :ensure t
  :commands (treemacs)
  :after (lsp-mode))

;; Quickrun
(use-package quickrun
  :ensure t
  :bind ("C-c r" . quickrun))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Appearance & Fonts

;; Theme
(use-package doom-themes
  :ensure t
  :init (load-theme 'doom-palenight t))

;; Font
(set-face-attribute 'default nil :family "Consolas" :height 140 :weight 'bold)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Eshell Config

(defun disable-company-in-eshell ()
  "Disable company-mode in eshell."
  (company-mode -1))

(add-hook 'eshell-mode-hook 'disable-company-in-eshell)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Custom Settings

;; Backup em ~/.saves
(setq backup-directory-alist `(("." . "~/.saves")))

;; Display Date & Time
(setq display-time-day-and-date t
      display-time-format "%a %b %d %R"
      display-time-interval 60
      display-time-default-load-average nil)
(display-time)

;; Miscellaneous UI Settings
(setq inhibit-startup-screen t
      initial-scratch-message nil
      ring-bell-function 'ignore
      cursor-type 'box)

(defalias 'yes-or-no-p 'y-or-n-p)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(tooltip-mode -1)
(menu-bar-mode -1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; End of Configuration
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("51fa6edfd6c8a4defc2681e4c438caf24908854c12ea12a1fbfd4d055a9647a3" "7ec8fd456c0c117c99e3a3b16aaf09ed3fb91879f6601b1ea0eeaee9c6def5d9" "d6b934330450d9de1112cbb7617eaf929244d192c4ffb1b9e6b63ad574784aad" "fa49766f2acb82e0097e7512ae4a1d6f4af4d6f4655a48170d0a00bcb7183970" "e3a1b1fb50e3908e80514de38acbac74be2eb2777fc896e44b54ce44308e5330" "551320837bd87074e3de38733e0a8553618c13f7208eda8ec9633d59a70bc284" "f5f80dd6588e59cfc3ce2f11568ff8296717a938edd448a947f9823a4e282b66" "2ff9ac386eac4dffd77a33e93b0c8236bb376c5a5df62e36d4bfa821d56e4e20" "b6269b0356ed8d9ed55b0dcea10b4e13227b89fd2af4452eee19ac88297b0f99" "88f7ee5594021c60a4a6a1c275614103de8c1435d6d08cc58882f920e0cec65e" "c8b83e7692e77f3e2e46c08177b673da6e41b307805cd1982da9e2ea2e90e6d7" "89c50e934a32921ed51da9fa883484a433f32fbc5cf9780860d13322e23edcde" "e8ceeba381ba723b59a9abc4961f41583112fc7dc0e886d9fc36fa1dc37b4079" "4ade6b630ba8cbab10703b27fd05bb43aaf8a3e5ba8c2dc1ea4a2de5f8d45882" "014cb63097fc7dbda3edf53eb09802237961cbb4c9e9abd705f23b86511b0a69" "7c340289e943a8e1fdd76152014b75a976912caaa93285d9ff9581641166221b" default))
 '(package-selected-packages
   '(powershell suscolors-theme monokai-pro-theme org-plus-contrib dracula-theme ewal-doom-themes flycheck-rust magit yasnippet-snippets which-key use-package-chords slime rg quickrun python-mode projectile lsp-ui lsp-pyright lsp-javacomp lsp-java lsp-ivy helm-swoop helm-lsp helm-descbinds heaven-and-hell gruvbox-theme go-fill-struct go-add-tags flycheck-pos-tip doom-themes company-box clj-refactor ccls avy-zap)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
