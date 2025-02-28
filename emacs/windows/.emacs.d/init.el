;;; init.el --- Emacs configuration -*- lexical-binding: t -*-

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Gerenciador de pacotes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'package) 

;; Adiciona repositórios de pacotes com fallback, isto é...
;; se um não estiver disponível, o Emacs tenta o próximo.
(setq package-archives
      '(("gnu" . "https://elpa.gnu.org/packages/")
	("nongnu" . "https://elpa.nongnu.org/nongnu/")
	("melpa" . "https://melpa.org/packages/")
	("melpa-stable" . "https://stable.melpa.org/packages/")
	("org" . "https://orgmode.org/elpa/")))

;; Inicializa o sistema de pacotes
;; Isso é necessário para que o Emacs possa usar os pacotes.
(package-initialize)

;; Atualiza o conteúdo dos pacotes se necessário, com tratamento de erros
;; Isso é necessário para que o Emacs possa usar os pacotes mais recentes.
(unless package-archive-contents
  (condition-case err
      (package-refresh-contents)
    (error (message "Error refreshing package contents: %s" err))))

"Inicializa o use-package com tratamento de erros
Isso é necessário para que o Emacs possa usar o use-package...
pois, o use-package é um macro que simplifica a configuração de pacotes."
(unless (package-installed-p 'use-package)
  (condition-case err
      (package-install 'use-package)
    (error (message "Error installing use-package: %s" err))))

(require 'use-package) ;; precisa ser carregado antes de usar o use-package
(setq use-package-always-ensure t) ;; garante que o pacote será instalado automaticamente
(setq use-package-always-defer nil)  ;; Carrega os pacotes imediatamente por padrão
(setq use-package-verbose t)         ;; Mostra mais informações durante o carregamento
(setq use-package-minimum-reported-time 0.1) ;; Reporta pacotes que levam mais de 0.1s para carregar


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Customizações
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Configura o arquivo custom.el
;; O arquivo custom.el é usado para armazenar as configurações personalizadas.
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(unless (file-exists-p custom-file) ;; Se o arquivo custom.el não existir, cria ele
  (write-region "" nil custom-file)) ;; Cria o arquivo custom.el vazio
(load custom-file) ;; Carrega o arquivo custom.el

;; Desabilita o debug de warnings
(setq debug-on-warning nil)

;; Usa uma abordagem mais portátil para arquivos de backup
(setq backup-directory-alist
      `(("." . ,(expand-file-name "backups" user-emacs-directory))))

;; Configurações de proxy (desabilitado por padrão)
(setq url-proxy-services nil)

;; Carrega todas as configurações personalizadas
(let ((custom-dir (expand-file-name "custom" user-emacs-directory)))
  (when (file-exists-p custom-dir) ;; Se o diretório custom existe
    (dolist (file (directory-files custom-dir t "\\.el$")) ;; Carrega todos os arquivos el no diretório custom
      (load-file file)))) ;; Carrega o arquivo

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Instalação de pacotes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Web mode
;; web-mode é um modo para editar arquivos HTML, CSS e JavaScript.
(use-package web-mode
  :ensure t
  :mode (("\\.html?\\'" . web-mode) ;; Modo para editar arquivos HTML
	 ("\\.tsx\\'" . web-mode) ;; Modo para editar arquivos TSX
	 ("\\.jsx\\'" . web-mode) ;; Modo para editar arquivos JSX
	 ("\\.css\\'" . web-mode) ;; Modo para editar arquivos CSS
	 ("\\.scss\\'" . web-mode) ;; Modo para editar arquivos SCSS
	 ("\\.php\\'" . web-mode)) ;; Modo para editar arquivos PHP
  :config
  (setq web-mode-markup-indent-offset 2) ;; Indentação de marcação
  (setq web-mode-css-indent-offset 2) ;; Indentação de CSS
  (setq web-mode-code-indent-offset 2) ;; Indentação de código
  (setq web-mode-enable-auto-pairing t) ;; Ativa o auto-parsing
  (setq web-mode-enable-css-colorization t) ;; Ativa a colorização de CSS
  (setq web-mode-enable-current-element-highlight t) ;; Ativa o highlight da linha atual
  :hook (web-mode . (lambda ()
		      (setq web-mode-markup-indent-offset 2) ;; Indentação de marcação
		      (setq web-mode-css-indent-offset 2) ;; Indentação de CSS
		      (setq-local electric-pair-inhibit-predicate
				  (lambda (c)
				    (if (char-equal c ?{) t ;; Se o caractere é {, retorna t
				      (when (fboundp 'electric-pair-default-inhibit) ;; Se a função electric-pair-default-inhibit está definida
					(funcall 'electric-pair-default-inhibit c)))))))) ;; Chama a função electric-pair-default-inhibit com o caractere c


;; Adiciona bibliotecas de compatibilidade
;; cl-lib é uma biblioteca de funções de compatibilidade para o Emacs.
(use-package cl-lib
  :ensure t)


;; Flycheck é um sistema de verificação de código para o Emacs.
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

;; Company é um sistema de autocompleção para o Emacs.
(use-package company
  :ensure t
  :config
  (global-company-mode))


;; Rainbow-mode é um modo para colorir o texto em função do contexto.
(use-package rainbow-mode
  :ensure t)


;; Pkgbuild é um modo para editar arquivos PKGBUILD (freebsd/archlinux).
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

;; Magit é um sistema de controle de versão para o Emacs.
(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)))

;; Quickrun é um sistema para executar código em várias linguagens de programação.
(use-package quickrun
  :ensure t
  :bind ("C-c r" . quickrun))

;; Dumb-jump é um sistema para saltar entre as definições de funções.
(use-package dumb-jump
  :ensure t
  :config
  (setq dumb-jump-selector 'ivy)
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate))

;; Ripgrep é um sistema de busca de texto para o Emacs baseado no grep.
(use-package ripgrep
  :ensure t
  :custom
  (ripgrep-highlight-search t
   "Highlight search term in results."))

;; Markdown mode é um modo para editar arquivos markdown.
(use-package markdown-mode
  :ensure t
  :mode (("README\\.md\\'" . gfm-mode) ;; Modo para editar arquivos README.md
	 ("\\.md\\'" . markdown-mode) ;; Modo para editar arquivos md
	 ("\\.markdown\\'" . markdown-mode))) ;; Modo para editar arquivos markdown

;; Funções para descompactar parágrafos
(defun unfill-paragraph ()
  "Remove quebras de linha de um parágrafo."
  (interactive) ;; Interativo
  (let ((fill-column (point-max))) ;; Define o fill-column para o ponto máximo
    (fill-paragraph nil))) ;; Preenche o parágrafo atual

;; Funções para descompactar regiões
(defun unfill-region ()
  "Remove quebras de linha da região atual."
  (interactive) ;; Interativo
  (let ((fill-column (point-max))) ;; Define o fill-column para o ponto máximo
    (fill-region (region-beginning) (region-end) nil))) ;; Preenche a região atual

;; Usar funções modernas do xref
(with-eval-after-load 'etags
  (define-obsolete-variable-alias 'find-tag-marker-ring 'xref-marker-stack "25.1"))

;; Fix para o warning de find-function-source-path
(setq find-library-source-path load-path)

;; Helper para a instalação de pacotes
(defun ensure-package-installed (&rest packages)
  "Instala PACKAGES se não estão instalados.
Toma uma lista de nomes de pacotes e garante que eles estão instalados."
  (dolist (package packages)
    (unless (package-installed-p package) ;; Se o pacote não está instalado
      (condition-case nil ;; Caso ocorra um erro
          (package-install package) ;; Instala o pacote
        (error ;; Se ocorrer um erro
         (message "Couldn't install %s" package)))))) ;; Mostra uma mensagem de erro

;; Tenta instalar pacotes essenciais
(ensure-package-installed 'counsel 'ivy)

(provide 'init)
;;; init.el ends here
