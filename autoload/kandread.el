;;; config/private/autoload/kandread.el -*- lexical-binding: t; -*-

;;;###autoload
(defun +kandread/open-externally ()
  "Open files externally with OSX default app."
  (interactive)
  (let ((fn (dired-get-file-for-visit)))
    (start-process "default-app" nil "open" fn)))

;;;###autoload
(defun +kandread/org-agenda-own-window ()
  "Run Org Agenda in its own window."
  (interactive)
  (without-popups! (org-agenda)))

;;;###autoload
(defun +kandread/eshell-own-window ()
  "Run Eshell in its own window."
  (interactive)
  (without-popups! (eshell)))

;;;###autoload
(defun +kandread/view-in-mu4e-workspace (func &rest args)
  "Advice function to view messages and queries in email workspace."
  (persp-switch "*mu4e*")
  (apply func args))

;;;###autoload
(defun +kandread/restore-buffer-after-mu4e (func &rest args)
  "Fix issue with fallback buffer when quitting mu4e."
  (apply func args)
  (evil-switch-to-windows-last-buffer))

;;;###autoload
(defun +kandread/gnus-dired-mail-buffers ()
  "Return a list of active message buffers."
  (let (buffers)
    (save-current-buffer
      (dolist (buffer (buffer-list t))
        (set-buffer buffer)
        (when (and (derived-mode-p 'message-mode)
                (null message-sent-message-via))
          (push (buffer-name buffer) buffers))))
    (nreverse buffers)))
