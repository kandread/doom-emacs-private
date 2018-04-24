;;;  -*- lexical-binding: t; -*-

;; auctex keybindings
(map! (:map latex-mode)
      :localleader
      ;; editing
      :n "e" #'LaTeX-environment
      :n "c" #'LaTeX-close-environment
      ;; build commands
      :n "a" #'TeX-command-run-all)
