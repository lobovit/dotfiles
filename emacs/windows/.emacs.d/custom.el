;;; custom.el --- Custom settings -*- lexical-binding: t -*-

;;; Commentary:
;; Configurações personalizadas do Emacs organizadas por categorias

;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; APARÊNCIA E INTERFACE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Configuração da fonte
(set-face-attribute 'default nil :family "Consolas" :height 152 :weight 'bold)

;; Simplificação da UI
(defalias 'yes-or-no-p 'y-or-n-p)                ;; Simplificar a função yes-or-no-p
(tool-bar-mode -1)                               ;; Desativar a barra de ferramentas
(scroll-bar-mode -1)                             ;; Desativar a barra de rolagem
(tooltip-mode -1)                                ;; Desativar os tooltips
(menu-bar-mode -1)                               ;; Desativar a barra de menus

;; Configurações de exibição de tempo
(setq display-time-format "%a %b %d %R"          ;; Formato de exibição de tempo
      display-time-interval 60                   ;; Intervalo de atualização em segundos
      display-time-default-load-average nil)     ;; Não exibir o load average
(display-time-mode 1)                            ;; Ativar o modo de exibição de tempo

;; Exibição de linhas e colunas
(global-display-line-numbers-mode t)             ;; Exibir números de linha
(line-number-mode t)                             ;; Exibir números de linha
(column-number-mode t)                           ;; Exibir números de coluna

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; COMPORTAMENTO BÁSICO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Configurações de inicialização
(setq inhibit-startup-screen t                   ;; Não exibir a tela de inicialização
      initial-scratch-message nil)               ;; Não exibir a mensagem do scratch buffer

;; Configurações de cursor e edição
(setq cursor-type 'box                           ;; Tipo de cursor
      blink-cursor-mode nil                      ;; Não piscar o cursor
      create-lockfiles nil                       ;; Não criar arquivos de bloqueio
      save-interprogram-paste-before-kill nil    ;; Não salvar o conteúdo colado
      select-enable-primary nil                  ;; Não usar o primary selection
      select-enable-clipboard t                  ;; Ativar o clipboard
      ring-bell-function 'ignore                 ;; Não emitir um som de alerta
      bidi-display-reordering 'left-to-right)    ;; Reordenar texto da esquerda para a direita

;; Modos de edição
(electric-pair-mode 1)                           ;; Ativar o modo de par de elétrons
(electric-indent-mode 1)                         ;; Ativar o modo de indentação elétrica
(global-subword-mode 1)                          ;; Ativar o modo de subpalavras
(delete-selection-mode 1)                        ;; Ativar o modo de seleção
(global-visual-line-mode 1)                      ;; Ativar o modo de visualização de linha
(auto-fill-mode 1)                               ;; Ativar o modo de preenchimento automático

;; Modos globais
(add-hook 'before-save-hook 'whitespace-cleanup) ;; Limpar espaços em branco antes de salvar
(auto-compression-mode t)                        ;; Ativar o modo de compressão automática
(global-font-lock-mode t)                        ;; Ativar o modo de coloração de sintaxe
(recentf-mode 1)                                 ;; Ativar o modo de recentes
(show-paren-mode 1)                              ;; Ativar o modo de parênteses

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PACOTES ESSENCIAIS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Bibliotecas de compatibilidade
(use-package cl-lib
  :ensure t)

;; Ivy para completação
(use-package ivy
  :ensure t
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t
	ivy-count-format "%d/%d "))

