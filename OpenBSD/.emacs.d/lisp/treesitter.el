;;; treesitter.el --- Tree-sitter para syntax highlighting (built-in) -*- lexical-binding: t; -*-

(require 'treesit)

(setq treesit-language-source-alist
      '((go . ("https://github.com/tree-sitter/tree-sitter-go"))
        (gomod . ("https://github.com/camdencheek/tree-sitter-go-mod" "main" "grammar"))
        (typescript . ("https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src"))
        (tsx . ("https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src"))
        (javascript . ("https://github.com/tree-sitter/tree-sitter-javascript"))
        (css . ("https://github.com/tree-sitter/tree-sitter-css"))
        (html . ("https://github.com/tree-sitter/tree-sitter-html"))
        (json . ("https://github.com/tree-sitter/tree-sitter-json"))
        (yaml . ("https://github.com/tree-sitter-grammars/tree-sitter-yaml"))
        (bash . ("https://github.com/tree-sitter/tree-sitter-bash"))
        (csharp . ("https://github.com/tree-sitter/tree-sitter-c-sharp"))
        (dockerfile . ("https://github.com/camdencheek/tree-sitter-dockerfile"))
        (markdown . ("https://github.com/tree-sitter-grammars/tree-sitter-markdown"))))

;; ── Tree-sitter lang list (lang . file patterns) ───────────────────
(defvar my/treesit-langs
  '((go        ("\\.go\\'" . go-ts-mode)      ("go\\.mod\\'" . go-mod-ts-mode))
    (typescript ("\\.ts\\'" . typescript-ts-mode)  ("\\.tsx\\'" . tsx-ts-mode))
    (javascript ("\\.js\\'" . js-ts-mode)          ("\\.cjs\\'" . js-ts-mode) ("\\.mjs\\'" . js-ts-mode))
    (css        ("\\.css\\'" . css-ts-mode))
    (html       ("\\.html?\\'" . html-ts-mode))
    (json       ("\\.json\\'" . json-ts-mode))
    (yaml       ("\\.ya?ml\\'" . yaml-ts-mode))
    (bash       ("\\.sh\\'" . bash-ts-mode)        ("\\.bash\\'" . bash-ts-mode))
    (csharp     ("\\.cs\\'" . csharp-ts-mode))
    (dockerfile ("Dockerfile\\'" . dockerfile-ts-mode) ("\\.dockerfile\\'" . dockerfile-ts-mode))
    (markdown   ("\\.md\\'" . markdown-ts-mode)    ("\\.markdown\\'" . markdown-ts-mode))))

(defun my/treesit-install-grammars ()
  "Install all configured tree-sitter grammars."
  (interactive)
  (unless (executable-find "git")
    (error "git nao encontrado no PATH"))
  (dolist (entry my/treesit-langs)
    (let ((lang (car entry)))
      (unless (treesit-ready-p lang t)
        (condition-case err
            (treesit-install-language-grammar lang)
          (error (message "Falha ao instalar grammar %s: %s"
                          lang (error-message-string err))))))))

;; ── Register file patterns in auto-mode-alist ──────────────────────
(dolist (entry my/treesit-langs)
  (let ((lang (car entry))
        (patterns (cdr entry)))
    (dolist (pat patterns)
      (let ((pattern (car pat))
            (mode (cdr pat)))
        (when (fboundp mode)
          (add-to-list 'auto-mode-alist (cons pattern mode)))))))

;; ── Enable tree-sitter modes by adding to auto-mode-alist directly ─

(provide 'treesitter)
;;; treesitter.el ends here
