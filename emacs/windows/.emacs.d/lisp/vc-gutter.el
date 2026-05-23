;;; vc-gutter.el --- Simple git diff indicators in fringe -*- lexical-binding: t; -*-

(defface vc-gutter-added '((t :foreground "#26a269"))
  "Face for added gutter line.")
(defface vc-gutter-removed '((t :foreground "#c01c28"))
  "Face for removed gutter line.")
(defface vc-gutter-modified '((t :foreground "#cdd129"))
  "Face for modified gutter line.")

(defvar-local vc-gutter--overlays nil)

(defun vc-gutter--diff-lines ()
  (when (and buffer-file-name
             (executable-find "git")
             (vc-backend buffer-file-name))
    (with-temp-buffer
      (let ((default-directory (file-name-directory buffer-file-name)))
        (call-process "git" nil t nil "diff" "--no-color" "-U0" "--"
                      (file-relative-name buffer-file-name)))
      (goto-char (point-min))
      (let ((result nil))
        (while (re-search-forward
                "^@@ -\\([0-9]+\\),\\([0-9]+\\) \\+\\([0-9]+\\),\\([0-9]+\\)"
                nil t)
          (let* ((old-cnt (string-to-number (match-string 2)))
                 (new-start (string-to-number (match-string 3)))
                 (new-cnt (string-to-number (match-string 4)))
                 (type (cond ((= new-cnt old-cnt) 'vc-gutter-modified)
                             ((= old-cnt 0) 'vc-gutter-added)
                             ((= new-cnt 0) 'vc-gutter-removed)
                             (t 'vc-gutter-modified))))
            (dotimes (i (max old-cnt new-cnt))
              (let ((line (if (> new-cnt 0) (+ new-start i) new-start)))
                (push (cons line type) result)))))
        (nreverse result)))))

(defun vc-gutter--clear ()
  (mapc #'delete-overlay vc-gutter--overlays)
  (setq vc-gutter--overlays nil))

(defun vc-gutter--update ()
  (when buffer-file-name
    (vc-gutter--clear)
    (let ((changes (vc-gutter--diff-lines)))
      (save-excursion
        (dolist (pair changes)
          (let ((line (car pair))
                (face (cdr pair)))
            (goto-char (point-min))
            (forward-line (1- line))
            (let ((ov (make-overlay (point) (point))))
              (overlay-put ov 'vc-gutter t)
              (overlay-put ov 'before-string
                           (propertize " " 'face face
                                       'display '(left-fringe
                                                  filled-rectangle
                                                  vc-gutter-modified)))
              (push ov vc-gutter--overlays))))))))

(defun vc-gutter--after-save ()
  (when vc-gutter-mode
    (run-with-idle-timer 0.3 nil #'vc-gutter--update)))

(define-minor-mode vc-gutter-mode
  "Show git diff indicators in the fringe."
  :lighter " VCG"
  (if vc-gutter-mode
      (progn
        (add-hook 'after-save-hook #'vc-gutter--after-save nil t)
        (add-hook 'find-file-hook #'vc-gutter--update nil t)
        (run-with-idle-timer 0.3 nil #'vc-gutter--update))
    (vc-gutter--clear)
    (remove-hook 'after-save-hook #'vc-gutter--after-save t)
    (remove-hook 'find-file-hook #'vc-gutter--update t)))

(provide 'vc-gutter)
;;; vc-gutter.el ends here
