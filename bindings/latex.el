;;;  -*- lexical-binding: t; -*-

;; auctex keybindings
(map! (:map (LaTeX-mode-map)
          :localleader
          ;; editing
          :n "e" #'LaTeX-environment
          :n "c" #'LaTeX-close-environment
          ;; build commands
          :n "a" #'TeX-command-run-all))
