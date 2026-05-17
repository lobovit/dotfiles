;;; markdown.el --- Markdown e Mermaid -*- lexical-binding: t; -*-

(defvar markdown-inline-image-overlays)
(defvar-local my/markdown-mermaid-overlays nil)

(defun my/markdown-render-mermaid ()
  "Render or clear mermaid diagram overlays in current buffer."
  (interactive)
  (if my/markdown-mermaid-overlays
      (progn
        (mapc #'delete-overlay my/markdown-mermaid-overlays)
        (setq markdown-inline-image-overlays
              (cl-set-difference markdown-inline-image-overlays
                                 my/markdown-mermaid-overlays))
        (setq my/markdown-mermaid-overlays nil))
    (save-excursion
      (goto-char (point-min))
      (while (re-search-forward "^```mermaid\\s-*\n\\(\\(?:.\\|\n\\)*?\\)\n```" nil t)
        (let* ((code (match-string 1))
               (start (match-beginning 0))
               (end (match-end 0))
               (hash (secure-hash 'md5 code))
               (cache-dir (expand-file-name "mermaid-cache" user-emacs-directory))
               (img-file (expand-file-name (concat hash ".png") cache-dir)))
          (unless (file-exists-p img-file)
            (unless (file-directory-p cache-dir) (mkdir cache-dir t))
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
                  (overlay-put ov 'face 'default)
                  (overlay-put ov 'mermaid t)
                  (push ov my/markdown-mermaid-overlays)
                  (push ov markdown-inline-image-overlays))))))))))

(defun my/markdown-display-html-images ()
  "Render HTML <img> tags as inline images."
  (save-excursion
    (save-restriction
      (widen)
      (goto-char (point-min))
      (while (re-search-forward "<img\\s-+src=\"\\([^\"]+\\)\"" nil t)
        (let* ((start (match-beginning 0))
               (end (match-end 0))
               (file (match-string-no-properties 1))
               (abspath (if (file-name-absolute-p file)
                            file
                          (expand-file-name file default-directory))))
          (when (file-exists-p abspath)
            (let ((image (create-image abspath)))
              (when image
                (let ((ov (make-overlay start end)))
                  (overlay-put ov 'display image)
                  (overlay-put ov 'face 'default)
                  (push ov markdown-inline-image-overlays))))))))))

(defun my/markdown-display-all-images ()
  "Display all inline images and HTML images in current buffer."
  (markdown-display-inline-images)
  (my/markdown-display-html-images))

(use-package markdown-mode
  :mode (("\\.md\\'" . gfm-mode)
         ("\\.markdown\\'" . gfm-mode))
  :commands (markdown-mode gfm-mode)
  :custom (markdown-display-remote-images t)
  :hook (markdown-mode . my/markdown-display-all-images)
  :bind (:map markdown-mode-command-map
              ("C-m" . my/markdown-render-mermaid)))

(use-package mermaid-mode
  :config
  (setq mermaid-output-format "png"
        mermaid-tmp-dir (expand-file-name "mermaid" temporary-file-directory))
  :bind (:map mermaid-mode-map
              ("C-c C-c" . mermaid-compile)))

(provide 'markdown)
;;; markdown.el ends here
