;;; powershell.el --- PowerShell com powershell-mode + PSES via eglot -*- lexical-binding: t; -*-

;; Modo de syntax: pacote MELPA `powershell` (powershell-mode).
;; LSP: PowerShellEditorServices (PSES) em D:\softwares\powershell-editor-services,
;; iniciado via pwsh -Stdio (stdio = forma testada oficialmente com eglot).

;; ── Syntax: .ps1 / .psm1 / .psd1 ───────────────────────────────────
;; O pacote `powershell` ja registra auto-mode ("\\.ps[dm]?1\\'" . powershell-mode).
(require 'powershell)

;; ── Indentacao (padrao PowerShell: 4 espacos) ──────────────────────
(defun my/powershell-mode-hook ()
  "Configure PowerShell buffers: indent 4 spaces, no tabs."
  (setq-local indent-tabs-mode nil
              tab-width 4
              standard-indent 4))

(add-hook 'powershell-mode-hook #'my/powershell-mode-hook)

;; ── LSP: PowerShellEditorServices ──────────────────────────────────
(defvar my/pwsh-command
  (or (executable-find "pwsh")
      "C:/Users/lobor/AppData/Local/Microsoft/WindowsApps/Microsoft.PowerShell_8wekyb3d8bbwe/pwsh.exe"
      "pwsh")
  "Comando do PowerShell 7 (pwsh).")

(defvar my/pses-start-script
  "D:/softwares/powershell-editor-services/PowerShellEditorServices/Start-EditorServices.ps1"
  "Script de inicializacao do PowerShellEditorServices (PSES).")

(with-eval-after-load 'eglot
  (add-to-list
   'eglot-server-programs
   `(powershell-mode . (,my/pwsh-command
                        "-NoLogo" "-NoProfile"
                        "-File" ,my/pses-start-script
                        "-Stdio"
                        "-LogLevel" "Error"
                        "-HostName" "Emacs"
                        "-HostProfileId" "emacs"
                        "-HostVersion" "1.0.0"
                        "-BundledModulesPath" "D:/softwares/powershell-editor-services"
                        "-LogPath" "D:/softwares/powershell-editor-services/pses.log"))))

(add-hook 'powershell-mode-hook #'eglot-ensure)

(provide 'powershell)
;;; powershell.el ends here
