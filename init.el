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
(require 'session)
(add-hook 'after-init-hook
          'session-initialize)
;;(set-default-font "Courier New-14")
(set-face-attribute 'default nil :height 130)
(global-set-key   [f2]   'ruby-mode)
(global-set-key   [f5]   'goto-line)
(global-set-key   [f6]   'revert-buffer)
(global-set-key   [f7]   'rename-buffer)
(global-set-key   [f8]   'search-backward-regexp)
(global-set-key   [f9]   'search-forward-regexp)
(cd "~/studio/yiqitou")

(setenv "PAGER" "cat")
;; seems not worked in emacs shell
;;(setenv "EDITOR" "/usr/bin/emacsclient") ;; `which emacsclient`
;;(server-start)
;; but not resolve the problem of "WARNING: terminal is not fully functional   emacs"  running M-x term is a method,but not good, M-x man reslove the man command problem,also not complete
;;(require 'magit)

;;(require 'color-theme)
;;(color-theme-initialize)
(color-theme-calm-forest)
;;(tool-bar-mode -1) ;; hide toolbar
;;(menu-bar-mode -1) ;;
(setq inhibit-splash-screen t)

;; from http://stackoverflow.com/questions/2571436/emacs-annoying-flymake-dialog-box
;; Overwrite flymake-display-warning so that no annoying dialog box is
;; used.
;; This version uses lwarn instead of message-box in the original version.
;; lwarn will open another window, and display the warning in there.
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

;; init.el end

