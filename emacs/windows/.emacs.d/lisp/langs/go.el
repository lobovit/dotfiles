;;; go.el --- Golang: gopls, eglot, flycheck -*- lexical-binding: t; -*-

(require 'cl-lib)
(require 'subr-x)
(require 'project)

(defun project-find-go-module (dir)
  (when-let ((root (locate-dominating-file dir "go.mod")))
    (cons 'go-module root)))

(cl-defmethod project-root ((project (head go-module)))
  (cdr project))

(add-hook 'project-find-functions #'project-find-go-module)

(defun go-run-current-file ()
  "Run goimports then go run on the current Go file."
  (interactive)
  (let ((file (shell-quote-argument buffer-file-name)))
    (shell-command (concat "goimports -w " file " && go run " file))
    (revert-buffer nil t)))

(defun my-go-build ()
  "Build the current Go module."
  (interactive)
  (compile "go build ./..."))

(defun my-go-test ()
  "Test the current Go module."
  (interactive)
  (compile "go test ./..."))

(defun my/go-format-and-imports ()
  "Format buffer and organize imports via eglot/gopls."
  (when (eglot-managed-p)
    (eglot-format-buffer)
    (eglot-code-actions (point-min) (point-max) nil "source.organizeImports" nil)))

(defun my/go-mode-hook ()
  (local-set-key (kbd "C-c C-r") #'go-run-current-file)
  (local-set-key (kbd "C-c C-b") #'my-go-build)
  (local-set-key (kbd "C-c C-t") #'my-go-test)
  (add-hook 'before-save-hook #'my/go-format-and-imports -10 t))

(use-package go-mode
  :mode ("\\.go\\'" . go-mode)
  :hook ((go-mode . eglot-ensure)
         (go-mode . my/go-mode-hook)
         (go-ts-mode . eglot-ensure)
         (go-ts-mode . my/go-mode-hook))
  :config
  (setq-default go-tab-width 4)
  (setq indent-tabs-mode t)
  (setq tab-width 4))

(use-package eglot
  :ensure nil
  :config
  (with-no-warnings
    (add-to-list 'eglot-server-programs '(go-mode . ("gopls")))
    (add-to-list 'eglot-server-programs '(go-ts-mode . ("gopls")))
    (add-to-list 'eglot-server-programs '(js-mode . ("typescript-language-server" "--stdio")))
    (add-to-list 'eglot-server-programs '(typescript-mode . ("typescript-language-server" "--stdio")))
    (add-to-list 'eglot-server-programs '(typescript-ts-mode . ("typescript-language-server" "--stdio")))
    (add-to-list 'eglot-server-programs '(tsx-ts-mode . ("typescript-language-server" "--stdio")))
    (add-to-list 'eglot-server-programs '(csharp-mode . ("OmniSharp.exe" "-lsp")))
    (add-to-list 'eglot-server-programs '(csharp-ts-mode . ("OmniSharp.exe" "-lsp"))))
  (setq-default eglot-workspace-configuration
    '((:gopls .
        ((staticcheck . t)
         (matcher . "CaseSensitive"))))))

(use-package flycheck
  :config
  (global-flycheck-mode t))

(use-package flycheck-golangci-lint
  :after (go-mode flycheck)
  :hook (go-mode . flycheck-golangci-lint-setup)
  :hook (go-ts-mode . flycheck-golangci-lint-setup))

(provide 'go)
;;; go.el ends here
