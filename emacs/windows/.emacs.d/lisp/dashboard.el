;;; dashboard.el --- Tela inicial com logo do lobo  -*- lexical-binding: t; -*-

;;; Commentary:
;; Dashboard built-in que substitui o pacote `dashboard' do MELPA.
;; Exibe o lobo.png e atalhos principais usando apenas recursos nativos.

;;; Code:

(require 'cl-lib)

(defvar my/dashboard-buffer "*dashboard*"
  "Buffer name for the custom dashboard.")

(defun my/dashboard--text-width ()
  "Return usable text columns, falling back to 80."
  (or (ignore-errors (window-text-width)) (frame-text-width) 80))

(defun my/dashboard--insert-image ()
  "Insert the lobo.png logo centered in the dashboard buffer."
  (let* ((img-file (expand-file-name "images/lobo.png" user-emacs-directory))
         (img (and (file-exists-p img-file)
                   (create-image img-file nil nil :height 200))))
    (when img
      (insert "\n\n")
      (let* ((img-width-px (car (image-size img t)))
             (frame-px (frame-pixel-width))
             (margin (max 0 (/ (- frame-px img-width-px) 2))))
        (insert (propertize " " 'display `(space :width (,margin)))))
      (insert-image img)
      (insert "\n\n"))))

(defun my/dashboard--insert-heading (text)
  "Insert a centered heading TEXT."
  (let* ((w (my/dashboard--text-width))
         (pad (max 0 (/ (- w (length text)) 2))))
    (insert (make-string pad ?\s))
    (insert (propertize text 'face '(:height 1.3 :weight bold :foreground "#cba6f7")))
    (insert "\n\n")))

(defun my/dashboard--insert-button (label cmd &optional desc)
  "Insert a clickable button with LABEL, invoking CMD.
DESC is shown as a tooltip / echo-area hint."
  (insert "  ")
  (insert-text-button label
                      'action `(lambda (_) (call-interactively ',cmd))
                      'follow-link t
                      'help-echo (or desc (format "Run `%s'" cmd))
                      'face '(:foreground "#89b4fa" :underline t))
  (when desc
    (insert (propertize (format "  — %s" desc) 'face '(:foreground "#9399b2"))))
  (insert "\n"))

(defun my/dashboard--insert-section (title items)
  "Insert a titled section with ITEMS.
Each item is (label command desc)."
  (insert (propertize (concat "  " title) 'face '(:weight bold :foreground "#a6adc8")) "\n\n")
  (dolist (item items)
    (apply #'my/dashboard--insert-button item))
  (insert "\n"))

;;;###autoload
(defun my/dashboard-refresh ()
  "Generate the dashboard buffer."
  (interactive)
  (let ((buf (get-buffer-create my/dashboard-buffer)))
    (with-current-buffer buf
      (let ((inhibit-read-only t))
        (erase-buffer)
        (my/dashboard--insert-image)
        (my/dashboard--insert-heading "Emacs Solo — Lobo Mode")
        (my/dashboard--insert-section
         "Files"
         '(("Find file"       find-file        "Open file (M-SPC f f)")
           ("Recent files"    recentf-open-files "Recent files (M-SPC f r)")
           ("Open directory"  dired            "Dired (M-SPC d)")
           ("Switch buffer"   consult-buffer   "Switch buffer (M-SPC ,)")))
        (my/dashboard--insert-section
         "Projects"
         '(("Find project file" project-find-file   "Find in project (M-SPC p f)")
           ("Switch project"    project-switch-project "Switch project (M-SPC p p)")))
        (my/dashboard--insert-section
         "Search"
         '(("Ripgrep"         consult-ripgrep   "Search text (M-SPC /)")
           ("Search line"     consult-line      "Search in buffer (M-SPC s l)")
           ("Go to line"      consult-goto-line "Go to line (M-SPC l)")))
        (my/dashboard--insert-section
         "Git"
         '(("VC Dir"          vc-dir            "Git status (M-SPC g g)")
           ("VC Log"          vc-print-root-log "Git log (M-SPC g l)")))
        (my/dashboard--insert-section
         "Terminal"
         '(("Ghostel"         ghostel           "Open terminal (M-SPC T)")
           ("Eshell"          eshell            "Terminal (M-SPC ')")))
        (my/dashboard--insert-section
         "Emacs"
         '(("View bookmarks"   consult-bookmark "Bookmarks (M-SPC n)")))
        (insert "\n  ")
        (let ((ver (emacs-version)))
          (insert (propertize (concat "Emacs " (substring ver 0 (string-match " of " ver)))
                              'face '(:foreground "#585b70" :height 0.8)))))
      (goto-char (point-min))
      (special-mode)
      (setq-local cursor-type nil
                  hl-line-mode nil))
    (switch-to-buffer buf)))

(defun my/dashboard ()
  "Display the custom dashboard buffer."
  (interactive)
  (my/dashboard-refresh))

(provide 'dashboard)
;;; dashboard.el ends here
