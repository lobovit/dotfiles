;;; docker.el --- Docker com dockerfile-ts-mode + yaml-ts-mode (built-in) -*- lexical-binding: t; -*-

;; ── dockerfile-ts-mode and yaml-ts-mode are configured via treesitter.el ──

;; ── yaml settings ──────────────────────────────────────────────────
(add-hook 'yaml-ts-mode-hook
          (lambda ()
            (setq-local indent-tabs-mode nil
                        tab-width 2)))

(provide 'docker)
;;; docker.el ends here
