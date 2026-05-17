;;; git.el --- Magit, git-timemachine, git-messenger -*- lexical-binding: t; -*-

(defun my/magit-toggle-log ()
  "Toggle magit log buffer in a bottom window."
  (interactive)
  (let* ((log-buf (cl-find-if (lambda (b)
                                (with-current-buffer b
                                  (derived-mode-p 'magit-log-mode)))
                              (buffer-list)))
         (log-win (and log-buf (get-buffer-window log-buf))))
    (if log-win
        (delete-window log-win)
      (unless (and log-buf (buffer-live-p log-buf))
        (save-window-excursion
          (magit-log-all '("--oneline" "--decorate" "-n30")))
        (setq log-buf (cl-find-if (lambda (b)
                                    (with-current-buffer b
                                      (derived-mode-p 'magit-log-mode)))
                                  (buffer-list))))
      (when (and log-buf (buffer-live-p log-buf))
        (display-buffer log-buf '(display-buffer-below-selected
                                  . ((window-height . 0.25))))))))

(use-package magit
  :config
  (setq magit-display-buffer-function
        #'magit-display-buffer-same-window-except-diff-v1))

(use-package git-timemachine)

(use-package git-messenger
  :config
  (setq git-messenger:show-detail t))

(provide 'git)
;;; git.el ends here
