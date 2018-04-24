;;;  -*- lexical-binding: t; -*-

;; Sets up a Getting-Things-Done (GTD) workflow using Org-mode
;;
;; Mostly taken from Brent Hansen's setup
;; http://doc.norang.ca/org-mode.html

(after! org
  ;; set org file directory
  (setq org-files-directory "~/Documents/Org/")
  ;; set agenda files
  (setq org-agenda-files (list org-files-directory))
  ;; set task states
  (setq org-todo-keywords
        (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
                (sequence "WAITING(w@/!)" "|" "SOMEDAY(o)" "CANCELLED(c@/!)"))))
  (setq org-todo-keyword-faces
        (quote (("TODO" :foreground "#cc6666" :weight bold)
                ("NEXT" :foreground "#8abeb7" :weight bold)
                ("DONE" :foreground "#b5bd68" :weight bold)
                ("WAITING" :foreground "#de935f" :weight bold)
                ("SOMEDAY" :foreground "#b294bb" :weight bold)
                ("CANCELLED" :foreground "#f0c674" :weight bold))))
  ;; trigger task states
  (setq org-todo-state-tags-triggers
        (quote (("CANCELLED" ("CANCELLED" . t))
                ("WAITING" ("WAITING" . t))
                (done ("WAITING"))
                ("TODO" ("WAITING") ("CANCELLED"))
                ("NEXT" ("WAITING") ("CANCELLED"))
                ("DONE" ("WAITING") ("CANCELLED")))))
  ;; exclude PROJECT tag from being inherited
  (setq org-tags-exclude-from-inheritance '("project"))
  ;; show inherited tags in agenda view
  (setq org-agenda-show-inherited-tags t)
  ;; set default notes file
  (setq org-default-notes-file (expand-file-name "notes.org" org-files-directory))
  ;; set capture templates
  (setq org-capture-templates
        `(("r" "respond" entry (file ,(expand-file-name "email.org" org-files-directory))
           "* TODO %a %? \nDEADLINE: %(org-insert-time-stamp (org-read-date nil t \"+1d\"))")
          ("t" "todo" entry (file ,(expand-file-name "notes.org" org-files-directory))
           "* TODO %?\n%U\n%a\n")
          ("n" "note" entry (file ,(expand-file-name "notes.org" org-files-directory))
           "* %? :note:\n%U\n%a\n")
          ("e" "event" entry (file ,(expand-file-name "meetings.org" org-files-directory))
           "* %? \n%^T\n%a\n")
          ))
  ;; set archive tag
  (setq org-archive-tag "archive")
  ;; set archive file
  (setq org-archive-location (concat org-files-directory "archive.org::* From %s"))
  ;; refiling targets include any file contributing to the agenda - up to 2 levels deep
  (setq org-refile-targets '((nil :maxlevel . 2)
                             (org-agenda-files :maxlevel . 2)))
  ;; show refile targets simultaneously
  (setq org-outline-path-complete-in-steps nil)
  ;; use full outline paths for refile targets
  (setq org-refile-use-outline-path 'file)
  ;; allow refile to create parent tasks with confirmation
  (setq org-refile-allow-creating-parent-nodes 'confirm)
  ;; exclude done tasks from refile targets
  (setq org-refile-target-verify-function #'+org-gtd/verify-refile-target)
  ;; include agenda archive files when searching for things
  (setq org-agenda-text-search-extra-files (quote (agenda-archives)))
  ;; resume clocking when emacs is restarted
  (org-clock-persistence-insinuate)
  ;; change tasks to NEXT when clocking in
  (setq org-clock-in-switch-to-state #'+org-gtd/clock-in-to-next)
  ;; separate drawers for clocking and logs
  (setq org-drawers (quote ("PROPERTIES" "LOGBOOK")))
  ;; clock out when moving task to a done state
  (setq org-clock-out-when-done t)
  ;; save the running clock and all clock history when exiting Emacs, load it on startup
  (setq org-clock-persist t)
  ;; do not prompt to resume an active clock
  (setq org-clock-persist-query-resume nil)
  ;; enable auto clock resolution for finding open clocks
  (setq org-clock-auto-clock-resolution (quote when-no-clock-is-running))
  ;; show agenda as the only window
  (setq org-agenda-window-setup 'only-window)
  ;; define stuck projects
  (setq org-stuck-projects '("+project-done/-TODO" ("NEXT" "WAITING")))
  ;; perform actions before finalizing agenda view
  (add-hook 'org-agenda-finalize-hook #'+org-gtd/cleanup-replied-emails)
  ;; exclude archived tasks from agenda view
  (setq org-agenda-tag-filter-preset '("-archive"))
  ;; disable compact block agenda view
  (setq org-agenda-compact-blocks nil)
  ;; block tasks that have unfinished subtasks
  (setq org-enforce-todo-dependencies t)
  ;; dim blocked tasks in agenda
  (setq org-agenda-dim-blocked-tasks t)
  ;; inhibit startup when preparing agenda buffer
  (setq org-agenda-inhibit-startup nil)
  ;; limit number of days before showing a future deadline
  (setq org-deadline-warning-days 7)
  ;; retain ignore options in tags-todo search
  (setq org-agenda-tags-todo-honor-ignore-options t)
  ;; hide certain tags from agenda view
  (setq org-agenda-hide-tags-regexp "project\\|started")
  ;; remove completed deadline tasks from the agenda view
  (setq org-agenda-skip-deadline-if-done t)
  ;; remove completed scheduled tasks from the agenda view
  (setq org-agenda-skip-scheduled-if-done t)
  ;; remove completed items from search results
  (setq org-agenda-skip-timestamp-if-done t)
  ;; custom agenda commands
  (setq org-agenda-custom-commands
        '(("u" "Unreplied emails" tags "email"
           ((org-agenda-overriding-header "Emails:")
            (org-tags-match-list-sublevels t)))
          ("r" "Archivable" todo "DONE"
           ((org-agenda-overriding-header "Tasks to archive:")
            (org-tags-match-list-sublevels t)))
          ("p" "Projects" tags "-done+project"
           ((org-agenda-overriding-header "Projects:")
            (org-tags-match-list-sublevels nil)))
          (" " "Agenda"
           ((agenda "" ((org-agenda-overriding-header "Today's Schedule:")
                        (org-agenda-show-log t)
                        (org-agenda-log-mode-items '(clock state))
                        (org-agenda-span 'day)
                        (org-agenda-ndays 1)
                        (org-agenda-start-on-weekday nil)
                        (org-agenda-start-day "+0d")
                        (org-agenda-todo-ignore-deadlines nil)))
            (tags-todo "-CANCELLED/!NEXT"
  			           ((org-agenda-overriding-header "Next and Active Tasks:")))
            (agenda "" ((org-agenda-overriding-header "Upcoming Deadlines:")
                        (org-agenda-entry-types '(:deadline))
                        (org-agenda-skip-function '(+org-gtd/skip-tag "email"))
                        (org-agenda-span 'day)
                        (org-agenda-ndays 1)
                        (org-deadline-warning-days 30)
                        (org-agenda-time-grid nil)))
            (agenda "" ((org-agenda-overriding-header "Week at a Glance:")
                        (org-agenda-ndays 5)
                        (org-agenda-start-day "+1d")
                        (org-agenda-skip-function '(org-agenda-skip-entry-if 'scheduled))
                        (org-agenda-skip-function '(+org-gtd/skip-tag "email"))
                        (org-agenda-time-grid nil)
                        (org-agenda-prefix-format '((agenda . "  %-12:c%?-12t %s [%b] ")))))
            (tags "refile"
                  ((org-agenda-overriding-header "Tasks to Refile:")
                   (org-tags-match-list-sublevels nil)))
            (org-agenda-list-stuck-projects)
            (tags-todo "-refile-CANCELLED-WAITING/!"
  			           ((org-agenda-overriding-header "Standalone Tasks:")
                        (org-agenda-skip-function #'+org-gtd/skip-project-tasks)
                        (org-agenda-todo-ignore-scheduled t)
                        (org-agenda-todo-ignore-deadlines t)
  			            (org-agenda-todo-ignore-with-date t)))
  	        ))
  	      ))
  ;; open files with default apps
  (setq org-file-apps
        '(("\\.docx\\'" . default)
          ("\\.pdf\\'" . default)
          ("\\.png\\'" . default)
          ("\\.odt\\'" . default)
          (auto-mode . emacs)))
  )

