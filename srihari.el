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
(set-face-attribute 'default nil :font "Droid Sans Mono-10")
;;End line up down