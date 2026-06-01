;;; completion.el --- Vertico, Orderless, Consult, Company, Which-key -*- lexical-binding: t; -*-

;; -- Vertico (GNU ELPA, minibuffer vertical completion) -------------
;; Replaces icomplete-vertical.  consult uses vertico's UI for preview.
(vertico-mode 1)
(setq vertico-resize nil
      vertico-cycle t)

;; -- Orderless (GNU ELPA, flexible matching) -------------------------
;; Replaces (flex basic).  Space = and, multiple words match in any order.
(setq completion-styles '(orderless basic)
      completion-category-defaults nil
      completion-category-overrides '((file (styles partial-completion))))

;; -- Consult (GNU ELPA) -- settings applied in init.el ---------------

;; -- Company mode (autocomplete popup, vendored) ---------------------
(add-to-list 'load-path my/lisp-dir)
(load (expand-file-name "company" my/lisp-dir) nil 'nomessage)
(setq company-idle-delay 0.2
      company-minimum-prefix-length 1
      company-show-quick-access t
      company-tooltip-align-annotations t
      company-require-match nil
      company-dabbrev-ignore-case 'keep-prefix
      company-dabbrev-downcase nil
      company-backends '((company-capf :separate)
                         company-dabbrev-code
                         company-dabbrev))
(global-company-mode 1)

;; -- Which-key (built-in on Emacs 30+) -------------------------------
(when (fboundp 'which-key-mode)
  (which-key-mode 1)
  (setq which-key-idle-delay 0.8))

;; -- Project.el (built-in) -------------------------------------------
(setq project-vc-extra-root-markers '("go.mod" ".project"))

;; -- Ripgrep wrapper -------------------------------------------------
(defun my/ripgrep (regexp)
  "Search current project using ripgrep."
  (interactive (list (read-regexp "Ripgrep: ")))
  (let ((default-directory (or (cdr-safe (project-current))
                               default-directory)))
    (grep (format "rg -nH --no-heading --color=never --smart-case %s ."
                  (shell-quote-argument regexp)))))

;; -- Keybindings -----------------------------------------------------
(global-set-key (kbd "C-x l")   #'mode-line-other-buffer)
(global-set-key (kbd "C-x C-r") #'recentf-open-files)
(global-set-key (kbd "M-g g")   #'consult-goto-line)
(global-set-key (kbd "M-g M-g") #'consult-goto-line)

(provide 'completion)
;;; completion.el ends here
