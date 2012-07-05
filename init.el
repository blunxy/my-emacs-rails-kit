;; init.el - from which all other configuration flows

(require 'cl)
(require 'ansi-color)
(require 'recentf)

(defvar root-dir "~/.emacs.d/")

(defun load-lib (name)
  (load (concat root-dir name ".el")))
(defun load-lib-dir (path)
  (add-to-list 'load-path (concat root-dir path)))

(load-lib-dir root-dir)

(setq autoload-file (concat root-dir "loaddefs.el"))
(setq custom-file (concat root-dir "custom.el"))

;; load elpa before anything else
(load-lib "emacs-elpa")

(load-lib "emacs-defaults")
(when window-system (load-lib "emacs-gui"))
(load-lib "emacs-functions")
(load-lib "emacs-vendor")
(load-lib "emacs-rails")
(load-lib "emacs-shell")

(load custom-file 'noerror)
;; Load user config and system config

(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(package-initialize)


(setq system-specific-config (concat root-dir system-name ".el")
      user-specific-config (concat root-dir user-login-name ".el"))

(if (file-exists-p system-specific-config) (load system-specific-config))
(if (file-exists-p user-specific-config) (load user-specific-config))

(set-frame-size-according-to-resolution)

;; following add by myself
(add-to-list 'load-path (expand-file-name "~/.emacs.d/rails-minor-mode"))

(require 'rails)

(add-hook 'before-save-hook 'delete-trailing-whitespace)
(set-frame-size-according-to-resolution)
(desktop-save-mode 1)
(require 'session) ;; remember load seesion in packages
(add-hook 'after-init-hook
          'session-initialize)
;;(set-default-font "Courier New-14")
(set-face-attribute 'default nil :height 150)
(global-set-key   [f2]   'ruby-mode)
(global-set-key [f5] 'revert-buffer) ;; has defined in emacs-gui.el
(global-set-key   [f6]   'goto-line)
(global-set-key   [f7]   'rename-buffer)
(global-set-key   [f8]   'search-backward-regexp)
(global-set-key   [f9]   'search-forward-regexp)
(global-set-key   [f11]  'speedbar-get-focus)
(global-set-key  (kbd "C-x RET")  'shell)
(cd "~/studio")

(setenv "PAGER" "cat")
;; seems not worked in emacs shell
;;(setenv "EDITOR" "/usr/bin/emacsclient") ;; `which emacsclient`
;;(server-start)
;; but not resolve the problem of "WARNING: terminal is not fully functional   emacs"  running M-x term is a method,but not good, M-x man reslove the man command problem,also not complete
;;(require 'magit)

(require 'color-theme)
;;(color-theme-initialize)
;; (color-theme-calm-forest)
;;(require 'color-theme-solarized)
;;(color-theme-solarized-dark)
;; (color-theme-solarized-light)

(load-file "~/.emacs.d/elpa/color-theme-railscasts-0.0.2/color-theme-railscasts.el")
(color-theme-railscasts)

;;(tool-bar-mode -1) ;; hide toolbar
;;(menu-bar-mode -1) ;;
(setq inhibit-splash-screen t)

;;from http://stackoverflow.com/questions/2571436/emacs-annoying-flymake-dialog-box
;;Overwrite flymake-display-warning so that no annoying dialog box is
;;used.
;;This version uses lwarn instead of message-box in the original version.
;;lwarn will open another window, and display the warning in there.
(defun flymake-display-warning (warning)
  "Display a warning to the user, using lwarn"
  (lwarn 'flymake :warning warning))
;; Using lwarn might be kind of annoying on its own, popping up windows and
;; what not. If you prefer to recieve the warnings in the mini-buffer, use:
(defun flymake-display-warning (warning)
  "Display a warning to the user, using lwarn"
  (message warning))

(add-to-list 'auto-mode-alist '("\\.scss\\'" . css-mode))
(add-to-list 'auto-mode-alist '("\\.js.erb\\'" . espresso-mode))

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq indent-line-function 'insert-tab)

;; use eval-buffer to repalce this command
(defun reload-init-file ()
  "reload your .emacs file without restarting Emacs"
  (interactive)
  (load-file "~/.emacs.d/init.el") )

;; transparent buffer effect
(set-frame-parameter (selected-frame) 'alpha '(85 50))
(eval-when-compile (require 'cl))
(defun toggle-transparency ()
  (interactive)
  (if (/=
       (cadr (frame-parameter nil 'alpha))
       100)
      (set-frame-parameter nil 'alpha '(100 100))
    (set-frame-parameter nil 'alpha '(85 50))))
(global-set-key (kbd "C-c t") 'toggle-transparency)
;;(require 'cedet)

(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))

;;Tips use ansi-term mode to login ssh

;; cscope not worked for ruby
;; (require 'xcscope)
;; (add-hook 'ruby-mode-hook
;; 	  '(lambda ()
;; 	    (require 'xcscope)))

;; Enabling various SEMANTIC minor modes.  See semantic/INSTALL for more ideas.
;;To startup quickly
;; Select one of the following
;; (semantic-load-enable-code-helpers)
;; (semantic-load-enable-guady-code-helpers)
;;(semantic-load-enable-excessive-code-helpers)

;; Enable this if you develop in semantic, or develop grammars
;; (semantic-load-enable-semantic-debugging-helpers)

;;To startup quickly
;; (require 'ecb-autoloads)

;; add ruby flymake check
;;;;;;;;;;;;;;;;;;;; remove this after install flymake-ruby



;;; flymake-ruby.el --- A flymake handler for ruby-mode files
;;
;;; Author: Steve Purcell <steve@sanityinc.com>
;;; URL: https://github.com/purcell/flymake-ruby
;;; Version: 0.4
;;;
;;; Commentary:
;; Usage:
;;   (require 'flymake-ruby)
;;   (add-hook 'ruby-mode-hook 'flymake-ruby-load)
;; (require 'flymake)

;; ;;; Code:

;; (defconst flymake-ruby-err-line-patterns '(("^\\(.*\\):\\([0-9]+\\): \\(.*\\)$" 1 2 nil 3)))

;; (defvar flymake-ruby-executable "ruby"
;;   "The ruby executable to use for syntax checking.")

;; (defun flymake-ruby--create-temp-in-system-tempdir (file-name prefix)
;;   "Return a temporary file name into which flymake can save.

;; This is tidier than `flymake-create-temp-inplace', and therefore
;; preferable when the checking doesn't depend on the file's exact
;; location."
;;   (make-temp-file (or prefix "flymake-ruby") nil ".rb"))

;; ;; Invoke ruby with '-c' to get syntax checking
;; (defun flymake-ruby-init ()
;;   "Construct a command that flymake can use to check ruby source."
;;   (list flymake-ruby-executable
;;         (list "-c" (flymake-init-create-temp-buffer-copy
;;                     'flymake-ruby--create-temp-in-system-tempdir))))

;; ;;;###autoload
;; (defun flymake-ruby-load ()
;;   "Configure flymake mode to check the current buffer's ruby syntax.

;; This function is designed to be called in `ruby-mode-hook'; it
;; does not alter flymake's global configuration, so function
;; `flymake-mode' alone will not suffice."
;;   (interactive)
;;   (set (make-local-variable 'flymake-allowed-file-name-masks) '(("." flymake-ruby-init)))
;;   (set (make-local-variable 'flymake-err-line-patterns) flymake-ruby-err-line-patterns)
;;   (if (executable-find flymake-ruby-executable)
;;       (flymake-mode t)
;;     (message "Not enabling flymake: '%' command not found" flymake-ruby-executable)))


;; (provide 'flymake-ruby)
;; ;;; flymake-ruby.el ends here
;; (require 'flymake-ruby) (add-hook 'ruby-mode-hook 'flymake-ruby-load)


;; add erb flymake check
;; not good, cause it will add new files end with flymake.erb
;;   with this command to delete such files : find . -type f -name '*flymake*' -exec rm '{}' \;

;; (defun flymake-erb-init ()
;;   (let* ((check-buffer (current-buffer))
;;          (temp-file (flymake-create-temp-inplace (buffer-file-name) "flymake"))
;;          (local-file (file-relative-name
;;                       temp-file
;;                       (file-name-directory buffer-file-name))))
;;     (save-excursion
;;       (save-restriction
;;         (widen)
;;         (with-temp-file temp-file
;;           (let ((temp-buffer (current-buffer)))
;;             (set-buffer check-buffer)
;;             (call-process-region (point-min) (point-max) "erb" nil temp-buffer nil "-x"))))
;;       (setq flymake-temp-source-file-name temp-file)
;;       (list "ruby" (list "-c" local-file)))))

;; (eval-after-load "flymake"
;;   '(progn
;;      (push '("\\.\\(erb\\|rhtml\\)$" flymake-erb-init) flymake-allowed-file-name-masks)
;;      (push '("^\\(.*\\):\\([0-9]+\\): \\(.*\\)$" 1 2 nil 3) flymake-err-line-patterns)))

;; (defun turn-on-flymake-for-erb-files ()
;;   (when (string-match "\.\\(erb\\|rhtml\\)$" (buffer-file-name))
;;     (flymake-mode-on)))
;; (add-hook 'find-file-hook 'turn-on-flymake-for-erb-files)

 ;; init.el end
