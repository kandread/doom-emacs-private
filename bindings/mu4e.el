;;;  -*- lexical-binding: t; -*-

;; mu4e keybindings
(after! mu4e
  (evil-set-initial-state 'mu4e-main-mode 'emacs)
  (evil-set-initial-state 'mu4e-headers-mode 'emacs)
  (evil-set-initial-state 'mu4e-view-mode 'emacs)

  (map!
   (:map (mu4e-headers-mode-map mu4e-view-mode-map)
     "c" #'org-mu4e-store-and-capture)
   (:map (mu4e-view-mode-map)
     "G" #'ace-link-mu4e)))


