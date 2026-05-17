;;; treesitter.el --- Tree-sitter para syntax highlighting moderna -*- lexical-binding: t; -*-

(setq treesit-language-source-alist
      '((go . ("https://github.com/tree-sitter/tree-sitter-go"))
        (typescript . ("https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src"))
        (tsx . ("https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src"))
        (javascript . ("https://github.com/tree-sitter/tree-sitter-javascript"))
        (css . ("https://github.com/tree-sitter/tree-sitter-css"))
        (html . ("https://github.com/tree-sitter/tree-sitter-html"))
        (json . ("https://github.com/tree-sitter/tree-sitter-json"))
        (yaml . ("https://github.com/tree-sitter-grammars/tree-sitter-yaml"))
        (bash . ("https://github.com/tree-sitter/tree-sitter-bash"))
        (csharp . ("https://github.com/tree-sitter/tree-sitter-c-sharp"))))

(defvar my/treesit-langs
  '((go         go-mode          go-ts-mode)
    (typescript typescript-mode  typescript-ts-mode)
    (tsx        typescript-mode  typescript-ts-mode)
    (javascript js-mode          js-ts-mode)
    (css        css-mode         css-ts-mode)
    (html       html-mode        html-ts-mode)
    (json       json-mode        json-ts-mode)
    (yaml       yaml-mode        yaml-ts-mode)
    (bash       bash-mode        bash-ts-mode)
    (csharp     csharp-mode      csharp-ts-mode))
  "Lista de linguagens tree-sitter: (LANG LEGACY-MODE TS-MODE).")

(defun my/treesit-install-grammars ()
  "Instala todas as gramaticas tree-sitter configuradas.
Requer git e compilador C (MSYS2 + mingw-w64-x86_64-gcc no Windows)."
  (interactive)
  (unless (executable-find "git")
    (error "git nao encontrado no PATH -- necessario para clonar os repositorios"))
  (dolist (entry my/treesit-langs)
    (let ((lang (nth 0 entry)))
      (unless (treesit-ready-p lang t)
        (condition-case err
            (treesit-install-language-grammar lang)
          (error (message "Falha ao instalar grammar %s: %s"
                          lang (error-message-string err))))))))

;; ── Limpa remapeamentos residuais de ts-mode (defensivo) ──────────
(dolist (ts '(go-ts-mode typescript-ts-mode js-ts-mode css-ts-mode
              html-ts-mode json-ts-mode yaml-ts-mode bash-ts-mode
              csharp-ts-mode))
  (setq major-mode-remap-alist
        (cl-remove ts major-mode-remap-alist :key #'cdr)))

;; ── Adiciona remapeamento so se grammar carrega sem erro ──────────
(when (fboundp 'treesit-ready-p)
  (dolist (entry my/treesit-langs)
    (let ((lang (nth 0 entry))
          (legacy (nth 1 entry))
          (ts-mode (nth 2 entry)))
      (when (and (fboundp ts-mode)
                 (ignore-errors (treesit-ready-p lang t)))
        (add-to-list 'major-mode-remap-alist (cons legacy ts-mode))))))

;; ── Suprime warnings de tree-sitter quando grammar nao existe ─────
(add-to-list 'warning-suppress-types 'treesit)

(provide 'treesitter)
;;; treesitter.el ends here
