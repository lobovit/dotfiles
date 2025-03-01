;;; shell.el --- Configuração para shell e terminal -*- lexical-binding: t -*-

;;; Commentary:
;; Configurações específicas para shell e terminal

;;; Code:

;; Hooks específicos para shell-mode
(add-hook 'shell-mode-hook
          (lambda ()
            ;; Desativar elementos visuais que podem atrapalhar
            (setq-local show-trailing-whitespace nil)
            (setq-local global-hl-line-mode nil)
            (display-line-numbers-mode -1)
            
            ;; Desativar todos os recursos de completion
            (company-mode -1)
            (setq-local completion-at-point-functions nil)
            (setq-local comint-dynamic-complete-functions nil)
            (setq-local shell-dynamic-complete-functions nil)
            
            ;; Configurações do shell
            (setq-local comint-process-echoes nil)
            (setq-local comint-prompt-read-only nil)
            (setq-local comint-use-prompt-regexp nil)
            (setq-local comint-inhibit-carriage-motion t)
            
            ;; Melhorar a interpretação de cores ANSI
            (xterm-color-mode 1)))

;; Configurações específicas para Windows/MSYS2
(when (eq system-type 'windows-nt)
  ;; Função para abrir MSYS2 shell no buffer atual
  (defun msys2-shell-toggle ()
    "Toggle MSYS2 shell in current buffer."
    (interactive)
    (let ((shell-buffer (get-buffer "*shell*")))
      (if (and shell-buffer (eq (current-buffer) shell-buffer))
          (previous-buffer)
        (shell))))
  
  ;; Atalho para alternar o shell MSYS2
  (global-set-key (kbd "C-c e") 'msys2-shell-toggle))

;; Configurações globais do shell
(setq shell-command-prompt-show-cwd t)
(setq comint-scroll-to-bottom-on-input t)
(setq comint-scroll-to-bottom-on-output t)
(setq comint-move-point-for-output t)

(provide 'shell)
;;; shell.el ends here
