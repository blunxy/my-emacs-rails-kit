;; emacs-fuctions.el - useful functions, or, functions i find useful

;; the following badass functions were taken from technomancy's emacs-starter-kit
;; *we're not worthy*

(defun untabify-buffer ()
  (interactive)
  (untabify (point-min) (point-max)))

(defun indent-buffer ()
  (interactive)
  (indent-region (point-min) (point-max)))

(defun cleanup-buffer ()
  "Perform a bunch of operations on the whitespace content of a buffer."
  (interactive)
  (indent-buffer)
  (untabify-buffer)
  (delete-trailing-whitespace))

(defun recentf-ido-find-file ()
  "Find a recent file using ido."
  (interactive)
  (let ((file (ido-completing-read "Choose recent file: " recentf-list nil t)))
    (when file
      (find-file file))))

(defun recompile-init ()
  "Byte-compile all your dotfiles again."
  (interactive)
  (byte-recompile-directory root-dir 0)
  (byte-recompile-directory (concat root-dir "vendor/" 0)))

;; taken from al3x's emacs config, not sure where it from orig
(defun set-frame-size-according-to-resolution ()
  (interactive)
  (if window-system
  (progn
    ;; use 120 char wide window for largeish displays
    ;; and smaller 80 column windows for smaller displays
    ;; pick whatever numbers make sense for you
    (if (> (x-display-pixel-width) 1280)
        (add-to-list 'default-frame-alist (cons 'width 120))
      (add-to-list 'default-frame-alist (cons 'width 80)))
    ;; for the height, subtract a couple hundred pixels
    ;; from the screen height (for panels, menubars and
    ;; whatnot), then divide by the height of a char to
    ;; get the height we want
    (add-to-list 'default-frame-alist
                 (cons 'height (/ (- (x-display-pixel-height) 200) (frame-char-height)))))))

(defun run-current-spec ()
  (interactive)
  (if (string-match  "_spec.rb\\>" (buffer-file-name))
      (emamux:run-command (format "rspec -c %s" (buffer-file-name))))
  (if (string-match "\\.feature\\>" (buffer-file-name))
      (emamux:run-command (format "cu %s" (buffer-file-name))))
)
(global-set-key "\C-c\C-d" 'run-current-spec)

(defun run-all-spec ()
  (interactive)
  (setq path_to_project "~/the-rspec-book/codebreaker")
  (emamux:run-command (concatenate 'string "rspec -c " path_to_project)))


(defun run-all-feature ()
  (interactive)
  (emamux:run-command (format "cucumber ~/the-rspec-book/codebreaker")))


(defun parent-directory (dir)
  (unless (equal "/home/jpratt/" dir)
    (file-name-directory (directory-file-name dir))))

(defun boop ()
  (let* ((cmd (format "tmux new-window -n test_results;tmux send-keys -t :test_results 'cd ~/the-rspec-book/codebreaker;rspec -c' enter")))
        (call-process-shell-command cmd nil nil nil)))

;; +---------
;; | My test commands
;; |
;; +---------

;; The full way to:
;;   1) create a new window
;;   2) run a test in that window
;;
;;   (let* ((cmd (format "tmux new-window -n test_results;tmux send-keys -t :test_results 'cd ~/the-rspec-book/codebreaker;rspec -c' enter")))
;;        (call-process-shell-command cmd nil nil nil)))
;;
;; Break it up into bite-sized pieces and we get the following....

(defun project-root()
  "~/the-rspec-book/codebreaker"
)

(defun run-test-command(cmd)
  (call-process-shell-command cmd nil nil nil))

(defun run-current-test ()
  (interactive)
  (if (string-match  "_spec.rb\\>" (buffer-file-name))
      (run-test-command (build-test-cmd (spec-cmd buffer-file-name) (parent-dir buffer-file-name)))
    (if (string-match "\\.feature\\>" (buffer-file-name))
      (run-test-command (build-test-cmd (cucumber-cmd buffer-file-name) (parent-dir buffer-file-name))))))
(global-set-key "\C-c\C-d" 'run-current-test)

(defun parent-dir(file)
  (file-name-directory(directory-file-name file)))

(defun booger()
  (interactive)
  (setq foo (spec-cmd buffer-file-name))
  (message foo))

(defun run-all-specs ()
  (interactive)
  (run-test-command (build-test-cmd (spec-cmd) (project-root))))
(global-set-key "\C-c\C-e" 'run-all-specs)

(defun run-all-features ()
  (interactive)
  (run-test-command (build-test-cmd (cucumber-cmd) (project-root))))
(global-set-key "\C-c\C-f" 'run-all-features)

(defun build-test-cmd(test-cmd run-location)
  (setq new-test-result-window-cmd "tmux new-window -n test_results")
  (setq jump-to-project-cmd (format "cd %s" run-location))
  (setq send-cmd (format "tmux send-keys -t :test_results '%s;%s' ENTER" jump-to-project-cmd test-cmd))
  (format "%s;%s" new-test-result-window-cmd send-cmd))


(defun spec-cmd(&optional file)
  (if file
      (format "rspec -c %s" file)
    "rspec -c"))

(defun cucumber-cmd(&optional file)
  (if file
      (format "cucumber %s" file)
    "cucumber"))


(defun find-test-root (curr-dir)
  (cond
   ((string-match "spec/$" curr-dir) curr-dir)
   ((string-match "features/$" curr-dir) curr-dir)
   (t (let ((parent (parent-directory(expand-file-name curr-dir)))
            (child "fierce"))
        (when parent
          (cond
           ((string-match "spec/$" parent) parent)
           ((string-match "features/$" parent) parent)
           (t (find-test-rt parent))))))))
