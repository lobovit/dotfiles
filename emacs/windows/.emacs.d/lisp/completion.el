;;; completion.el --- Icomplete, Project, Ripgrep, Which-key -*- lexical-binding: t; -*-

;; ── Icomplete vertical (built-in) ───────────────────────────────────
(icomplete-vertical-mode 1)
(setq icomplete-delay-completions-threshold 0
      icomplete-compute-delay 0
      icomplete-show-matches-on-no-input t
      icomplete-scroll t
      icomplete-hide-common-prefix nil
      icomplete-prospects-height 20)

(setq completion-styles '(flex basic))

(with-eval-after-load 'icomplete
  (define-key icomplete-minibuffer-map (kbd "C-n") #'icomplete-forward-completions)
  (define-key icomplete-minibuffer-map (kbd "C-p") #'icomplete-backward-completions)
  (define-key icomplete-minibuffer-map (kbd "<down>") #'icomplete-forward-completions)
  (define-key icomplete-minibuffer-map (kbd "<up>") #'icomplete-backward-completions)
  (define-key icomplete-minibuffer-map (kbd "C-j") #'icomplete-force-complete-and-exit))

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
