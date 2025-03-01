;;; rust.el --- Configuração para desenvolvimento em Rust -*- lexical-binding: t -*-

;;; Commentary:
;; Configurações específicas para desenvolvimento em Rust

;;; Code:

;; Hooks específicos para Rust
(add-hook 'rust-mode-hook 'lsp-deferred)

;; Configurações específicas para LSP com Rust
(with-eval-after-load 'lsp-mode
  ;; Adicionar configuração de ID de linguagem para Rust
  (add-to-list 'lsp-language-id-configuration '(rust-mode . "rust"))
  
  ;; Configurações específicas para rust-analyzer
  (setq lsp-rust-analyzer-cargo-watch-command "clippy"
        lsp-rust-analyzer-proc-macro-enable t
        lsp-rust-analyzer-cargo-load-out-dirs-from-check t))

;; Keybindings específicos para Rust
(with-eval-after-load 'rust-mode
  (define-key rust-mode-map (kbd "C-c C-c") 'cargo-process-run)
  (define-key rust-mode-map (kbd "C-c C-t") 'cargo-process-test)
  (define-key rust-mode-map (kbd "C-c C-b") 'cargo-process-build))

(provide 'rust)
;;; rust.el ends here
