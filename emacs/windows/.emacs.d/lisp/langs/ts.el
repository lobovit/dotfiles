;;; ts.el --- TypeScript/JavaScript/HTML/CSS com tree-sitter (built-in) -*- lexical-binding: t; -*-

;; ── Tree-sitter modes sao configurados via auto-mode-alist em treesitter.el ──
;; Aqui so configuramos indentacao e eglot

;; ── Indentacao ─────────────────────────────────────────────────────
(dolist (hook '(typescript-ts-mode-hook tsx-ts-mode-hook
               js-ts-mode-hook css-ts-mode-hook
               html-ts-mode-hook json-ts-mode-hook))
  (add-hook hook (lambda () (setq-local indent-tabs-mode nil
                                        tab-width 2
                                        standard-indent 2))))

;; ── Eglot ──────────────────────────────────────────────────────────
(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '(typescript-ts-mode . ("typescript-language-server" "--stdio")))
  (add-to-list 'eglot-server-programs
               '(tsx-ts-mode . ("typescript-language-server" "--stdio")))
  (add-to-list 'eglot-server-programs
               '(js-ts-mode . ("typescript-language-server" "--stdio")))
  (add-to-list 'eglot-server-programs
               '(html-ts-mode . ("vscode-html-language-server" "--stdio")))
  (add-to-list 'eglot-server-programs
               '(css-ts-mode . ("vscode-css-language-server" "--stdio"))))

(add-hook 'typescript-ts-mode-hook #'eglot-ensure)
(add-hook 'tsx-ts-mode-hook #'eglot-ensure)
(add-hook 'js-ts-mode-hook #'eglot-ensure)

(provide 'ts)
;;; ts.el ends here
