;;; ace-window.el --- Salto rapido entre janelas (substitui avy) -*- lexical-binding: t; -*-

(defvar my/ace-chars "abcdefghijklmnopqrstuvwxyz")

(defun my/ace-window ()
  "Label visible windows with single chars, jump on keypress."
  (interactive)
  (let ((windows (window-list nil 'nomini))
        (overlays nil))
    (if (<= (length windows) 1)
        (message "Only one window")
      (dolist (w windows)
        (let* ((idx (cl-position w windows))
               (ch (aref my/ace-chars idx))
               (ov (make-overlay (window-start w) (window-start w))))
          (overlay-put ov 'after-string
                       (propertize (format " [%c] " (upcase ch))
                                   'face '(:background "#c01c28"
                                           :foreground "white"
                                           :weight bold)))
          (overlay-put ov 'window w)
          (overlay-put ov 'ace-char ch)
          (push ov overlays)))
      (unwind-protect
          (let ((key (read-key (format "Window [%s]: "
                                       (mapconcat (lambda (w i)
                                                    (upcase (string (aref my/ace-chars i))))
                                                  windows
                                                  (number-sequence 0 (1- (length windows)))
                                                  "/")))))
            (let ((ov (cl-find key overlays
                               :key (lambda (o) (overlay-get o 'ace-char))
                               :test 'eq)))
              (if ov
                  (select-window (overlay-get ov 'window))
                (message "Cancelled"))))
        (mapc #'delete-overlay overlays)))))

(provide 'ace-window)
;;; ace-window.el ends here
