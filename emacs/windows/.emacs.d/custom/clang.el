;;; clang.el --- Configuração para desenvolvimento em C/C++ -*- lexical-binding: t -*-

;;; Commentary:
;; Configurações específicas para desenvolvimento em C/C++

;;; Code:

;; Hooks específicos para C/C++
(add-hook 'c-mode-hook 'lsp-deferred)
(add-hook 'c++-mode-hook 'lsp-deferred)
(add-hook 'c-mode-hook 'company-mode)
(add-hook 'c++-mode-hook 'company-mode)

;; Configurações específicas para LSP com C/C++
(with-eval-after-load 'lsp-mode
  ;; Adicionar configuração de ID de linguagem para C/C++
  (add-to-list 'lsp-language-id-configuration '(c-mode . "c"))
  (add-to-list 'lsp-language-id-configuration '(c++-mode . "cpp"))
  
  ;; Configurações específicas para clangd/ccls
  (setq lsp-clients-clangd-args '("--header-insertion=never" "--clang-tidy"))
  (add-hook 'lsp-mode-hook 'lsp-enable-which-key-integration))

;; Configurações específicas para company em C/C++
(with-eval-after-load 'company
  (add-hook 'c-mode-hook (lambda ()
                           (setq company-minimum-prefix-length 1)
                           (setq company-idle-delay 0.1))))

;; Função para criar projetos C
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

;; Configuração do sistema de build
(defun cc ()
  "Set up gmake as the compile command for the current buffer."
  (interactive)
  (set (make-local-variable 'compile-command)
       (concat "gmake "
               (if buffer-file-name
                   (shell-quote-argument
                    (file-name-sans-extension buffer-file-name))
                 "all"))))

;; Aplicar keybindings ao entrar no c-mode
(defun setup-c-mode-compile-keybindings ()
  "Set up keybindings for C mode compilation."
  (local-set-key (kbd "C-c c") 'cc))

(add-hook 'c-mode-hook 'setup-c-mode-compile-keybindings)

(provide 'clang)
;;; clang.el ends here
