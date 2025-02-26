;;; init.el --- Emacs configuration -*- lexical-binding: t -*-

;;; Commentary:
;;; Configuração do Emacs para Windows

;;; Code:

;; Package Management (keep this at the top)
(require 'package)

;; Add package repositories with fallbacks
(setq package-archives
      '(("gnu" . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")
        ("melpa" . "https://melpa.org/packages/")
        ("melpa-stable" . "https://stable.melpa.org/packages/")
        ("org" . "https://orgmode.org/elpa/")))

;; Initialize package system
(package-initialize)

;; Refresh package contents if needed, with error handling
(unless package-archive-contents
  (condition-case err
      (package-refresh-contents)
    (error (message "Error refreshing package contents: %s" err))))

;; Bootstrap use-package with error handling
(unless (package-installed-p 'use-package)
  (condition-case err
      (package-install 'use-package)
    (error (message "Error installing use-package: %s" err))))

(require 'use-package)
(setq use-package-always-ensure t)
(setq use-package-always-defer nil)  ;; Load packages immediately by default
(setq use-package-verbose t)         ;; Show more information during loading
(setq use-package-minimum-reported-time 0.1) ;; Report packages that take >0.1s to load

;; Set up custom file early
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(unless (file-exists-p custom-file)
  (write-region "" nil custom-file))
(load custom-file)

;; Set to nil once configuration is stable
(setq debug-on-warning nil)

;; Use a more portable approach for backup files
(setq backup-directory-alist
      `(("." . ,(expand-file-name "backups" user-emacs-directory))))

;; Add compatibility libraries
(use-package cl-lib
  :ensure t)

;; Proxy settings (disabled by default)
(setq url-proxy-services nil)

;; hotkey custom ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(global-set-key (kbd "C-c C-c") 'comment-or-uncomment-region)

;; treemacs keybind - usando a função personalizada
;; (global-set-key (kbd "<f5>") 'treemacs)  ;; Comentado ou removido

;; Helm keybindings with checks
(when (fboundp 'helm-M-x)
  (global-set-key (kbd "M-x") 'helm-M-x))
(when (fboundp 'helm-find-files)
  (global-set-key (kbd "C-x C-f") 'helm-find-files))
(when (fboundp 'helm-mini)
  (global-set-key (kbd "C-x b") 'helm-mini))
(when (fboundp 'helm-occur)
  (global-set-key (kbd "C-s") 'helm-occur))

;; Projectile keybindings
(define-key global-map (kbd "C-c p") 'projectile-command-map)

;; Magit keybindings
(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key (kbd "C-x M-g") 'magit-dispatch)

;; Multiple-cursors keybindings
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

;; LSP mode keybindings
(define-prefix-command 'lsp-command-map)
(global-set-key (kbd "C-c l") 'lsp-command-map)
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

;; Shell keybindings
;;(global-set-key (kbd "C-c e") 'vterm) 


;; Load all custom configuration files
(let ((custom-dir (expand-file-name "custom" user-emacs-directory)))
  (when (file-exists-p custom-dir)
    (dolist (file (directory-files custom-dir t "\\.el$"))
      (load-file file))))

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
  ;; Considerar mais tipos de arquivos como marcadores de projeto
  (setq projectile-project-root-files-bottom-up
        '(".git" ".hg" ".fslckout" "_FOSSIL_" ".bzr" "_darcs"
          "package.json" "setup.py" "Cargo.toml" "go.mod"
          "Makefile" "README.md" "README.org"))
  ;; Habilitar cache para melhor desempenho
  (setq projectile-enable-caching t)
  ;; Forçar o Projectile a indexar projetos na inicialização
  (projectile-discover-projects-in-search-path)
  :bind-keymap ("C-c p" . projectile-command-map))

;; Counsel-projectile
(use-package counsel-projectile
  :ensure t
  :defer t
  :after (counsel projectile)
  :init
  (condition-case err
      (counsel-projectile-mode)
    (error (message "Error loading counsel-projectile: %s" err))))

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
  :ensure t
  :config
  ;; Configurações gerais
  (setq treemacs-follow-mode t          ;; Seguir o buffer atual
        treemacs-filewatch-mode t       ;; Observar mudanças no sistema de arquivos
        treemacs-fringe-indicator-mode 'always ;; Sempre mostrar indicador de fringe
        treemacs-project-follow-mode t   ;; Seguir o projeto atual
        treemacs-recenter-after-file-follow 'on-distance ;; Recentralizar quando necessário
        treemacs-width 35)              ;; Largura da janela do Treemacs
  
  ;; Desativar a persistência do Treemacs para evitar que ele sempre abra no mesmo projeto
  (setq treemacs-persist-file "/dev/null")  ;; Arquivo de persistência inválido (no Windows, use "NUL")
  (when (eq system-type 'windows-nt)
    (setq treemacs-persist-file "NUL"))     ;; Versão para Windows
  (setq treemacs-no-load-persistence-file t)  ;; Não carregar o arquivo de persistência
  (setq treemacs-no-save-persistence-file t)  ;; Não salvar o arquivo de persistência
  
  ;; Função revisada para abrir o Treemacs no diretório atual
  (defun treemacs-toggle-in-current-directory ()
    "Toggle treemacs, always showing the current directory or project."
    (interactive)
    (pcase (treemacs-current-visibility)
      ('visible
       ;; Se o Treemacs já estiver visível, feche-o
       (delete-window (treemacs-get-local-window)))
      (_
       ;; Se o Treemacs não estiver visível
       (let ((path (cond
                    ;; Primeiro tenta usar o arquivo atual
                    (buffer-file-name (file-name-directory buffer-file-name))
                    ;; Depois tenta usar o projectile
                    ((and (fboundp 'projectile-project-root)
                          (condition-case nil
                              (projectile-project-root)
                            (error nil))))
                    ;; Finalmente, usa o diretório atual
                    (t default-directory))))
         ;; Garantir que temos um diretório válido
         (when (and path (file-directory-p path))
           ;; Inicializar o Treemacs
           (treemacs--init)
           
           ;; Limpar todos os workspaces
           (treemacs--remove-all-workspaces-and-projects)
           
           ;; Criar um novo workspace com o diretório atual
           (let ((workspace (treemacs-workspace->create! :name "Default")))
             (treemacs--add-project-to-workspace
              (treemacs-project->create!
               :name (file-name-nondirectory (directory-file-name path))
               :path path
               :path-status 'local-readable)
              workspace)
             (treemacs--find-workspace workspace)
             (setf (treemacs-current-workspace) workspace))
           
           ;; Selecionar a janela do Treemacs
           (treemacs-select-window)
           
           ;; Atualizar o buffer do Treemacs
           (treemacs--render-projects))))))
  
  ;; Substituir o keybinding padrão pela nossa função personalizada
  (global-set-key [f5] 'treemacs-toggle-in-current-directory)
  
  ;; Configurações adicionais para garantir que o Treemacs não persista
  (setq treemacs-project-follow-cleanup t)       ;; Limpar projetos não utilizados
  (setq treemacs-workspace-switch-cleanup 'all)  ;; Limpar tudo ao mudar de workspace
  (setq treemacs-is-never-other-window nil)      ;; Permitir que o Treemacs seja considerado como "outra janela"
  (setq treemacs-show-hidden-files t)            ;; Mostrar arquivos ocultos
  (setq treemacs-silent-refresh t)               ;; Atualizar silenciosamente
  (setq treemacs-sorting 'alphabetic-asc))       ;; Ordenar alfabeticamente

;; Integração do Treemacs com o Projectile
(use-package treemacs-projectile
  :ensure t
  :after (treemacs projectile))

;; Integração do Treemacs com o Magit
(use-package treemacs-magit
  :ensure t
  :after (treemacs magit))

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

;; Helm with error handling
(use-package helm
  :ensure t
  :defer t
  :init
  (condition-case err
      (progn
        ;; Don't try to load helm-config as it might not exist in newer versions
        (when (locate-library "helm-config")
          (require 'helm-config))
        (helm-mode 1))
    (error (message "Error loading Helm: %s" err)))
  :config
  (when (featurep 'helm)
    (setq helm-split-window-in-side-p t)
    (setq helm-autoresize-max-height 30)
    (setq helm-autoresize-min-height 30)
    (helm-autoresize-mode 1)))

;; Compatibility aliases
(defalias 'point-at-bol 'line-beginning-position)
(defalias 'point-at-eol 'line-end-position)
(defalias 'first 'cl-first)

;; Fix for find-function-source-path warning
(setq find-library-source-path load-path)

;; Package installation helper
(defun ensure-package-installed (&rest packages)
  "Make sure PACKAGES are installed locally."
  (dolist (package packages)
    (unless (package-installed-p package)
      (condition-case nil
          (package-install package)
        (error
         (message "Couldn't install %s, will use local version if available" package))))))

;; Try to install essential packages
(ensure-package-installed 'helm 'counsel 'projectile 'counsel-projectile 'ivy)

;; Carregar chaves de API se o arquivo existir
(let ((api-keys-file (expand-file-name "api-keys.el" user-emacs-directory)))
  (when (file-exists-p api-keys-file)
    (load-file api-keys-file)))

;; Instalação simplificada do aider
(defun download-and-install-aider ()
  "Download and install aider.el manually."
  (interactive)
  (let ((aider-dir (expand-file-name "lisp/aider" user-emacs-directory))
        (aider-file (expand-file-name "lisp/aider/aider.el" user-emacs-directory)))
    
    ;; Criar diretório se não existir
    (unless (file-directory-p aider-dir)
      (make-directory aider-dir t))
    
    ;; Baixar aider.el do GitHub
    (url-copy-file "https://raw.githubusercontent.com/tninja/aider.el/main/aider.el" 
                   aider-file t)
    
    ;; Adicionar ao load-path
    (add-to-list 'load-path aider-dir)
    
    ;; Carregar aider.el
    (condition-case err
        (require 'aider)
      (error (message "Erro ao carregar aider: %s" err)))
    
    (message "aider.el instalado com sucesso!")))

;; Executar a instalação durante a inicialização
(unless (featurep 'aider)
  (condition-case err
      (download-and-install-aider)
    (error (message "Erro ao instalar aider.el: %s" err))))

;; Configurar aider após a instalação
(with-eval-after-load 'aider
  (message "Aider carregado com sucesso!")
  ;; For claude-3-5-sonnet
  (setq aider-args '("--model" "sonnet"))
  ;; Use API key from api-keys.el
  (when (boundp 'anthropic-api-key)
    (setenv "ANTHROPIC_API_KEY" anthropic-api-key)))

;; Adicionar keybinding para abrir o Treemacs no arquivo atual
(defun treemacs-toggle-and-find-file ()
  "Toggle treemacs and find the current file."
  (interactive)
  (if (eq (treemacs-current-visibility) 'visible)
      ;; Se o Treemacs já estiver visível, feche-o
      (delete-window (treemacs-get-local-window))
    ;; Se o Treemacs não estiver visível, abra-o e encontre o arquivo atual
    (treemacs)
    (when buffer-file-name
      (treemacs-find-file buffer-file-name))))

;; Substituir o keybinding F5 pela nova função
(global-set-key [f5] 'treemacs-toggle-and-find-file)

(provide 'init)
;;; init.el ends here
