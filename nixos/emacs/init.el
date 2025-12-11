;;; init.el --- Configuração pessoal do Emacs -*- lexical-binding: t; -*-

;;; Commentary:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; COMPORTAMENTO BÁSICO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Code:
;;(electric-pair-mode 1)                           ;; Ativar o modo de automático para ()[]{}
(electric-indent-mode 1)                         ;; Ativar o modo de indentação
(global-subword-mode 1)                          ;; Ativar o modo de subpalavras
(delete-selection-mode 1)                        ;; Ativar o modo de seleção
(global-visual-line-mode 1)                      ;; Ativar quebra de linha automática
(auto-fill-mode 1)                               ;; Ativar o modo de preenchimento automático

;; Modos globais
(add-hook 'before-save-hook 'whitespace-cleanup) ;; Limpar espaços em branco antes de salvar
(auto-compression-mode t)                        ;; Ativar o modo de compressão automática
(global-font-lock-mode t)                        ;; Ativar o modo de coloração de sintaxe
(recentf-mode 1)                                 ;; Ativar o modo de recentes
(show-paren-mode 1)                              ;; Ativar o modo de parênteses

;; Configurações de rolagem e navegação
(setq scroll-error-top-bottom t)                 ;; Melhor comportamento de rolagem
(setq scroll-conservatively 101)                 ;; Evitar saltos na rolagem
(setq scroll-margin 2)                           ;; Manter algumas linhas visíveis ao rolar
(setq next-line-add-newlines nil)                ;; Não adicionar novas linhas ao final do buffer

;; Configurações de marcas
(setq set-mark-command-repeat-pop t)             ;; Permitir C-u C-SPC para voltar na marca
(setq mark-ring-max 16)                          ;; Aumentar o tamanho do anel de marcas
(setq global-mark-ring-max 32)                   ;; Aumentar o tamanho do anel global de marcas

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; INICIALIZAÇÃO DE PACOTES (Essencial para NixOS/Linux)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'package)

;; Define os repositórios
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("gnu" . "https://elpa.gnu.org/packages/")
			 ("nongnu" . "https://elpa.nongnu.org/nongnu/")))

