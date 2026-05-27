;;; completion.el --- Icomplete, Project, Ripgrep, Which-key -*- lexical-binding: t; -*-

;; ── Icomplete vertical (built-in) ───────────────────────────────────
(icomplete-vertical-mode 1)
(setq icomplete-delay-completions-threshold 0
      icomplete-compute-delay 0
      icomplete-show-matches-on-no-input t
      icomplete-scroll t
      icomplete-hide-common-prefix nil
      icomplete-prospects-height 20)

(setq completion-styles '(flex basic)
      completion-ignore-case t)

(with-eval-after-load 'icomplete
  (define-key icomplete-minibuffer-map (kbd "C-n") #'icomplete-forward-completions)
  (define-key icomplete-minibuffer-map (kbd "C-p") #'icomplete-backward-completions)
  (define-key icomplete-minibuffer-map (kbd "<down>") #'icomplete-forward-completions)
  (define-key icomplete-minibuffer-map (kbd "<up>") #'icomplete-backward-completions)
  (define-key icomplete-minibuffer-map (kbd "C-j") #'icomplete-force-complete-and-exit))

;; ── Completion preview (built-in Emacs 30+, ghost text) ─────────
(global-completion-preview-mode 1)
(setq completion-preview-idle-delay 0.3
      completion-preview-minimum-prefix-length 2)

;; ── Dabbrev capf fallback (replaces ispell + company-dabbrev) ──
(defun my/dabbrev-capf ()
  "Completion-at-point function using dynamic abbreviation."
  (when-let* ((bounds (bounds-of-thing-at-point 'symbol))
              (prefix (buffer-substring-no-properties
                       (car bounds) (cdr bounds)))
              ((>= (length prefix) 2)))
    (let ((candidates nil)
          (seen (make-hash-table :test 'equal))
          (regexp (concat "\\_<" (regexp-quote prefix) "\\sw+\\_>"))
          (deadline (+ (float-time) 0.15)))
      (save-excursion
        (dolist (buf (buffer-list))
          (when (> (float-time) deadline)
            (cl-return))
          (unless (string-prefix-p " " (buffer-name buf))
            (with-current-buffer buf
              (save-excursion
                (goto-char (point-min))
                (while (and (< (float-time) deadline)
                            (re-search-forward regexp nil t))
                  (let ((match (match-string 0)))
                    (unless (gethash match seen)
                      (puthash match t seen)
                      (push match candidates)))))))))
      (when candidates
        (list (car bounds) (cdr bounds)
              (nreverse candidates))))))

(add-hook 'completion-at-point-functions #'my/dabbrev-capf -90)

;; ── Ispell: suppress broken word-list lookup on Windows ──────
(add-hook 'text-mode-hook
          (lambda ()
            (remove-hook 'completion-at-point-functions
                         'ispell-completion-at-point t)))

;; ── Which-key (built-in no Emacs 30+) ──────────────────────────────
(when (fboundp 'which-key-mode)
  (which-key-mode 1)
  (setq which-key-idle-delay 0.8))

;; ── Project.el (built-in) ──────────────────────────────────────────
(setq project-vc-extra-root-markers '("go.mod" ".project"))

;; ── Ripgrep wrapper ────────────────────────────────────────────────
(defun my/ripgrep (regexp)
  "Search current project using ripgrep."
  (interactive (list (read-regexp "Ripgrep: ")))
  (let ((default-directory (or (cdr-safe (project-current))
                               default-directory)))
    (grep (format "rg -nH --no-heading --color=never --smart-case %s ."
                  (shell-quote-argument regexp)))))

;; ── Keybindings ────────────────────────────────────────────────────
(global-set-key (kbd "C-x C-r") #'recentf-open-files)
(global-set-key (kbd "M-g g")  #'goto-line)
(global-set-key (kbd "M-g M-g") #'goto-line)

(provide 'completion)
;;; completion.el ends here
