(global-set-key (kbd "s-/") 'hippie-expand)
(global-set-key (kbd "<f6>") 'indent-buffer)
;;http://avdi.org/devblog/2011/09/29/emacs-reboot-11-line-numbers
;;note-to-self Intention was to set linum mode when a some modes(ruby now) were loaded
(add-hook 'srihari-code-modes-hook
          (lambda () (linum-mode 1)))
(add-hook 'ruby-mode-hook
          (lambda () (run-hooks 'srihari-code-modes-hook)))
;;done hooking to rubymode