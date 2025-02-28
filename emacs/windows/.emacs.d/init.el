;;; init.el --- Emacs configuration -*- lexical-binding: t -*-

;;; Commentary:
;; Arquivo principal de configuração do Emacs
;; Responsável por inicialização básica e carregamento de módulos

;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; INICIALIZAÇÃO BÁSICA
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Definir diretório inicial padrão
(setq default-directory "d:/projects/")

;; Garantir que o diretório existe
(unless (file-exists-p default-directory)
  (make-directory default-directory t))

;; Também definir o diretório inicial para novos frames
(setq command-line-default-directory default-directory)

;; Configura o arquivo custom.el
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(unless (file-exists-p custom-file)
  (write-region "" nil custom-file))

;; Configurações de backup e debug
(setq backup-directory-alist
      `(("." . ,(expand-file-name "backups" user-emacs-directory))))
(setq debug-on-warning nil)

;; Configurações de proxy (desabilitado por padrão)
(setq url-proxy-services nil)

;; Fix para o warning de find-function-source-path
(setq find-library-source-path load-path)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; GERENCIADOR DE PACOTES
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'package)

;; Repositórios de pacotes com fallback
(setq package-archives
      '(("gnu" . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")
        ("melpa" . "https://melpa.org/packages/")
        ("melpa-stable" . "https://stable.melpa.org/packages/")
        ("org" . "https://orgmode.org/elpa/")))

;; Inicializa o sistema de pacotes
(package-initialize)

;; Atualiza o conteúdo dos pacotes se necessário
(unless package-archive-contents
  (condition-case err
      (package-refresh-contents)
    (error (message "Error refreshing package contents: %s" err))))

;; Inicializa o use-package
(unless (package-installed-p 'use-package)
  (condition-case err
      (package-install 'use-package)
    (error (message "Error installing use-package: %s" err))))

(require 'use-package)
(setq use-package-always-ensure t)
(setq use-package-always-defer nil)
(setq use-package-verbose t)
(setq use-package-minimum-reported-time 0.1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; FUNÇÕES AUXILIARES
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Helper para a instalação de pacotes
(defun ensure-package-installed (&rest packages)
  "Instala PACKAGES se não estão instalados.
Toma uma lista de nomes de pacotes e garante que eles estão instalados."
  (dolist (package packages)
    (unless (package-installed-p package)
      (condition-case nil
          (package-install package)
        (error
         (message "Couldn't install %s" package))))))

;; Funções para descompactar parágrafos
(defun unfill-paragraph ()
  "Remove quebras de linha de um parágrafo."
  (interactive)
  (let ((fill-column (point-max)))
    (fill-paragraph nil)))

;; Funções para descompactar regiões
(defun unfill-region ()
  "Remove quebras de linha da região atual."
  (interactive)
  (let ((fill-column (point-max)))
    (fill-region (region-beginning) (region-end) nil)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CARREGAMENTO DE CONFIGURAÇÕES
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Carregar arquivo de chaves API primeiro
(let ((api-keys-file (expand-file-name "api-keys.el" user-emacs-directory)))
  (when (file-exists-p api-keys-file)
    (load-file api-keys-file)))

;; Carregar o arquivo custom.el
(when (file-exists-p custom-file)
  (load custom-file))

;; Carregar todas as configurações personalizadas
(let ((custom-dir (expand-file-name "custom" user-emacs-directory)))
  (when (file-exists-p custom-dir)
    (dolist (file (directory-files custom-dir t "\\.el$"))
      (load-file file))))

;; Tenta instalar pacotes essenciais
(ensure-package-installed 'counsel 'ivy)

;; Usar funções modernas do xref
(with-eval-after-load 'etags
  (define-obsolete-variable-alias 'find-tag-marker-ring 'xref-marker-stack "25.1"))

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
  :bind (("C-x g" . magit-status)))

;; Quickrun para executar código
(use-package quickrun
  :ensure t
  :bind ("C-c r" . quickrun))

;; Dumb-jump para navegação de código
(use-package dumb-jump
  :ensure t
  :config
  (setq dumb-jump-selector 'ivy)
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate))

;; Ripgrep para busca de texto
(use-package ripgrep
  :ensure t
  :custom
  (ripgrep-highlight-search t
   "Highlight search term in results."))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; INTEGRAÇÕES COM IA
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Aider para assistência de código com IA
(use-package aider
  :load-path "~/.emacs.d/lisp/aider"
  :config
  (setq aider-args '("--model" "sonnet"))
  (when (boundp 'anthropic-api-key)
    (setenv "ANTHROPIC_API_KEY" anthropic-api-key))
  :bind
  (("C-c a" . aider-transient-menu)))

(provide 'init)
;;; init.el ends here
