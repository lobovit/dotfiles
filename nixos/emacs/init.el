;;; init.el --- Configuração pessoal do Emacs -*- lexical-binding: t; -*-

;;; Commentary:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; COMPORTAMENTO BÁSICO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Code:
(electric-pair-mode 1)                           ;; Ativar o modo de automático para ()[]{}
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

;; NOTA: Removemos (package-initialize) para sumir com o Warning.
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
  :ensure t)

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
  :config
  ;; Esta é a função correta para configurar o Dashboard
  (dashboard-initialize)

  ;; Garante que o dashboard abra na inicialização
  (add-hook 'emacs-startup-hook 'dashboard-open)

  ;; Desativar a tela inicial padrão do Emacs
  (setq inhibit-startup-screen t
	initial-scratch-message nil)

  ;; --- Configurações do Dashboard ---
  (setq dashboard-center-content t)
  (setq dashboard-show-doom-logo nil)
  (setq dashboard-footer-messages nil)

  ;; Caminho para a sua imagem (Garanta que a imagem transparente esteja salva aqui)
(setq dashboard-startup-banner
	(expand-file-name "images/lobo_transparente.png" user-emacs-directory))
  ;; (isso vira ~/.emacs.d/images/lobo_transparente.png automaticamente)

  ;; Itens que aparecem no Dashboard
  (setq dashboard-items '(
			  (recents  . 5)
			  (projects . 5)
			  (bookmarks . 5)
			  (agenda . 5)
			  ))


  ;; Atalho para voltar ao dashboard
  (global-set-key (kbd "C-c d") 'dashboard-open))


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
(set-face-attribute 'default nil :family "Fira Code" :height 120)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(tooltip-mode -1)

;; Exibição de colunas
(global-display-line-numbers-mode t)
(line-number-mode t)
(column-number-mode t)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DEVELOPMENT TOOLS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

;; 1. Modo Básico do Elixir (Sintaxe e Formatação)
(use-package elixir-mode
  :ensure t
  :config
  ;; Configura o 'mix format' para rodar ao salvar
  (add-hook 'elixir-mode-hook
	    (lambda () (add-hook 'before-save-hook 'elixir-format nil t))))


;; LSP nativo: Eglot
(use-package eglot
  :ensure nil                       ;; já vem com o Emacs 29+
  :hook (elixir-mode . eglot-ensure)
  :config
  ;; Diz pro Eglot qual servidor usar para Elixir
  ;; No NixOS, garanta que `elixir-ls` está instalado no PATH
  (add-to-list 'eglot-server-programs
	       '(elixir-mode . ("elixir-ls"))))

 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
'(package-selected-packages
  '(dashboard doom-modeline doom-themes elixir-mode flycheck))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
