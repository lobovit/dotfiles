;;; leader.el --- Leader key (M-SPC) com general.el -*- lexical-binding: t; -*-

(use-package general
  :after which-key
  :config
  (general-override-mode 1)
  (general-create-definer my/leader
    :keymaps 'override
    :prefix "M-SPC")
  (my/leader
   :which-key "leader"
   ;; Arquivos e buffers
   "." 'find-file
   "," 'consult-buffer
   "f f" 'find-file
   "f r" 'consult-recent-file
   "b b" 'consult-buffer
   "b k" 'kill-this-buffer
   ;; Busca
   "/" 'consult-ripgrep
   "s r" 'consult-ripgrep
   "s l" 'consult-line
   "s i" 'consult-imenu
   ;; Janelas
   "w /" 'split-window-right
   "w -" 'split-window-below
   "w d" 'delete-window
   "w o" 'delete-other-windows
   "w <left>" 'buf-move-left
   "w <right>" 'buf-move-right
   "w <up>" 'buf-move-up
   "w <down>" 'buf-move-down
   ;; Git
   "g g" 'magit-status
   "g l" 'my/magit-toggle-log
   "g t" 'git-timemachine-toggle
   "g p" 'git-messenger:popup-message
   "g ," 'goto-last-change
   "g ." 'goto-last-change-reverse
   ;; Projeto
   "p p" 'projectile-switch-project
   "p f" 'projectile-find-file
   ;; Layout e ferramentas
   "TAB" 'my/open-workspace
   "d" 'dirvish-side
   "D" 'dashboard-open
   "'" 'my/eshell-toggle
   "e" 'my/eshell-toggle
   "E" 'eval-buffer
   "o" (lambda () (interactive) (opencode default-directory))
   ;; Toggles
   "t l" 'display-line-numbers-mode
   "t n" 'display-line-numbers-mode
   ;; Navegação visual
   "j" 'avy-goto-char-timer
   "l" 'avy-goto-line
   ;; Multiple cursors
   "m c" 'mc/edit-lines
   "m n" 'mc/mark-next-like-this
   "m p" 'mc/mark-previous-like-this
   "m a" 'mc/mark-all-like-this
   ;; Help
   "h f" 'helpful-callable
   "h v" 'helpful-variable
   "h k" 'helpful-key
   "h d" 'helpful-at-point))

(provide 'leader)
;;; leader.el ends here
