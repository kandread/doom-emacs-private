;;;  -*- lexical-binding: t; -*-

;; load my custom keybindings
(load! +bindings)

;; load the Getting Things Done org-mode setup
(load! +gtd)

;; re-enable menu bar
(menu-bar-mode 1)

;; wrap lines
(global-visual-line-mode t)

;; use relative line numbers
(setq doom-line-numbers-style 'relative)

;; exclude from recent file list
(after! recentf
  (add-to-list 'recentf-exclude "Mail/jpl")
  (add-to-list 'recentf-exclude "/var"))

;; don't show recent files in switch-buffer
(setq ivy-use-virtual-buffers nil)

;; disable magithub (slows down Emacs startup)
(def-package-hook! magithub :disable)

;; change to directory with ivy even if name does not match exactly
(after! ivy
  (setq ivy-magic-slash-non-match-action 'ivy-magic-slash-non-match-cd-selected))

;; load packages related to org-mode
(def-package! org-pomodoro
  :commands org-pomodoro)
(def-package! counsel-org-clock
  :commands (counsel-org-clock-context counsel-org-clock-history))

;; configure email
(after! mu4e
  ;; load package to be able to capture emails for GTD
  (require 'org-mu4e)
  ;; do not use rich text emails
  (remove-hook! 'mu4e-compose-mode-hook #'org-mu4e-compose-org-mode)
  ;; ensure viewing messages and queries in mu4e workspace
  (advice-add 'mu4e-view-message-with-message-id :around #'+kandread/view-in-mu4e-workspace)
  (advice-add 'mu4e-headers-search :around #'+kandread/view-in-mu4e-workspace)
  ;; instead of displaying the fallback buffer (dashboard) after quitting mu4e, switch to last active buffer in workspace
  (advice-add '+email|kill-mu4e :around #'+kandread/restore-buffer-after-mu4e)
  ;; attach files to messages by marking them in dired buffer
  (require 'gnus-dired)
  (defalias 'gnus-dired-mail-buffers '+kandread/gnus-dired-mail-buffers)
  (setq gnus-dired-mail-mode 'mu4e-user-agent)
  (add-hook! 'dired-mode-hook #'turn-on-gnus-dired-mode)
  ;; configure mu4e options
  (setq mu4e-confirm-quit nil ; quit without asking
        mu4e-attachment-dir "~/Downloads"
        mu4e-maildir (expand-file-name "~/Mail/jpl")
        mu4e-get-mail-command "mbsync jpl"
        mu4e-user-mail-address-list '("kandread@jpl.nasa.gov" "konstantinos.m.andreadis@jpl.nasa.gov")
	    user-mail-address "kandread@jpl.nasa.gov"
	    user-full-name "Kostas Andreadis")
  (setq mu4e-bookmarks
	'(("flag:unread AND NOT flag:trashed" "Unread messages" ?u)
          ("date:today..now AND maildir:/inbox" "Today's messages" ?t)
          ("date:7d..now AND maildir:/inbox" "Last 7 days" ?w)))
  (setq message-send-mail-function 'smtpmail-send-it
	smtpmail-stream-type 'starttls
	smtpmail-default-smtp-server "smtp.jpl.nasa.gov"
	smtpmail-smtp-server "smtp.jpl.nasa.gov"
	smtpmail-smtp-service 587)
  ;; add custom actions for messages
  (add-to-list 'mu4e-view-actions
	       '("View in browser" . mu4e-action-view-in-browser) t))
