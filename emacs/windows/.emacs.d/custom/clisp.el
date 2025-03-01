;;; clisp.el --- Configuration for Common Lisp -*- lexical-binding: t -*-

;;; Commentary:
;; Common Lisp development environment setup

;;; Code:

;; Basic lisp mode configuration (built-in)
(add-hook 'lisp-mode-hook #'show-paren-mode)
(add-hook 'lisp-mode-hook #'lsp-deferred)
(add-hook 'lisp-mode-hook #'slime-mode)

;; Configurações específicas para LSP com Common Lisp
(with-eval-after-load 'lsp-mode
  (add-to-list 'lsp-language-id-configuration '(lisp-mode . "lisp")))

;; Se cl-lsp não estiver no PATH, descomente e defina o caminho:
;; (setq lsp-cl-lisp-server-command '("/path/to/cl-lsp"))

(provide 'clisp)
;;; clisp.el ends here
