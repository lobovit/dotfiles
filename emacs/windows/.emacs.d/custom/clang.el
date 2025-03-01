;; clang.el - Configuration for C/C++ development

;; lsp-mode configuration
(use-package lsp-mode
  :ensure t
  :hook ((c-mode . lsp-deferred)
         (c++-mode . lsp-deferred)
         (lsp-mode . lsp-enable-which-key-integration))
  :commands (lsp lsp-deferred)
  :config
  (setq lsp-prefer-flymake nil
        lsp-enable-on-type-formatting nil
        lsp-keymap-prefix "C-c l"
        lsp-file-watch-threshold 15000)
  (define-key lsp-mode-map (kbd "C-c l") lsp-command-map))

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode
  :config
  (setq lsp-ui-doc-enable nil
        lsp-ui-doc-delay 0.5)
  (define-key lsp-ui-mode-map (kbd "M-.") #'lsp-ui-peek-find-definitions)
  (define-key lsp-ui-mode-map (kbd "M-?") #'lsp-ui-peek-find-references))


(use-package lsp-treemacs
  :ensure t
  :commands lsp-treemacs-errors-list)

;; company
(use-package company
  :ensure t
  :hook (after-init . global-company-mode)
  :bind ("M-/" . company-complete)
  :config
  (setq company-show-numbers t
        company-minimum-prefix-length 1
        company-idle-delay 0.5
        company-backends '((company-files
                           company-keywords
                           company-capf
                           company-yasnippet)
                          (company-abbrev company-dabbrev))))

(use-package company-box
  :ensure t
  :after company
  :if (display-graphic-p)  ;; Só carregar em modo gráfico
  :hook (company-mode . (lambda ()
                          (when (package-installed-p 'company-box)
                            (company-box-mode))))
  :config
  (setq company-box-icons-alist 'company-box-icons-all-the-icons))

;; flycheck
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode)
  :config
  (setq flycheck-display-errors-function
        #'flycheck-display-error-messages-unless-error-list)
  (setq flycheck-indication-mode nil))

(use-package flycheck-pos-tip
  :ensure t
  :after flycheck
  :config
  (flycheck-pos-tip-mode))

;; Hooks específicos para C/C++
(add-hook 'c-mode-hook 'lsp-deferred)
(add-hook 'c++-mode-hook 'lsp-deferred)

;; Configurações específicas para LSP em C/C++
(with-eval-after-load 'lsp-mode
  (add-to-list 'lsp-language-id-configuration '(c-mode . "c"))
  (add-to-list 'lsp-language-id-configuration '(c++-mode . "cpp")))

;; Pacotes específicos para C/C++
(use-package ccls
  :ensure t
  :hook ((c-mode c++-mode objc-mode cuda-mode) .
         (lambda () (require 'ccls) (lsp)))
  :config
  (setq ccls-executable "/usr/local/bin/ccls"
        ccls-args nil
        ccls-initialization-options
        '(:index (:comments 2) :completion (:detailedLabel t))))

(defun create-c-project (project-name)
  "Create a new C project structure and generate a .ccls file in the project root."
  (interactive "sEnter the project name: ")
  (let ((root (concat (read-directory-name "Select the root directory: ") project-name "/")))
    (make-directory root t) ; Create the root directory of the project
    ;; Create the necessary subdirectories
    (dolist (dir '("src" "build" "include" "data" "libs" "tools" "docs" "tests"))
      (make-directory (concat root dir) t))

    ;; Generate the content for the .ccls file
    (let ((ccls-content '("%clang"
                          "%c -std=gnu11"
                          "%cpp -std=gnu++14"
                          "-Iinclude")))
      (with-temp-buffer
        ;; Write the settings into the buffer and save them to the .ccls file
        (dolist (line ccls-content)
          (insert line "\n"))
        (write-file (concat root ".ccls")))
      (message "Project %s created in %s" project-name root))))

;; build system
(defun cc ()
  "Set up gmake as the compile command for the current buffer."
  (interactive)
  (set (make-local-variable 'compile-command)
       (concat "gmake "
               (if buffer-file-name
                   (shell-quote-argument
                    (file-name-sans-extension buffer-file-name))
                 "all"))))

;; Apply the keybindings when entering c-mode
(defun setup-c-mode-compile-keybindings ()
  "Set up keybindings for C mode compilation."
  (local-set-key (kbd "C-c c") 'cc))

(add-hook 'c-mode-hook 'setup-c-mode-compile-keybindings)

(provide 'clang)
;;; clang.el ends here
