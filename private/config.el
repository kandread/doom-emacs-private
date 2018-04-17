;;; config/private/config.el -*- lexical-binding: t; -*-

;; load my custom keybindings
(if (featurep! +bindings) (load! +bindings))

;; load the Getting Things Done org-mode setup
(if (featurep! +gtd) (load! +gtd))

;; re-enable menu bar
(menu-bar-mode 1)

;; use relative line numbers
(setq doom-line-numbers-style 'relative)

;; exclude from recent file list
(after! recentf
  (add-to-list 'recentf-exclude "Mail/jpl"))

;; don't show recent files in switch-buffer
(setq ivy-use-virtual-buffers nil)

;; do not delegate org-agenda to shackle
(set! :popup "^\\*Org Agenda" :ignore)

;; disable magithub (slows down Emacs startup)
(def-package-hook! magithub :disable)

;; ensure that org-mu4e is loaded along with mu4e
(def-package-hook! mu4e
  :pre-config
  (require 'org-mu4e)
  t)

;; do not use rich text emails with org-mu4e
(after! org-mu4e
  (remove-hook! 'mu4e-compose-mode-hook #'org-mu4e-compose-org-mode))

;; configure email
(after! mu4e
  (setq mu4e-confirm-quit nil ; quit without asking
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
	smtpmail-smtp-service 587))
