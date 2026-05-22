;;; go.el --- Golang com go-ts-mode (built-in) e eglot -*- lexical-binding: t; -*-

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
  (setq-local tab-width 4)
  (local-set-key (kbd "C-c C-r") #'go-run-current-file)
  (local-set-key (kbd "C-c C-b") #'my-go-build)
  (local-set-key (kbd "C-c C-t") #'my-go-test)
  (add-hook 'before-save-hook #'my/go-format-and-imports -10 t))

(dolist (hook '(go-ts-mode-hook go-mod-ts-mode-hook))
  (add-hook hook #'my/go-mode-hook))

;; ── Eglot (built-in) ───────────────────────────────────────────────
(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs '(go-ts-mode . ("gopls")))
  (add-to-list 'eglot-server-programs '(go-mod-ts-mode . ("gopls"))))

(setq-default eglot-workspace-configuration
  '((:gopls .
      ((staticcheck . t)
       (matcher . "CaseSensitive")))))

(add-hook 'go-ts-mode-hook #'eglot-ensure)
(add-hook 'go-mod-ts-mode-hook #'eglot-ensure)

;; ── Flymake ────────────────────────────────────────────────────────
(global-set-key (kbd "C-c ! n") #'flymake-goto-next-error)
(global-set-key (kbd "C-c ! p") #'flymake-goto-prev-error)
(global-set-key (kbd "C-c ! l") #'flymake-show-buffer-diagnostics)

(provide 'go)
;;; go.el ends here
