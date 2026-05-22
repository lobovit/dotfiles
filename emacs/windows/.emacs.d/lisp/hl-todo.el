;;; hl-todo.el --- Highlight TODO/FIXME/HACK em comentarios -*- lexical-binding: t; -*-

(defvar hl-todo--keywords
  '(("TODO"  . (:foreground "#cdd129" :weight bold))
    ("FIXME" . (:foreground "#c01c28" :weight bold))
    ("HACK"  . (:foreground "#c01c28" :weight bold))
    ("NOTE"  . (:foreground "#62a0ea" :weight bold))
    ("XXX"   . (:foreground "#c01c28" :weight bold))
    ("BUG"   . (:foreground "#c01c28" :weight bold)))) ;; <--- Fechamento adicionado

(defun hl-todo--highlight ()
  (font-lock-add-keywords
   nil
   (mapcar (lambda (kw)
             `(,(concat "\\<" (car kw) "\\>")
               0 (list 'face (list ,@(cdr kw))) t)) ;; Corrigido para interpretar a lista
           hl-todo--keywords)))

(add-hook 'prog-mode-hook #'hl-todo--highlight)
(add-hook 'text-mode-hook #'hl-todo--highlight)
(add-hook 'yaml-ts-mode-hook #'hl-todo--highlight)

(provide 'hl-todo)
