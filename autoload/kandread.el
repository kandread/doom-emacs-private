;;; config/private/autoload/kandread.el -*- lexical-binding: t; -*-

;;;###autoload
(defun +kandread/open-externally ()
  "Open files externally with OSX default app."
  (interactive)
  (let ((fn (dired-get-file-for-visit)))
    (start-process "default-app" nil "open" fn)))
