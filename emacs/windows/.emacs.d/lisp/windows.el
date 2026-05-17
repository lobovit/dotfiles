;;; windows.el --- Gerenciamento de janelas e workspaces -*- lexical-binding: t; -*-

(defun my/open-workspace ()
  "Open my default workspace layout: sidebar left, current buffer center, opencode right, eshell bottom."
  (interactive)
  (delete-other-windows)
  (dirvish-side)
  (other-window 1)
  (let ((main-win (selected-window)))
    (split-window-below)
    (other-window 1)
    (eshell)
    (select-window main-win)
    (split-window-right)
    (other-window 1)
    (opencode default-directory)))

(use-package shackle
  :config
  (setq shackle-rules '(("*help*" :select t :size 0.3 :align bottom)
                        ("*compilation*" :select t :size 0.3 :align bottom)
                        ("*Messages*" :size 0.2 :align bottom)
                        ("*xref*" :select t :size 0.4 :align bottom)
                        ("*grep*" :select t :size 0.3 :align bottom)
                        ("*Flycheck errors*" :select t :size 0.25 :align bottom)))
  (shackle-mode 1))

(use-package persp-mode
  :config
  (persp-mode 1))

(use-package buffer-move)

(provide 'windows)
;;; windows.el ends here
