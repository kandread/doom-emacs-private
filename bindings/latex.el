;;;  -*- lexical-binding: t; -*-

;; helper functions
(defun +latex/font-bold () (interactive) (TeX-font nil ?\C-b))
(defun +latex/font-code () (interactive) (TeX-font nil ?\C-t))
(defun +latex/font-emphasis () (interactive) (TeX-font nil ?\C-e))
(defun +latex/font-italic () (interactive) (TeX-font nil ?\C-i))
(defun +latex/font-normal () (interactive) (TeX-font nil ?\C-n))
(defun +latex/build ()
  (interactive)
  (progn
    (let ((TeX-save-query nil))
      (TeX-save-document (TeX-master-file)))
    (TeX-command TeX-command-default 'TeX-master-file -1)))

;; auctex keybindings
(map! (:map (LaTeX-mode-map)
          :localleader
          ;; editing
          :n "e" #'LaTeX-environment
          :n "c" #'LaTeX-close-environment
          :n "*" #'LaTeX-mark-section
          :n "." #'LaTeX-mark-environment
          :n "%" #'TeX-comment-or-uncomment-paragraph
          :n "s" #'LaTeX-section
          (:desc "fonts" :prefix "x"
            :n "b" #'+latex/font-bold
            :n "c" #'+latex/font-code
            :n "e" #'+latex/font-emphasis
            :n "i" #'+latex/font-italic
            :n "n" #'+latex/font-normal)
          ;; build commands
          :n "b" #'+latex/build
          :n "a" #'TeX-command-run-all))
