;;;  -*- lexical-binding: t; -*-

;; general keybindings
(map!

 :gnvime "A-o" #'ace-window

 (:leader
   (:desc "Org Agenda" :nv "a" #'+kandread/org-agenda-own-window)

   (:prefix "w"
     :desc "Maximize window" :nv "m" #'delete-other-windows)

   (:prefix "o"
     :desc "Eshell" :nv "S" #'+kandread/eshell-own-window
     :desc "Eshell (popup)" :nv "s" #'eshell))

 (:after dired
   (:map dired-mode-map :n "C-o" #'+kandread/open-externally))

 (:after org
   (:map org-mode-map "C-c o" #'org-pomodoro))
 (:after org-agenda
   (:map org-agenda-mode-map "C-c o" #'org-pomodoro))

 )

;; set initial state to emacs for org-agenda
(add-hook! org-agenda-mode
  (evil-set-initial-state 'org-agenda-mode 'emacs))

;; load bindings for specific modes
(load! bindings/mu4e) ; email
(load! bindings/latex) ; latex

