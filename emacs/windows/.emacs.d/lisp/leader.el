;;; leader.el --- Leader key M-SPC (100% built-in) -*- lexical-binding: t; -*-

(defvar my/leader-map (make-sparse-keymap))
(define-key global-map (kbd "M-SPC") my/leader-map)

;; ── Arquivos e buffers ─────────────────────────────────────────────
(define-key my/leader-map (kbd ".")     #'find-file)
(define-key my/leader-map (kbd ",")     #'switch-to-buffer)
(define-key my/leader-map (kbd "f f")   #'find-file)
(define-key my/leader-map (kbd "f r")   #'recentf-open-files)
(define-key my/leader-map (kbd "b b")   #'switch-to-buffer)
(define-key my/leader-map (kbd "b k")   #'kill-current-buffer)

;; ── Busca ──────────────────────────────────────────────────────────
(define-key my/leader-map (kbd "/")     #'my/ripgrep)
(define-key my/leader-map (kbd "s r")   #'my/ripgrep)
(define-key my/leader-map (kbd "s l")   #'isearch-forward)
(define-key my/leader-map (kbd "s i")   #'imenu)

;; ── Janelas ────────────────────────────────────────────────────────
(define-key my/leader-map (kbd "w /")   #'split-window-right)
(define-key my/leader-map (kbd "w -")   #'split-window-below)
(define-key my/leader-map (kbd "w d")   #'delete-window)
(define-key my/leader-map (kbd "w o")   #'delete-other-windows)
(define-key my/leader-map (kbd "w <left>")  #'my/buf-move-left)
(define-key my/leader-map (kbd "w <right>") #'my/buf-move-right)
(define-key my/leader-map (kbd "w <up>")    #'my/buf-move-up)
(define-key my/leader-map (kbd "w <down>")  #'my/buf-move-down)

;; ── Git (via vc built-in) ──────────────────────────────────────────
(define-key my/leader-map (kbd "g g")   #'vc-dir)
(define-key my/leader-map (kbd "g l")   #'my/vc-log-toggle)
(define-key my/leader-map (kbd "g b")   #'my/vc-blame)
(define-key my/leader-map (kbd "g s")   #'my/vc-stash)
(define-key my/leader-map (kbd "g S")   #'my/vc-stash-pop)
(define-key my/leader-map (kbd "g ,")   #'my/goto-last-change)
(define-key my/leader-map (kbd "g .")   #'my/goto-last-change-reverse)

;; ── Projeto ────────────────────────────────────────────────────────
(define-key my/leader-map (kbd "p p")   #'project-switch-project)
(define-key my/leader-map (kbd "p f")   #'project-find-file)

;; ── Layout e ferramentas ───────────────────────────────────────────
(define-key my/leader-map (kbd "<tab>") #'my/open-workspace)
(define-key my/leader-map (kbd "d")     #'dired)
(define-key my/leader-map (kbd "'")     #'my/eshell-toggle)
(define-key my/leader-map (kbd "e")     #'my/eshell-toggle)
(define-key my/leader-map (kbd "E")     #'eval-buffer)
(define-key my/leader-map (kbd "o")     #'my/opencode)

;; ── Toggles ────────────────────────────────────────────────────────
(define-key my/leader-map (kbd "t l")   #'display-line-numbers-mode)
(define-key my/leader-map (kbd "t n")   #'display-line-numbers-mode)

;; ── Navegacao ──────────────────────────────────────────────────────
(define-key my/leader-map (kbd "j")     #'my/ace-window)
(define-key my/leader-map (kbd "l")     #'goto-line)

;; ── Macros (substitui multiple-cursors) ────────────────────────────
(define-key my/leader-map (kbd "m m")   #'kmacro-start-macro)
(define-key my/leader-map (kbd "m e")   #'kmacro-end-macro)
(define-key my/leader-map (kbd "m x")   #'kmacro-call-macro)

;; ── Bookmarks ─────────────────────────────────────────────────────
(define-key my/leader-map (kbd "n")     #'bookmark-jump)

;; ── Help ───────────────────────────────────────────────────────────
(define-key my/leader-map (kbd "h f")   #'describe-function)
(define-key my/leader-map (kbd "h v")   #'describe-variable)
(define-key my/leader-map (kbd "h k")   #'describe-key)
(define-key my/leader-map (kbd "h d")   #'display-local-help)

(provide 'leader)
;;; leader.el ends here
