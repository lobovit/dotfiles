;;; custom.el --- Configurações customizadas do Emacs -*- lexical-binding: t -*-

;;; Commentary:
;; Este arquivo contém configurações customizadas para o Emacs,
;; incluindo pacotes, modos, atalhos e variáveis.

;;; Code:


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; COMPORTAMENTO BÁSICO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
;; INTERFACE CLEAN
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Inibir a tela inicial
(setq inhibit-startup-screen t
  initial-scratch-message nil)

;; Configuração de cursor e edição
(setq cursor-type 'box
  blink-cursor-mode nil
  create-lockfiles nil
  save-interprogram-paste-before-kill nil
  select-enable-clipboard t
  ring-bell-function 'ignore
)


;; Configuração de fonte, barra de rolagem e menu
(set-face-attribute 'default nil :font "Consolas" :height 152 :weight 'bold)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(tooltip-mode -1)


;; Configuração de exibição do tempo
(setq display-time-format "%a %b %d %R"
      display-time-interval 60
      display-time-default-load-average nil)
(display-time-mode 1)


;; Exibição de colunas
(global-display-line-numbers-mode t)
(line-number-mode t)
(column-number-mode t)


;; Modos globais
(add-hook 'before-save-hook 'whitespace-cleanup)
(auto-compression-mode t)
(global-font-lock-mode t)
(recentf-mode 1)
(show-paren-mode 1)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PACOTES ESSENCIAIS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Configuração básica do Emacs
(use-package emacs
  :ensure nil
  :config
  ;; Desativar a tela inicial
  (setq inhibit-startup-screen t)
  ;; Desativar menus e barras
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  ;; Mostrar números de linha
  (global-display-line-numbers-mode t)
  ;; Destacar a linha atual
  (global-hl-line-mode t)
  ;; Configurações de backup
  (setq backup-directory-alist '(("." . "~/.emacs.d/backups")))
  (setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)))
  (setq create-lockfiles nil)
  ;; Codificação UTF-8
  (set-language-environment "UTF-8")
  (set-default-coding-systems 'utf-8)
  ;; Melhorar a performance
  (setq gc-cons-threshold 100000000)
  (setq read-process-output-max (* 1024 1024)))

;; Bibliotecas de compatibilidade
(use-package cl-lib
  :ensure t)

;; Interface e navegação
(use-package treemacs
  :ensure t
  :defer t
  :config
  (setq treemacs-persist-file nil)               ;; Não persistir o estado do treemacs
  (setq treemacs-width 35)                       ;; Largura da janela do treemacs
  (setq treemacs-indentation 2)                  ;; Indentação
  (treemacs-follow-mode t)                       ;; Seguir o buffer atual
  (treemacs-filewatch-mode t)                    ;; Observar mudanças nos arquivos
  :bind
  (:map global-map
	("<f5>" . treemacs-select-window)))



;; Ajuda e documentação
(use-package which-key
  :ensure t
  :config
  (which-key-mode)
  (setq which-key-idle-delay 0.5))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DESENVOLVIMENTO GERAL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; LSP Mode - configuração central
(use-package lsp-mode
  :ensure t
  :commands (lsp lsp-deferred)
  :config
  (setq lsp-prefer-flymake nil
	lsp-enable-on-type-formatting nil
	lsp-keymap-prefix "C-c l"
	lsp-file-watch-threshold 15000
	lsp-enable-symbol-highlighting t
	lsp-enable-indentation t
	;; Desativar mensagens de servidor não encontrado
	lsp-auto-guess-root t
	lsp-warn-no-matched-clients nil
	lsp-enable-suggest-server-download nil)  ;; Esta é a configuração chave
  (define-key lsp-mode-map (kbd "C-c l") lsp-command-map))

