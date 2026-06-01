;;; windows.el --- Gerenciamento de janelas e workspaces -*- lexical-binding: t; -*-

(defun my/open-workspace ()
  "Open my default workspace layout: dired left, code center, eshell bottom."
  (interactive)
  (delete-other-windows)
  (dired default-directory)
  (split-window-right)
  (other-window 1)
  (split-window-below)
  (other-window 1)
  (eshell))

;; ── Tab bar (built-in) ─────────────────────────────────────────────
(setq tab-bar-show 1
      tab-bar-close-button-show nil
      tab-bar-new-button-show nil
      tab-bar-tab-hints t)
(tab-bar-mode 1)
(tab-bar-history-mode 1)

;; ── Display buffer rules ───────────────────────────────────────────
(add-to-list 'display-buffer-alist
             '("\\`\\*Help\\*\\'"
               (display-buffer-reuse-window display-buffer-in-side-window)
               (side . bottom)
               (window-height . 0.3)))
(add-to-list 'display-buffer-alist
             '("\\`\\*compilation\\*\\'"
               (display-buffer-reuse-window display-buffer-in-side-window)
               (side . bottom)
               (window-height . 0.3)))
(add-to-list 'display-buffer-alist
             '("\\`\\*Messages\\*\\'"
               (display-buffer-in-side-window)
               (side . bottom)
               (window-height . 0.2)))
(add-to-list 'display-buffer-alist
             '("\\`\\*xref\\*\\'"
               (display-buffer-reuse-window display-buffer-in-side-window)
               (side . bottom)
               (window-height . 0.4)))
(add-to-list 'display-buffer-alist
             '("\\`\\*grep\\*\\'"
               (display-buffer-reuse-window display-buffer-in-side-window)
               (side . bottom)
               (window-height . 0.3)))
(add-to-list 'display-buffer-alist
             '("\\` \\*dired-sidebar\\*\\'"
               (display-buffer-reuse-window display-buffer-in-side-window)
               (side . left)
               (window-width . 30)))

;; ── Dired sidebar toggle ──────────────────────────────────────────
(defvar my/dired-sidebar-buffer-name " *dired-sidebar*")

(defun my/dired-sidebar-toggle ()
  "Toggle a Dired sidebar on the left side of the frame."
  (interactive)
  (let ((win (get-buffer-window my/dired-sidebar-buffer-name)))
    (if win
        (delete-window win)
      (let ((buf (or (get-buffer my/dired-sidebar-buffer-name)
                     (let ((dir (or (cdr-safe (project-current))
                                    default-directory)))
                       (dired dir)))))
        (with-current-buffer buf
          (rename-buffer my/dired-sidebar-buffer-name))
        (display-buffer-in-side-window buf '((side . left) (window-width . 30)))))))

;; ── Buffer move (substitui buffer-move) ────────────────────────────
(defun my/buf-move (dir)
  "Swap current buffer with the buffer in DIR window."
  (let ((other (windmove-find-other-window dir)))
    (when other
      (let ((buf (current-buffer))
            (other-buf (window-buffer other)))
        (set-window-buffer other buf)
        (set-window-buffer (selected-window) other-buf)
        (select-window other)))))

(defun my/buf-move-left ()  (interactive) (my/buf-move 'left))
(defun my/buf-move-right () (interactive) (my/buf-move 'right))
(defun my/buf-move-up ()    (interactive) (my/buf-move 'up))
(defun my/buf-move-down ()  (interactive) (my/buf-move 'down))

(provide 'windows)
;;; windows.el ends here
