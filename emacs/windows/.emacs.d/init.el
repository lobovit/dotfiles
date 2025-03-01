;;; init.el --- Emacs configuration -*- lexical-binding: t -*-

;;; Commentary:
;; Arquivo principal de configuração do Emacs
;; Responsável por inicialização básica e carregamento de módulos

;;; Code:

;; Suprimir a maioria dos avisos de compilação
(setq byte-compile-warnings '(not obsolete free-vars unresolved callargs
                                 redefine docstrings not noruntime cl-functions
                                 interactive-only))

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

;; Função para evitar erros de minibuffer recursivo
(defun safe-minibuffer-eval (function &rest args)
  "Execute FUNCTION with ARGS only if not in minibuffer."
  (unless (minibufferp)
    (apply function args)))

;; Melhorar o advice para o timer-event-handler
(defadvice timer-event-handler (around no-recursive-minibuffer activate)
  "Prevent timer from using minibuffer when it's active."
  (unless (active-minibuffer-window)
    ad-do-it))

;; Desativar timers problemáticos
(defun disable-problematic-timers ()
  "Disable timers that might cause minibuffer issues."
  (dolist (timer timer-list)
    (let ((fn (timer--function timer)))
      (when (and (symbolp fn)
                 (or (string-match-p "company" (symbol-name fn))
                     (string-match-p "flycheck" (symbol-name fn))
                     (string-match-p "lsp" (symbol-name fn))))
        (cancel-timer timer)))))

;; Executar após inicialização
(add-hook 'after-init-hook 'disable-problematic-timers)

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

;; Usar funções modernas do xref
(with-eval-after-load 'etags
  (define-obsolete-variable-alias 'find-tag-marker-ring 'xref-marker-stack "25.1"))

(provide 'init)
;;; init.el ends here
(put 'upcase-region 'disabled nil)