;; LSP UI - configuração central
(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode
  :after lsp-mode
  :config
  (setq lsp-ui-doc-enable t
	lsp-ui-doc-delay 0.5
	lsp-ui-peek-enable t
	lsp-ui-sideline-enable t)
  (define-key lsp-ui-mode-map (kbd "M-.") #'lsp-ui-peek-find-definitions)
  (define-key lsp-ui-mode-map (kbd "M-?") #'lsp-ui-peek-find-references))

;; Flycheck para verificação de código
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

;; Company para autocompleção
(use-package company
  :ensure t
  :config
  (global-company-mode)
  (setq company-idle-delay 0.5
	company-minimum-prefix-length 3
	company-show-numbers nil))

;; DAP Mode para depuração
(use-package dap-mode
  :ensure t
  :after lsp-mode
  :config
  (dap-auto-configure-mode))

;; Ferramentas de edição avançada
(use-package multiple-cursors
  :ensure t
  :bind
  (("C-S-c C-S-c" . mc/edit-lines)
   ("C->" . mc/mark-next-like-this)
   ("C-<" . mc/mark-previous-like-this)
   ("C-c C-<" . mc/mark-all-like-this)))

(use-package expand-region
  :ensure t
  :bind
  (("C-=" . er/expand-region)))

;; Rainbow-mode para colorização
(use-package rainbow-mode
  :ensure t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SUPORTE A LINGUAGENS ESPECÍFICAS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Web e Markup
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

;; Markdown
(use-package markdown-mode
  :ensure t
  :mode (("README\\.md\\'" . gfm-mode)
	 ("\\.md\\'" . markdown-mode)
	 ("\\.markdown\\'" . markdown-mode)))

;; YAML
(use-package yaml-mode
  :ensure t
  :mode (("\\.yml\\'" . yaml-mode)
	 ("\\.yaml\\'" . yaml-mode))
  :config
  ;; Definir a variável yaml-indent-offset para evitar warning
  (defvar yaml-indent-offset 2
    "Número de espaços para indentação em arquivos YAML.")

  ;; Definir a função yaml-indent para evitar warning
  (unless (fboundp 'yaml-indent)
    (defun yaml-indent ()
      "Indent current line as YAML code."
      (interactive)
      (let ((indent (+ (current-indentation) yaml-indent-offset)))
	(indent-line-to indent)))))

;; Powershell
(use-package powershell
  :ensure t)

;; Pkgbuild para Arch Linux
(use-package pkgbuild-mode
  :ensure t
  :mode "PKGBUILD")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; LINGUAGENS DE PROGRAMAÇÃO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Python
(use-package python
  :ensure nil  ;; Já vem com o Emacs
  :mode ("\\.py\\'" . python-mode)
  :config
  ;; Define funções que estão gerando warnings
  (unless (fboundp 'python-indent)
    (defun python-indent ()
      "Indent current line as Python code."
      (interactive)
      (indent-line-to (python-indent-calculate-indentation))))

  (unless (fboundp 'python-info-ppss-context)
    (defun python-info-ppss-context (type &optional syntax-ppss)
      "Return non-nil if point is on TYPE using SYNTAX-PPSS.
TYPE can be 'comment, 'string or 'paren."
      (let ((ppss (or syntax-ppss (syntax-ppss))))
	(cond ((eq type 'comment)
	       (nth 4 ppss))
	      ((eq type 'string)
	       (nth 3 ppss))
	      ((eq type 'paren)
	       (nth 1 ppss))
	      (t nil))))))

;; LSP-Pyright - configuração central
(use-package lsp-pyright
  :ensure t
  :defer t
  :init
  (setq lsp-pyright-python-executable-cmd "python3"))

;; Go
(use-package go-mode
  :ensure t
  :defer t
  :config
  ;; Escapar aspas simples nas docstrings
  (with-eval-after-load 'go-mode
    ;; Corrigir docstrings com aspas simples
    (put 'go-command 'variable-documentation
	 (replace-regexp-in-string "'" "\\\\=" (get 'go-command 'variable-documentation)))
    (put 'gofmt-command 'variable-documentation
	 (replace-regexp-in-string "'" "\\\\=" (get 'gofmt-command 'variable-documentation)))
    (put 'godef-command 'variable-documentation
	 (replace-regexp-in-string "'" "\\\\=" (get 'godef-command 'variable-documentation)))
    (put 'go-packages-function 'variable-documentation
	 (replace-regexp-in-string "'" "\\\\=" (get 'go-packages-function 'variable-documentation))))

  (setq gofmt-command "goimports")
  (add-hook 'before-save-hook 'gofmt-before-save))

;; Go Fill Struct - preencher structs automaticamente
(use-package go-fill-struct
  :ensure t
  :after go-mode)

;; Go Add Tags - adicionar tags a structs
(use-package go-add-tags
  :ensure t
  :after go-mode)

;; Rust
(use-package rust-mode
  :ensure t
  :defer t
  :config
  (setq rust-format-on-save t))

;; Cargo - configuração central para Rust
(use-package cargo
  :ensure t
  :after rust-mode
  :hook (rust-mode . cargo-minor-mode))

;; Java
(use-package lsp-java
  :ensure t
  :defer t
  :config
  (setq lsp-java-vmargs
	'("-XX:+UseG1GC" "-XX:+UseStringDeduplication" "-Xmx2G"))
  ;; Ajuste o caminho do Java, se necessário
  ;; (setq lsp-java-java-path "path_to_your_java")
  (setq lsp-java-save-action-organize-imports t)
  (setq lsp-java-autobuild-enabled t))

;; DAP Java - configuração específica para Java
(use-package dap-java
  :ensure nil  ;; Parte do dap-mode
  :after (dap-mode lsp-java))

;; Clojure
(use-package clojure-mode
  :ensure t
  :defer t)

;; CIDER - configuração central para Clojure
(use-package cider
  :ensure t
  :after clojure-mode
  :config
  ;; Remove a mensagem de boas-vindas do REPL
  (setq cider-repl-display-help-banner nil)
  ;; Controla como o buffer do REPL é exibido
  (setq cider-repl-pop-to-buffer-on-connect 'display-only)
  ;; Salva o buffer ao compilar ou carregar código
  (setq cider-save-file-on-load t)
  ;; Usa pretty-print no REPL
  (setq cider-repl-use-pretty-printing t)
  ;; Configura o histórico do REPL
  (setq cider-repl-wrap-history t)
  (setq cider-repl-history-size 1000)
  (setq cider-repl-history-file "~/.emacs.d/cider-history"))

;; Common Lisp
(use-package slime
  :ensure t
  :defer t
  :init
  (setq inferior-lisp-program "sbcl")
  :config
  (slime-setup '(slime-fancy slime-company)))

;; SLIME Company - configuração central
(use-package slime-company
  :ensure t
  :after (slime company)
  :config
  (setq slime-company-completion 'fuzzy))

;; C/C++ - configuração central
(use-package ccls
  :ensure t
  :defer t
  :config
  (setq ccls-executable "/usr/local/bin/ccls"
        ccls-args nil
        ccls-initialization-options
        '(:index (:comments 2) :completion (:detailedLabel t))))

;; Company Box - para melhor visualização de completions
(use-package company-box
  :ensure t
  :after company
  :if (display-graphic-p)  ;; Só carregar em modo gráfico
  :hook (company-mode . company-box-mode)
  :config
  (setq company-box-icons-alist 'company-box-icons-all-the-icons))

;; Flycheck Pos-tip - para melhor visualização de erros
(use-package flycheck-pos-tip
  :ensure t
  :after flycheck
  :config
  (flycheck-pos-tip-mode))

;; LSP Treemacs - integração do LSP com Treemacs
(use-package lsp-treemacs
  :ensure t
  :commands lsp-treemacs-errors-list)

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

;; Ripgrep para busca de texto
(use-package ripgrep
  :ensure t
  :bind (("C-c s" . ripgrep-regexp))
  :custom
  (ripgrep-highlight-search t
   "Highlight search term in results."))

;; XTerm Color - para melhor suporte a cores no shell
(use-package xterm-color
  :ensure t
  :config
  (setq comint-output-filter-functions
	(remove 'ansi-color-process-output comint-output-filter-functions))
  (add-hook 'comint-preoutput-filter-functions 'xterm-color-filter)
  (setq ansi-color-for-comint-mode nil))

;; Configuração do smerge-mode para merge de mudanças
(use-package smerge-mode
  :ensure nil                                    ;; Já vem com o Emacs
  :hook (prog-mode . smerge-mode))

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
(setq comint-scroll-to-bottom-on-input t)        ;; Rolar para o final ao inserir texto
(setq comint-scroll-to-bottom-on-output t)       ;; Rolar para o final ao receber saída
(setq comint-move-point-for-output t)            ;; Mover o ponto para a saída

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ATALHOS CUSTOMIZADOS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Comentar/descomentar região selecionada
(global-set-key (kbd "C-c C-c") 'comment-or-uncomment-region)

;; LSP mode
(define-prefix-command 'lsp-command-map)
(global-set-key (kbd "C-c l") 'lsp-command-map)

;; Não persistir o treemacs
(setq treemacs-persist-file nil)

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
   '()))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(provide 'custom)
;;; custom.el ends here