;; NOTA: removi o (package-initialize) para sumir com o Warning.
;; O Emacs moderno faz isso sozinho.
;; CORREÇÃO DO ERRO "PACKAGE UNAVAILABLE":
;; Se a lista de pacotes estiver vazia, forçamos o download agora.
(unless (package-installed-p 'use-package)
  ;; Só atualiza os repositórios se o use-package ainda não existir
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DEFAULT THEME
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Pré-requisito para o doom-modeline (ícones)
(use-package nerd-icons
  :ensure t
  ;; Define a fonte de ícones que o nerd-icons deve usar.
  ;; Isso garante que os ícones sejam exibidos corretamente, mesmo que a fonte principal
  ;; do Emacs não seja uma Nerd Font (como no seu caso, que usa apenas "Hack").
  :custom
  (nerd-icons-font-family "Symbols Nerd Font Mono")
  )

(use-package doom-themes
  :ensure t
  :config
  (setq doom-themes-enable-bold t
	doom-themes-enable-italic t)
  (load-theme 'doom-one t)
  (doom-themes-org-config))

;; Customizar o estilo dos itens do Dashboard AQUI, após o tema ser carregado
  (custom-theme-set-faces
   'doom-one
   '(dashboard-heading ((t (:inherit (doom-modeline-bar fg) :height 1.2 :weight semi-bold))))
   '(dashboard-item-mru ((t (:inherit (doom-modeline-bar fg) :height 1.0))))
   '(dashboard-item-project ((t (:inherit (doom-modeline-bar fg) :height 1.0))))
   '(dashboard-button ((t (:inherit (doom-modeline-bar fg) :height 1.0))))
   )


(use-package doom-modeline
  :ensure t
  :after nerd-icons
  :hook (after-init . doom-modeline-mode)
  :custom
  (doom-modeline-height 25))   ;; Altura da barra


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; TELA DE INICIALIZAÇÃO (DASHBOARD) - CORRIGIDO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(eval-when-compile
  (defvar dashboard-show-doom-logo)
  (defvar dashboard-image-area)
  (defvar dashboard-image-scaling))

(use-package dashboard
  :ensure t
  :init
  ;; Desativar tela padrão logo no começo
  (setq inhibit-startup-screen t
	initial-scratch-message nil)
  :config
  ;; Configurações do Dashboard
  (setq dashboard-center-content t
	dashboard-show-doom-logo nil
	dashboard-footer-messages nil
	dashboard-startup-banner
	(expand-file-name "images/lobo.png" user-emacs-directory)
	dashboard-items '((recents  . 5)
			  (projects . 5)
			  (bookmarks . 5)
			  (agenda . 5)))

  ;; Hook oficial recomendado
  (dashboard-setup-startup-hook)

  ;; Atalho para voltar ao dashboard
  (global-set-key (kbd "C-c d") #'dashboard-open))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; INTERFACE CLEAN
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Configuração de cursor e edição
(setq cursor-type 'box
  blink-cursor-mode nil
  create-lockfiles nil
  save-interprogram-paste-before-kill nil
  select-enable-clipboard t
  ring-bell-function 'ignore
)

;; Configuração de fonte, barra de rolagem e menu
(set-face-attribute 'default nil :family "Hack Nerd Font Mono" :height 120)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(tooltip-mode -1)

;; Exibição de colunas
(global-display-line-numbers-mode t)
(line-number-mode t)
(column-number-mode t)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ORG-MODE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(use-package org-modern
  :ensure t
  :after org
  :hook (org-mode . org-modern-mode))

;; Opções adicionais para um visual moderno (Opcional)

;; 1. Usar fonte Proporcional no corpo do texto (como em um editor de texto)
(add-hook 'org-mode-hook 'variable-pitch-mode)

;; 2. Ocultar todos os asteriscos de títulos, exceto o primeiro (limpa a visualização)
(setq org-hide-leading-stars t)

;; 3. Adicionar mais espaço entre os títulos (mais contraste)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PRODUTIVIDADE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; which-key: mostra sugestões de atalhos conforme você digita (ex: C-c ...)
(use-package which-key
  :init
  ;; Tempo até o which-key aparecer após você começar a digitar um prefixo
  (setq which-key-idle-delay 2.0
    which-key-idle-secondary-delay 1.0)
  :config
  ;; Ativa o modo which-key globalmente
  (which-key-mode))

;; Define o número máximo de arquivos salvos no histórico do recentf
(setq recentf-max-saved-items 100)

;; prescient: aprendizado automático de ordenação de itens (melhora buscas)
(use-package prescient
  :config
  ;; Persiste o histórico de priorização entre sessões
  (prescient-persist-mode))

;; ivy: Core interface para minibuffer aprimorado (M-x, C-x b)
(use-package ivy
  :config
  ;; Ativa Ivy globalmente (substitui M-x, C-x b, etc.)
  (ivy-mode 1)
  ;; Mostra buffers recentes
  (setq ivy-use-virtual-buffers t))

;; swiper: Busca interativa no buffer atual (substitui C-s padrão)
(use-package swiper
  :bind (("C-S-s" . swiper) ;; Mantendo o atalho C-S-s original
	 ("C-s" . swiper)
	 ("C-r" . swiper)))

;; rg (rip-grep): Interface direta para busca rápida de conteúdo em arquivos
(use-package rg
  :bind (("C-c r" . rg))) ;; C-c r agora chama o rg diretamente

;; helpful: substitui o help padrão com explicações muito melhores
(use-package helpful
  :init
  ;; Configurações dependentes de counsel foram removidas
  )

;; dired-sidebar: painel lateral simples baseado no dired
(use-package dired-sidebar
  :bind ([f5] . dired-sidebar-toggle-sidebar)
  :hook (dired-sidebar-mode . all-the-icons-dired-mode))

;; all-the-icons: coleção de ícones usada por vários plugins
(use-package all-the-icons
  :defer)

;; Ícones dentro do dired
(use-package all-the-icons-dired
  :after all-the-icons)

;; ctrlf: substitui isearch com navegação mais moderna
(use-package ctrlf
  :config
  (ctrlf-mode))

;; goto-chg: pular para última mudança no buffer
(use-package goto-chg
  :bind ("C-c G" . goto-last-change)) ;; volta para a última edição

;; smartparens: manipulação inteligente de parênteses e blocos
(use-package smartparens
  :hook ((prog-mode . smartparens-mode)          ;; ativa em linguagens
     (emacs-lisp-mode . smartparens-strict-mode)) ;; strict mode em elisp
  :init
  (setq sp-base-key-bindings 'sp)
  :config
  ;; atalhos úteis dentro do smartparens
  (define-key smartparens-mode-map [M-backspace] #'backward-kill-word)
  (define-key smartparens-mode-map [M-S-backspace] #'sp-backward-unwrap-sexp)
  ;; carrega configuração padrão
  (require 'smartparens-config))

;; multiple-cursors: múltiplos cursores simultâneos
(use-package multiple-cursors
  :bind (("C-c n" . mc/mark-next-like-this);; seleciona próxima ocorrência
	 ("C-c p" . mc/mark-previous-like-this))) ;; seleciona ocorrência anterior

;; ws-butler: remove espaços em branco só nas linhas editadas
(use-package ws-butler
  :hook (prog-mode . ws-butler-mode))

;; Atalho rápido para salvar posição em um register
(defalias 'pr #'point-to-register)

;; C-c 1 ... C-c 9 mudam tabs do tab-bar
(dolist (i (number-sequence 1 9))
  (global-set-key (format "\C-c%d" i)
    `(lambda () (interactive) (tab-select ,i))))

;; Ativa interface de abas nativa do Emacs
(tab-bar-mode 1)

;; Ativa abbrev globally (expansões automáticas de texto)
(setq-default abbrev-mode 1)

;; company-mode: autocomplete
(use-package company
  :bind (:map prog-mode-map
     ("C-i" . company-indent-or-complete-common) ;; TAB inteligente
       )
  :hook (emacs-lisp-mode . company-mode)
  :config
  ;; Adiciona company-capf para usar o Eglot como backend no Elixir
  (add-hook 'elixir-mode-hook
	    (lambda ()
	      (setq-local company-backends '(company-capf company-dabbrev-code company-files))
	      (company-mode))))

;; company-prescient: ordenação inteligente no autocomplete
(use-package company-prescient
  :after company
  :config
  (company-prescient-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; GIT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package magit
  :bind (("C-x g" . magit-status)
	 ("C-x M-g" . magit-dispatch))
  :init
  (setq project-switch-commands nil)) ; avoid magit error on C-n/C-p

(use-package git-messenger
  :bind ("C-x G" . git-messenger:popup-message)
  :config
  (setq git-messenger:show-detail t
	git-messenger:use-magit-popup t))

(use-package git-timemachine
  :bind ("C-c t" . git-timemachine))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ELIXIR DEV
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package elixir-mode
  :ensure t
  ;; Chama sua função de setup e o Eglot ao iniciar o modo
  :hook ((elixir-mode . my/elixir-setup)
	 (elixir-mode . eglot-ensure))
  :config
  (defun my/elixir-setup ()
    ;; formatar com mix format ao salvar
    (add-hook 'before-save-hook #'elixir-format nil t)))

;; Dependência de linter (mantida)
(use-package flycheck-credo
  :after flycheck
  :config
  (flycheck-credo-setup))

;; Seus helpers (mantidos)
(defun my/elixir-mix-test-file ()
  ;; ... código ...
  )
(defun my/elixir-iex ()
  ;; ... código ...
  )
(global-set-key (kbd "C-c t") #'my/elixir-mix-test-file)
(global-set-key (kbd "C-c i") #'my/elixir-iex)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; TYPESCRIPT DEV
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package typescript-mode
  :ensure t
  :mode ("\\.ts\\'" "\\.tsx\\'")
  ;; Simplesmente garante que o Eglot inicie quando este modo for carregado
  :hook (typescript-mode . eglot-ensure))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; LSP GLOBAL: Eglot
;; Define quais servidores rodar para quais modos
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package eglot
  :ensure nil                          ;; Já vem no Emacs 29+
  :config
  ;; Adiciona servidores para todas as linguagens aqui
  (add-to-list 'eglot-server-programs
    ;; 1. Elixir Server
    '(elixir-mode . ("elixir-ls")))

  (add-to-list 'eglot-server-programs
    ;; 2. TypeScript/JavaScript Server
    '(typescript-mode . ("typescript-language-server" "--stdio")))

  (add-to-list 'eglot-server-programs
    ;; (Recomendado) Aplica o mesmo servidor para arquivos .js
    '(js-mode . ("typescript-language-server" "--stdio")))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Eshell
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; 1. Variáveis de Configuração Global
(setq eshell-history-size 5000
      eshell-buffer-maximum-lines 5000
      eshell-directory-name (expand-file-name "eshell" user-emacs-directory)
      eshell-save-some-history t
      eshell-scroll-to-bottom-on-input t
      eshell-prefer-lisp-functions nil)

;; 2. Prompt Personalizado (Sem alteração)
(defun my/eshell-prompt-function ()
  (let* ((dir (eshell/pwd))
	 (dir-display (if (equal dir "~") dir (file-name-nondirectory dir)))
	 (git-branch (if (featurep 'magit) (magit-get-current-branch) nil))
	 (prompt-color (face-attribute 'font-lock-keyword-face :foreground))
	 (git-string (if git-branch (format " [%s]" git-branch) ""))
	 )
    (insert (propertize (format "%s%s" dir-display git-string)
			'face `(:foreground ,prompt-color :weight bold)))
    (insert "\nλ ")
    )
  )
(setq eshell-prompt-function 'my/eshell-prompt-function)


;; 3. Hooks e Bindings (CORRIGIDO C-r)
(add-hook 'eshell-mode-hook
	  (lambda ()
	    (define-key eshell-mode-map (kbd "<up>") 'eshell-previous-prompt)
	    (define-key eshell-mode-map (kbd "<down>") 'eshell-next-prompt)

	    ;; Substitui counsel-esh-history por `counsel-esh-history` (se counsel estiver instalado)
	    ;; O `counsel-esh-history` agora faz parte do pacote `counsel`.
	    ;; Se você instalou `counsel`, esta função deve funcionar.
	    (define-key eshell-mode-map (kbd "C-r") 'counsel-esh-history)

	    (define-key eshell-mode-map (kbd "C-c C-p") 'eshell-kill-buffer-and-window)

	    (require 'eshell-cmpl)
	    (eshell-cmpl-initialize)

	    (require 'eshell-glob)
	    ))

;; 4. Atalho Rápido para Abrir/Alternar
(global-set-key (kbd "C-c e") 'eshell)

;; 5. REMOVA O BLOCO ABAIXO (era o causador do erro)
;; (use-package counsel-esh :ensure t :after (ivy eshell))

;; (Opcional) Adicione suas configurações de formatação (Prettier, por exemplo) aqui:
;; (use-package prettier
;;   :ensure t
;;   :hook ((typescript-mode . prettier-mode)
;;          (js-mode . prettier-mode)))

 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
;; If there is more than one, they won't work right.


;;; Firefox como padrão quando clica em links
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(browse-url-browser-function 'browse-url-firefox)
 '(browse-url-firefox-new-window-is-tab t)
 '(package-selected-packages
   '(ace-jump-mode all-the-icons all-the-icons-dired company
		   company-prescient ctrlf dashboard dired-sidebar
		   doom-modeline doom-themes elixir-mode
		   flycheck-credo git-messenger git-timemachine
		   goto-chg helpful ivy ivy-yasnippet magit
		   multiple-cursors nerd-icons org-modern prescient rg
		   smartparens swiper typescript-mode which-key
		   ws-butler yasnippet yasnippet-snippets
	     counsel))) ;; <-- ATENÇÃO: Adicionado 'counsel' e fechado os parênteses!
