;;; ghostel.el --- Terminal emulator powered by libghostty-vt -*- lexical-binding: t; -*-

(setq ghostel-module-directory
      (expand-file-name "ghostel" user-emacs-directory))

(require 'ghostel)

(setq ghostel-shell "powershell.exe")

(provide 'ghostel)
;;; ghostel.el ends here
