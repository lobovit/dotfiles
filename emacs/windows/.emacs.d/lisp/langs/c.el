;;; c.el --- C/C++ com c-ts-mode (built-in) e eglot/clangd -*- lexical-binding: t; -*-

(require 'cl-lib)
(require 'subr-x)

(defun my/c-build ()
  "Build the C/C++ project in the current directory."
  (interactive)
  (compile "cmake --build build || cmake -S . -B build && cmake --build build"))

(defun my/c-run ()
  "Run the most recently built C/C++ binary, if present."
  (interactive)
  ;; No Windows o binário termina em .exe; tenta ./build/main e ./build/main.exe.
  (compile "cmake --build build && (./build/main || ./build/main.exe || ./build/Debug/main.exe)"))

(defun my/c-format-buffer ()
  "Format current buffer with clang-format."
  (interactive)
  (when (executable-find "clang-format")
    (shell-command-on-region
     (point-min) (point-max) "clang-format" nil t)))

(defun my/c-mode-hook ()
  "Configure C/C++ buffers: indent, keys, save hooks."
  (setq-local c-basic-offset 4)
  (setq-local tab-width 4)
  (setq-local indent-tabs-mode nil)
  (local-set-key (kbd "C-c C-b") #'my/c-build)
  (local-set-key (kbd "C-c C-r") #'my/c-run)
  (when (executable-find "clang-format")
    (add-hook 'before-save-hook #'my/c-format-buffer nil t)))

(dolist (hook '(c-ts-mode-hook c++-ts-mode-hook))
  (add-hook hook #'my/c-mode-hook))

;; ── Eglot (built-in) ───────────────────────────────────────────────
;; clangd instalado via winget em D:/softwares/LLVM/bin (ver init.el).
;; Habilita eglot sempre; se clangd estiver ausente o Emacs avisa apenas
;; ao abrir um buffer C, em vez de silenciosamente não ativar o LSP.
(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs '(c-ts-mode . ("clangd")))
  (add-to-list 'eglot-server-programs '(c++-ts-mode . ("clangd")))
  (add-to-list 'eglot-server-programs '(c-mode . ("clangd")))
  (add-to-list 'eglot-server-programs '(c++-mode . ("clangd"))))

(add-hook 'c-ts-mode-hook #'eglot-ensure)
(add-hook 'c++-ts-mode-hook #'eglot-ensure)

;; ── Clang-format config ────────────────────────────────────────────
(with-eval-after-load 'cc-mode
  (setq-default c-default-style "linux"))

(provide 'c)
;;; c.el ends here
