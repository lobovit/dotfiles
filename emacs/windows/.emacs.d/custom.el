;;; custom.el --- Custom settings -*- lexical-binding: t -*-

;;; Commentary:
;; Custom settings managed by Emacs

;;; Code:

;; UI Customization
(set-face-attribute 'default nil :family "Consolas" :height 152 :weight 'bold)

;; Display time settings
(setq display-time-format "%a %b %d %R"
      display-time-interval 60
      display-time-default-load-average nil)
(display-time-mode 1)

;; Basic behavior settings
(setq inhibit-startup-screen t
      initial-scratch-message nil
      ring-bell-function 'ignore
      cursor-type 'box
      blink-cursor-mode nil
      create-lockfiles nil
      save-interprogram-paste-before-kill nil
      select-enable-primary nil
      electric-pair-mode 1
      electric-indent-mode 1
      line-number-mode t
      column-number-mode t
      select-enable-clipboard t
      bidi-display-reordering 'left-to-right)

;; Global modes
(add-hook 'before-save-hook 'whitespace-cleanup)
(auto-compression-mode t)
(global-display-line-numbers-mode t)
(global-font-lock-mode t)
(global-subword-mode 1)
(recentf-mode 1)
(show-paren-mode 1)
(global-visual-line-mode 1)
(delete-selection-mode 1)
(column-number-mode t)
(auto-fill-mode 1)

;; UI simplification
(defalias 'yes-or-no-p 'y-or-n-p)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(tooltip-mode -1)
(menu-bar-mode -1)


;; Custom variables managed by Emacs Custom interface
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(tango-dark))
 '(custom-safe-themes
   '("0971e976bc1092a52cf092bec03f3adf63dfdb7c1a2820ab9e214845a0f5eb72" "a5270d86fac30303c5910be7403467662d7601b821af2ff0c4eb181153ebfc0a" "d445c7b530713eac282ecdeea07a8fa59692c83045bf84dd112dd738c7bcad1d" "7422e5b955cf72a2657e0b932ce00efcaee3cffd663f5d701d2442a74ab17dbf" default))
 '(package-selected-packages
   '(treemacs-magit treemacs-projectile aider xterm-color helm ripgrep dumb-jump counsel-projectile quickrun powershell yaml-mode pkgbuild-mode cargo rust-mode yasnippet ccls flycheck-pos-tip company-box lsp-ivy rainbow-delimiters ivy projectile wgrep-ag multiple-cursors dap-mode go-add-tags go-fill-struct lsp-mode web-mode rg rainbow-mode paredit markdown-mode magit htmlize go-mode flymake-shellcheck expand-region emmet-mode))
 '(package-vc-selected-packages '((aider :url "https://github.com/tninja/aider.el")))
 '(warning-suppress-types '((use-package))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Aider keybindings
;; Primeiro, definir um mapa de prefixo para C-c a
(define-prefix-command 'aider-map)
(global-set-key (kbd "C-c a") 'aider-map)

;; Agora definir os keybindings individuais
(define-key aider-map (kbd "a") 'aider-transient-menu)
(define-key aider-map (kbd "p") 'aider-open-prompt-file)
(define-key aider-map (kbd "o") 'aider-run-aider)
(define-key aider-map (kbd "s") 'aider-switch-to-buffer)
(define-key aider-map (kbd "f") 'aider-add-current-file-or-dired-marked-files)
(define-key aider-map (kbd "w") 'aider-add-files-in-current-window)
(define-key aider-map (kbd "r") 'aider-function-or-region-refactor)
(define-key aider-map (kbd "i") 'aider-implement-todo)
(define-key aider-map (kbd "t") 'aider-write-unit-test)
(define-key aider-map (kbd "F") 'aider-fix-failing-test-under-cursor)
(define-key aider-map (kbd "q") 'aider-ask-question)
(define-key aider-map (kbd "g") 'aider-go-ahead)
(define-key aider-map (kbd "e") 'aider-function-or-region-explain)

;; Atalho direto para o menu transient
(global-set-key (kbd "C-c C-a") 'aider-transient-menu)

;; MSYS2 Shell configuration
(when (eq system-type 'windows-nt)
  ;; Configuração básica do shell
  (setq explicit-shell-file-name "C:/msys64/usr/bin/bash.exe")
  (setq shell-file-name explicit-shell-file-name)
  (setq explicit-bash.exe-args '("--login" "-i"))
  
  ;; Configurar variáveis de ambiente necessárias
  (setenv "TERM" "dumb")  ;; Usar terminal dumb para evitar problemas de controle
  (setenv "SHELL" explicit-shell-file-name)
  (setenv "MSYSTEM" "MINGW64")  ;; Definir ambiente MSYS2
  (setenv "PS1" "\\[\\e[32m\\]\\w\\[\\e[0m\\] $ ")  ;; Prompt simples
  
  ;; Configurar o PATH para incluir os binários do MSYS2
  (setenv "PATH"
          (concat
           "C:\\msys64\\usr\\bin;"
           "C:\\msys64\\mingw64\\bin;"
           (getenv "PATH")))
  
  ;; Função para abrir MSYS2 shell no buffer atual
  (defun msys2-shell-toggle ()
    "Toggle MSYS2 shell in current buffer."
    (interactive)
    (let ((shell-buffer (get-buffer "*shell*")))
      (if (and shell-buffer (eq (current-buffer) shell-buffer))
          (previous-buffer)
        (shell))))
  
  ;; Keybinding para toggle do MSYS2 shell
  (global-set-key (kbd "C-c e") 'msys2-shell-toggle))

;; Configurações do shell-mode para melhor integração
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
            (setq-local comint-process-echoes nil)  ;; Desativar eco
            (setq-local comint-prompt-read-only nil)
            (setq-local comint-use-prompt-regexp nil)
            (setq-local comint-inhibit-carriage-motion t)  ;; Evitar problemas com \r
            
            ;; Melhorar a interpretação de cores ANSI
            (ansi-color-for-comint-mode-on)))

;; Configurações globais do shell
(setq shell-command-prompt-show-cwd t)
(setq comint-prompt-read-only nil)
(setq comint-process-echoes nil)
(setq shell-command-switch "-c")

(provide 'custom)
;;; custom.el ends here