;; Counsel para comandos melhorados
(use-package counsel
  :ensure t
  :after ivy
  :config
  (counsel-mode 1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DESENVOLVIMENTO E EDIÇÃO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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

;; Flycheck para verificação de código
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

;; Company para autocompleção
(use-package company
  :ensure t
  :config
  (global-company-mode))

;; Rainbow-mode para colorização
(use-package rainbow-mode
  :ensure t)

;; Multiple-cursors para edição múltipla
(use-package multiple-cursors
  :ensure t
  :bind
  (("C-S-c C-S-c" . mc/edit-lines)
   ("C->" . mc/mark-next-like-this)
   ("C-<" . mc/mark-previous-like-this)
   ("C-c C-<" . mc/mark-all-like-this)))

;; Expand-region para seleção semântica
(use-package expand-region
  :ensure t
  :bind
  (("C-=" . er/expand-region)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SUPORTE A LINGUAGENS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; YAML
(use-package yaml-mode
  :ensure t
  :mode (("\\.yml\\'" . yaml-mode)
	 ("\\.yaml\\'" . yaml-mode)))

;; Powershell
(use-package powershell
  :ensure t)

;; Pkgbuild para Arch Linux
(use-package pkgbuild-mode
  :ensure t
  :mode "PKGBUILD")

;; Markdown
(use-package markdown-mode
  :ensure t
  :mode (("README\\.md\\'" . gfm-mode)
	 ("\\.md\\'" . markdown-mode)
	 ("\\.markdown\\'" . markdown-mode)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; FERRAMENTAS DE DESENVOLVIMENTO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Magit para Git
(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)
	 ("C-x M-g" . magit-dispatch)))

;; Quickrun para executar código
(use-package quickrun
  :ensure t
  :bind ("C-c r" . quickrun))

;; Dumb-jump para navegação de código
(use-package dumb-jump
  :ensure t
  :bind (("M-g j" . dumb-jump-go)
	 ("M-g b" . dumb-jump-back))
  :config
  (setq dumb-jump-selector 'ivy)
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate))

;; Ripgrep para busca de texto
(use-package ripgrep
  :ensure t
  :bind (("C-c s" . ripgrep-regexp))
  :custom
  (ripgrep-highlight-search t
   "Highlight search term in results."))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CONFIGURAÇÃO DO SHELL MSYS2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(when (eq system-type 'windows-nt)
  ;; Configuração básica do shell
  (setq explicit-shell-file-name "C:/msys64/usr/bin/bash.exe")
  (setq shell-file-name explicit-shell-file-name)
  (setq explicit-bash.exe-args '("--login" "-i"))

  ;; Configurar variáveis de ambiente necessárias
  (setenv "TERM" "dumb")                         ;; Usar terminal dumb para evitar problemas de controle
  (setenv "SHELL" explicit-shell-file-name)
  (setenv "MSYSTEM" "MINGW64")                   ;; Definir ambiente MSYS2
  (setenv "PS1" "\\[\\e[32m\\]\\w\\[\\e[0m\\] $ ")  ;; Prompt simples

  ;; Configurar o PATH para incluir os binários do MSYS2
  (setenv "PATH"                                 ;; Adicionar o PATH do MSYS2
	  (concat                                ;; Concatenar o PATH do MSYS2 com o PATH atual
	   "C:\\msys64\\usr\\bin;"              ;; Caminho para o binário do MSYS2
	   "C:\\msys64\\mingw64\\bin;"          ;; Caminho para o binário do MinGW64
	   (getenv "PATH")))                     ;; Caminho para o PATH atual

  ;; Função para abrir MSYS2 shell no buffer atual
  (defun msys2-shell-toggle ()                   ;; Alternar o shell MSYS2 no buffer atual
    "Toggle MSYS2 shell in current buffer."
    (interactive)
    (let ((shell-buffer (get-buffer "*shell*"))) ;; Obter o buffer do shell
      (if (and shell-buffer (eq (current-buffer) shell-buffer)) ;; Se o buffer do shell existe e é o buffer atual
	  (previous-buffer)                      ;; Voltar para o buffer anterior
	(shell))))                               ;; Abrir o shell

  ;; Atalho para alternar o shell MSYS2
  (global-set-key (kbd "C-c e") 'msys2-shell-toggle))

;; Configurações do shell-mode para melhor integração
(add-hook 'shell-mode-hook                       ;; Adicionar o hook do shell-mode
	  (lambda ()                             ;; Lambda para configurar o shell-mode
	    ;; Desativar elementos visuais que podem atrapalhar
	    (setq-local show-trailing-whitespace nil) ;; Desativar espaços em branco no final das linhas
	    (setq-local global-hl-line-mode nil) ;; Desativar o modo de destaque de linha global
	    (display-line-numbers-mode -1)       ;; Desativar os números de linha

	    ;; Desativar todos os recursos de completion
	    (company-mode -1)                    ;; Desativar o modo de completion
	    (setq-local completion-at-point-functions nil) ;; Desativar a função de completion no ponto
	    (setq-local comint-dynamic-complete-functions nil) ;; Desativar a função de completion dinâmica
	    (setq-local shell-dynamic-complete-functions nil) ;; Desativar a função de completion dinâmica do shell

	    ;; Configurações do shell
	    (setq-local comint-process-echoes nil)  ;; Desativar eco
	    (setq-local comint-prompt-read-only nil) ;; Desativar a leitura do prompt
	    (setq-local comint-use-prompt-regexp nil) ;; Desativar o uso do prompt
	    (setq-local comint-inhibit-carriage-motion t)  ;; Evitar problemas com \r

	    ;; Melhorar a interpretação de cores ANSI
	    (ansi-color-for-comint-mode-on)))

;; Configurações globais do shell
(setq shell-command-prompt-show-cwd t)           ;; Mostrar o diretório atual na linha de comando
(setq comint-prompt-read-only nil)               ;; Não tornar o prompt de comando somente leitura
(setq comint-process-echoes nil)                 ;; Não exibir mensagens de processamento
(setq shell-command-switch "-c")                 ;; Usar o switch "-c" para comandos shell

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; INTEGRAÇÕES COM IA
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Configuração do GPTel
(use-package gptel
  :ensure t
  :custom
  (gptel-model 'deepseek-coder)                  ;; Usando Deepseek como modelo padrão
  :config
  ;; Configurar backend Ollama/Deepseek
  (setq gptel-backend
	(gptel-make-ollama "Deepseek"
			  :host "localhost:11434"
			  :stream t
			  :models '("deepseek-coder"))))

;; Configuração do Elysium
(use-package elysium
  :ensure t
  :after gptel
  :custom
  (elysium-window-size 0.33)                     ;; Tamanho da janela do Elysium (1/3 da tela)
  (elysium-window-style 'vertical)               ;; Estilo da janela (vertical ou horizontal)
  :bind
  (("C-c a" . elysium-query)                     ;; Atalho principal para fazer queries
   ("C-c C-a" . elysium-toggle-window)))         ;; Alternar janela do Elysium

;; Configuração do smerge-mode para merge de mudanças
(use-package smerge-mode
  :ensure nil                                    ;; Já vem com o Emacs
  :hook (prog-mode . smerge-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ATALHOS DE TECLADO ADICIONAIS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Comentar/descomentar região selecionada
(global-set-key (kbd "C-c C-c") 'comment-or-uncomment-region)

;; LSP mode
(define-prefix-command 'lsp-command-map)
(global-set-key (kbd "C-c l") 'lsp-command-map)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; VARIÁVEIS CUSTOMIZADAS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Variáveis customizadas gerenciadas pela interface Custom do Emacs
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(tango-dark))
 '(custom-safe-themes
   '("0971e976bc1092a52cf092bec03f3adf63dfdb7c1a2820ab9e214845a0f5eb72" "a5270d86fac30303c5910be7403467662d7601b821af2ff0c4eb181153ebfc0a" "d445c7b530713eac282ecdeea07a8fa59692c83045bf84dd112dd738c7bcad1d" "7422e5b955cf72a2657e0b932ce00efcaee3cffd663f5d701d2442a74ab17dbf" default))
 '(package-selected-packages
   '(elysium gptel xterm-color ripgrep dumb-jump quickrun powershell yaml-mode pkgbuild-mode cargo rust-mode yasnippet ccls flycheck-pos-tip company-box lsp-ivy rainbow-delimiters ivy wgrep-ag multiple-cursors dap-mode go-add-tags go-fill-struct lsp-mode web-mode rg rainbow-mode paredit markdown-mode magit htmlize go-mode flymake-shellcheck expand-region emmet-mode)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(provide 'custom)
;;; custom.el ends here
