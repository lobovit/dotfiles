;;; completion.el --- Vertico, Consult, Orderless, Marginalia, Embark, Company -*- lexical-binding: t; -*-

(use-package vertico
  :init
  (vertico-mode 1)
  (setq vertico-cycle t))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package marginalia
  :bind (:map minibuffer-local-map
              ("M-A" . marginalia-cycle))
  :init
  (marginalia-mode 1))

(use-package embark
  :bind (("C-." . embark-act)
         ("C-;" . embark-dwim)
         ("C-h B" . embark-bindings))
  :init
  (setq prefix-help-command #'embark-prefix-help-command)
  :config
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 (display-buffer-reuse-window display-buffer-in-side-window)
                 (side . bottom)
                 (window-height . 0.25))))

(use-package consult
  :bind (("C-x b" . consult-buffer)
         ("C-x C-r" . consult-recent-file)
         ("M-y" . consult-yank-pop)
         ("M-g g" . consult-goto-line)
         ("M-g M-g" . consult-goto-line))
  :config
  (setq consult-narrow-key "<"
        consult-preview-key 'any
        consult-ripgrep-args
        "rg --null --line-buffered --color=never --max-columns=1000 --path-separator / --smart-case --no-heading --no-require-git --hidden --glob '!.git'"))

(use-package embark-consult
  :after (embark consult)
  :hook (embark-collect-mode . consult-preview-at-point-mode))

(use-package company
  :config
  (global-company-mode 1)
  (setq company-idle-delay 0.2
        company-minimum-prefix-length 1
        company-tooltip-limit 10
        company-tooltip-align-annotations t))

(use-package helpful
  :bind (("C-h f" . helpful-callable)
         ("C-h v" . helpful-variable)
         ("C-h k" . helpful-key)
         ("C-h x" . helpful-command)))

(use-package wgrep
  :config
  (setq wgrep-auto-save-buffer t))

(use-package which-key
  :config
  (which-key-mode 1)
  (setq which-key-idle-delay 0.8))

(use-package projectile
  :config
  (projectile-mode 1))

(provide 'completion)
;;; completion.el ends here
