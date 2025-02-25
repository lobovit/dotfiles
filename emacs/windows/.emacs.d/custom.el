;;; custom.el --- Custom settings -*- lexical-binding: t -*-

;;; Commentary:
;; Custom settings managed by Emacs

;;; Code:

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(tango-dark))
 '(custom-safe-themes
   '("0971e976bc1092a52cf092bec03f3adf63dfdb7c1a2820ab9e214845a0f5eb72" "a5270d86fac30303c5910be7403467662d7601b821af2ff0c4eb181153ebfc0a" "d445c7b530713eac282ecdeea07a8fa59692c83045bf84dd112dd738c7bcad1d" "7422e5b955cf72a2657e0b932ce00efcaee3cffd663f5d701d2442a74ab17dbf" default))
 '(package-selected-packages
   '(yasnippet ccls flycheck-pos-tip company-box lsp-ivy rainbow-delimiters ivy projectile wgrep-ag multiple-cursors gruvbox-theme dap-mode go-add-tags go-fill-struct lsp-mode web-mode rg rainbow-mode paredit markdown-mode magit htmlize go-mode flymake-shellcheck expand-region emmet-mode))
 '(warning-suppress-types '((use-package))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(provide 'custom)
;;; custom.el ends here
