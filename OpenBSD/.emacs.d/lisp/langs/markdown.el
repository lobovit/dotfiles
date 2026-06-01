;;; markdown.el --- Markdown com markdown-ts-mode (built-in) e mermaid -*- lexical-binding: t; -*-

(defvar-local my/markdown-mermaid-overlays nil)

(defun my/markdown-render-mermaid ()
  "Render or clear mermaid diagram overlays in current buffer."
  (interactive)
  (if my/markdown-mermaid-overlays
      (progn
        (mapc #'delete-overlay my/markdown-mermaid-overlays)
        (setq my/markdown-mermaid-overlays nil))
    (save-excursion
      (goto-char (point-min))
      (while (re-search-forward "^```mermaid\n\\(\\(?:.\\|\n\\)*?\\)\n```" nil t)
        (let* ((code (match-string 1))
               (start (match-beginning 0))
               (end (match-end 0))
               (hash (secure-hash 'md5 code))
               (cache-dir (expand-file-name "mermaid-cache" user-emacs-directory))
               (img-file (expand-file-name (concat hash ".png") cache-dir)))
          (unless (file-exists-p img-file)
            (unless (file-directory-p cache-dir) (make-directory cache-dir t))
            (let ((mmd-file (make-temp-file "mermaid-" nil ".mmd" code)))
              (call-process "mmdc" nil nil nil
                            "-i" mmd-file "-o" img-file
                            "--backgroundColor" "transparent")
              (delete-file mmd-file)))
          (when (file-exists-p img-file)
            (let ((image (create-image img-file)))
              (when image
                (let ((ov (make-overlay start end)))
                  (overlay-put ov 'display image)
                  (push ov my/markdown-mermaid-overlays))))))))))

;; ── Bind mermaid render in markdown ─────────────────────────────────
(with-eval-after-load 'markdown-ts-mode
  (define-key markdown-ts-mode-map (kbd "C-c C-m") #'my/markdown-render-mermaid))

;; ── Enable visual wrap for prose ───────────────────────────────────
(add-hook 'markdown-ts-mode-hook #'visual-line-mode)
(add-hook 'markdown-mode-hook #'visual-line-mode)

(provide 'markdown)
;;; markdown.el ends here
