;;; ts.el --- TypeScript, JavaScript, Web mode -*- lexical-binding: t; -*-

(use-package typescript-mode
  :mode ("\\.ts\\'" "\\.tsx\\'"))

(use-package web-mode
  :mode (("\\.html?\\'" . web-mode)
         ("\\.css\\'" . web-mode)
         ("\\.jsx\\'" . web-mode))
  :config
  (setq web-mode-markup-indent-offset 2
        web-mode-css-indent-offset 2
        web-mode-code-indent-offset 2
        web-mode-enable-auto-pairing t
        web-mode-enable-auto-closing t
        web-mode-enable-auto-quoting t))

(provide 'ts)
;;; ts.el ends here
