;; -*- no-byte-compile: t; -*-
;;; config/private/packages.el

(when (featurep! +gtd)
  (package! org-pomodoro))

(package! magithub :ignore t)

