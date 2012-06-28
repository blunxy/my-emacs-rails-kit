(global-set-key (kbd "s-/") 'hippie-expand)
(global-set-key (kbd "<f6>") 'indent-buffer)
;;http://avdi.org/devblog/2011/09/29/emacs-reboot-11-line-numbers
;;note-to-self Intention was to set linum mode when a some modes(ruby now) were loaded
(add-hook 'srihari-code-modes-hook
          (lambda () (linum-mode 1)))
(add-hook 'ruby-mode-hook
          (lambda () (run-hooks 'srihari-code-modes-hook)))
;;done hooking to rubymode

;;Line up down using https://github.com/bbatsov/emacs-prelude/blob/master/prelude-core.el#L111
;;
(defun move-line-up ()
  "Move up the current line."
  (interactive)
  (transpose-lines 1)
  (previous-line 2))

(global-set-key [(control shift up)] 'move-line-up)

(defun move-line-down ()
  "Move down the current line."
  (interactive)
  (next-line 1)
  (transpose-lines 1)
  (previous-line 1))

(global-set-key [(control shift down)] 'move-line-down)
;;End line up down

(set-face-attribute 'default nil :font "Droid Sans Mono-10")
(add-to-list 'load-path "~/.emacs.d/vendor/coffee-mode")
(require 'coffee-mode)

(setq default-cursor-type 'bar)
;;End line up down

                                        ; Temporary files cluttering up the space are annoying.  Here's how we
                                        ; can deal with them -- create a directory in your home directory, and
                                        ; save to there instead!  No more random ~ files.
(defvar user-temporary-file-directory
  "~/.emacs-autosaves/")
(make-directory user-temporary-file-directory t)
(setq backup-by-copying t)
(setq backup-directory-alist
      `(("." . ,user-temporary-file-directory)
        (tramp-file-name-regexp nil)))
(setq auto-save-list-file-prefix
      (concat user-temporary-file-directory ".auto-saves-"))
(setq auto-save-file-name-transforms
      `((".*" ,user-temporary-file-directory t)))

(eval-after-load 'ruby-mode '(require 'rails-apidock))
(eval-after-load 'rhtml-mode '(require 'rails-apidock))

(defun revert-all-buffers ()
  "Refreshes all open buffers from their respective files"
  (interactive)
  (let* ((list (buffer-list))
         (buffer (car list)))
    (while buffer
      (when (and (buffer-file-name buffer) 
                 (not (buffer-modified-p buffer)))
        (set-buffer buffer)
        (revert-buffer t t t))
      (setq list (cdr list))
      (setq buffer (car list))))
  (message "Refreshed open files"))

(global-set-key [(control f5)] 'revert-all-buffers)