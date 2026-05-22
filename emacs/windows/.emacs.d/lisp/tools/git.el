;;; git.el --- Version control com o built-in vc (substitui magit) -*- lexical-binding: t; -*-

(setq vc-follow-symlinks t
      vc-allow-asm-in-diff-mode t)

;; ── VC log toggle ───────────────────────────────────────────────────
(defun my/vc-log-toggle ()
  "Toggle the VC change log buffer in a bottom window."
  (interactive)
  (let* ((log-buf (get-buffer "*vc-change-log*"))
         (log-win (and log-buf (get-buffer-window log-buf))))
    (if log-win
        (delete-window log-win)
      (if log-buf
          (display-buffer log-buf
                          '(display-buffer-below-selected
                            . ((window-height . 0.25))))
        (vc-print-log)
        (when (get-buffer "*vc-change-log*")
          (display-buffer (get-buffer "*vc-change-log*")
                          '(display-buffer-below-selected
                            . ((window-height . 0.25)))))))))

;; ── VC blame at point ──────────────────────────────────────────────
(defun my/vc-blame ()
  "Annotate the current file with VC (git blame)."
  (interactive)
  (vc-annotate buffer-file-name
               (vc-working-revision buffer-file-name)))

;; ── VC pull ────────────────────────────────────────────────────────
(defun my/vc-pull ()
  "Pull changes from the remote."
  (interactive)
  (vc-pull nil))

;; ── VC push ────────────────────────────────────────────────────────
(defun my/vc-push ()
  "Push changes to the remote."
  (interactive)
  (vc-push nil))

;; ── VC stash ───────────────────────────────────────────────────────
(defun my/vc-stash ()
  "Stash current changes."
  (interactive)
  (vc-git-stash nil))

(defun my/vc-stash-pop ()
  "Pop the latest stash."
  (interactive)
  (vc-git-stash-pop nil))

(provide 'git)
;;; git.el ends here
