;;; eshell.el --- Eshell customization (built-in) -*- lexical-binding: t; -*-

(defun my/eshell-toggle ()
  "Toggle eshell in a bottom window."
  (interactive)
  (let* ((buf-name "*eshell*")
         (win (get-buffer-window buf-name)))
    (if win
        (delete-window win)
      (let ((buf (get-buffer buf-name)))
        (if buf
            (with-current-buffer buf
              (cd default-directory))
          (save-window-excursion (eshell)))
        (display-buffer (get-buffer buf-name)
                        '(display-buffer-below-selected
                          . ((window-height . 0.25))))))))

(with-eval-after-load 'eshell
  (add-hook 'eshell-mode-hook
            (lambda ()
              (company-mode -1)
              (display-line-numbers-mode -1)
              (setq-local buffer-face-mode-face
                          (list :family "monospace" :height 140))
              (buffer-face-mode 1)))
  (setq eshell-prompt-function
        (lambda ()
          (concat (propertize
                   (concat (user-real-login-name) "@"
                           (car (split-string (system-name) "\\.")))
                   'font-lock-face '(:foreground "#a6e3a1"))
                  " "
                  (propertize (abbreviate-file-name default-directory)
                              'font-lock-face '(:foreground "#89b4fa"))
                  (propertize " $" 'font-lock-face '(:foreground "#f38ba8"))
                  " "))
         eshell-prompt-regexp "^[^$#\n]*[$#] "
         eshell-highlight-prompt t
         eshell-scroll-to-bottom-on-input 'all
         eshell-scroll-show-maximum-output t
         eshell-hist-ignoredups t
         eshell-save-history-on-exit t
         eshell-error-if-no-glob nil
         eshell-glob-case-insensitive t
         eshell-cp-interactive-query t
         eshell-mv-interactive-query t
         eshell-rm-interactive-query t
         eshell-ln-interactive-query t
         eshell-plain-echo-behavior t
         eshell-destroy-buffer-when-process-dies nil
         eshell-ask-to-save-history 'always
         eshell-list-files-after-cd t
         eshell-cmpl-cycle-completions nil
         eshell-cmpl-autolist t
         eshell-banner-message ""
         eshell-visual-commands '("htop" "top" "less" "more" "nano" "vim" "vi" "emacs")
         eshell-visual-subcommands '("git" "log" "diff" "show")))

(provide 'eshell)
;;; eshell.el ends here
