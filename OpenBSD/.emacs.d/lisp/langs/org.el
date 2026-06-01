;;; org.el --- Org-mode com org-modern (GNU ELPA) -*- lexical-binding: t; -*-

(require 'org)

;; ── Core appearance ──────────────────────────────────────────────────
(setq org-startup-indented t
      org-hide-leading-stars t
      org-fontify-whole-heading-line t
      org-fontify-done-headline t
      org-fontify-quote-and-verse-blocks t
      org-hide-emphasis-markers t
      org-pretty-entities t
      org-image-actual-width nil
      org-tags-column 0
      org-use-sub-superscripts '{}
      org-ellipsis " "
      org-list-allow-alphabetical t
      org-highlight-latex-and-related '(native script entities)
      org-imenu-depth 6
      org-enforce-todo-dependencies t)

(plist-put org-format-latex-options :scale 1.5)

;; ── TODO keywords & faces ────────────────────────────────────────────

(defface my/org-todo-active
  '((t (:inherit bold :foreground "#89b4fa")))
  "Face for active TODO states (STRT, [-]).")

(defface my/org-todo-onhold
  '((t (:inherit bold :foreground "#f9e2af")))
  "Face for on-hold TODO states (WAIT, HOLD, [?]).")

(defface my/org-todo-cancel
  '((t (:inherit bold :foreground "#f38ba8")))
  "Face for cancelled TODO states (KILL).")

(setq org-todo-keywords
      '((sequence "TODO(t)" "PROJ(p)" "STRT(s)" "WAIT(w)" "HOLD(h)" "IDEA(i)"
                  "|" "DONE(d)" "KILL(k)")
        (sequence "[ ](T)" "[-](S)" "[?](W)" "|" "[X](D)")))

(setq org-todo-keyword-faces
      '(("STRT" . my/org-todo-active)
        ("[-]"  . my/org-todo-active)
        ("WAIT" . my/org-todo-onhold)
        ("HOLD" . my/org-todo-onhold)
        ("[?]"  . my/org-todo-onhold)
        ("KILL" . my/org-todo-cancel)))

(setq org-priority-faces
      '((?A . error)
        (?B . warning)
        (?C . shadow)))

;; ── org-modern (GNU ELPA) ────────────────────────────────────────────
(add-hook 'org-mode-hook #'org-modern-mode)
(add-hook 'org-agenda-finalize-hook #'org-modern-agenda)

(with-eval-after-load 'org-modern
  (setq org-modern-star '("◉" "○" "✸" "✳" "◈" "◇" "◆" "▶" "▷" "▸"))
  (setf (alist-get ?X org-modern-checkbox)
        #("☑" 0 1 (composition ((1))))))

;; ── Misc ─────────────────────────────────────────────────────────────
(add-hook 'org-mode-hook #'visual-line-mode)

(provide 'org)
;;; org.el ends here
