;;;*package-init
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
;; (package-initialize)

;;;**ox
(add-to-list 'load-path "~/.emacs.d/plugins/ox-twbs")
;; (require 'ox-twbs)
;; (require 'ox-odt)

;;;**magit
(add-to-list 'load-path "~/.emacs.d/plugins/dash")
(add-to-list 'load-path "~/.emacs.d/plugins/with-editor")
(add-to-list 'load-path "~/.emacs.d/plugins/magit/lisp")
;; (require 'magit)

;;;**unde tree
(add-to-list 'load-path "~/.emacs.d/plugins/undo-tree")
(require 'undo-tree)
(global-undo-tree-mode 1)

;;;**helm
(add-to-list 'load-path "~/.emacs.d/plugins/helm")
(require 'helm-config)
(global-set-key (kbd "M-x") #'helm-M-x)
(global-set-key (kbd "C-x r b") #'helm-filtered-bookmarks)
(global-set-key (kbd "C-x C-f") #'helm-find-files)
(global-set-key (kbd "C-x b") #'helm-buffers-list)
(helm-mode 1)

;;;**php-mode
(add-to-list 'load-path "~/.emacs.d/plugins/php-mode")
(autoload 'php-mode "php-mode" "Major mode for editing php code." t)
(add-to-list 'auto-mode-alist '("\\.php$" . php-mode))
(add-to-list 'auto-mode-alist '("\\.inc$" . php-mode))

;;;**acejump
;; ace-jump-mode
(add-to-list 'load-path "~/.emacs.d/plugins/ace-jump-mode")
(autoload
  'ace-jump-mode
  "ace-jump-mode"
  "Emacs quick move minor mode"
  t)
;; you can select the key you prefer to
(define-key global-map (kbd "C-x SPC") 'ace-jump-mode)

(autoload
  'ace-jump-mode-pop-mark
  "ace-jump-mode"
  "Ace jump back:-)"
  t)
(eval-after-load "ace-jump-mode"
  '(ace-jump-mode-enable-mark-sync))

;;;**company mode
(add-to-list 'load-path "~/.emacs.d/plugins/company-mode")
;; (add-hook 'after-init-hook 'global-company-mode)
(global-set-key (kbd "C-x t") #'company-complete)
;; (require 'company)

;;;**Dired
;; (require 'dired-x)
;; ignore hidden file
(setq-default dired-omit-files-p t) ; this is buffer-local variable
(setq dired-omit-files
    (concat dired-omit-files "\\|^\\..+$"))

(setq dired-recursive-copies 'always)
(setq dired-recursive-deletes 'always)

;;;***kill dired buffers
(defun kill-dired-buffers ()
 (interactive)
 (mapc (lambda (buffer) 
       (when (eq 'dired-mode (buffer-local-value 'major-mode buffer)) 
         (kill-buffer buffer))) 
     (buffer-list)))

;;;*Appearance
;; menu bar
(menu-bar-mode -1)

;; theme

;;;*Custom set variables
;; Put autosave files (ie #foo#) and backup files (ie foo~) in ~/.emacs.d/.
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auto-save-file-name-transforms (quote ((".*" "~/.emacscache/autosaves/\\1" t))))
 '(backup-directory-alist (quote ((".*" . "~/.emacscache/backups/"))))
 '(org-file-apps
   (quote
    ((auto-mode . emacs)
     ("\\.mm\\'" . default)
     ("\\.x?html?\\'" . "/usr/bin/tor-browser %s")
     ("\\.pdf\\'" . "/usr/bin/tor-browser %s")
     ("\\.doc\\'" . "/usr/bin/libreoffice %s")
     ("\\.odt\\'" . "/usr/bin/libreoffice %s"))))
 '(package-selected-packages (quote (persistent-soft ergoemacs-mode)))
 '(tab-stop-list
   (quote
    (4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64 68 72 76 80 84 88 92 96 100 104 108 112 116 120))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ace-jump-face-background ((t (:foreground "yellow"))))
 '(ace-jump-face-foreground ((t (:foreground "blue" :underline nil)))))

;; create the autosave dir if necessary, since emacs won't.
(make-directory "~/.emacscache/autosaves/" t)

(setq line-number-mode t)
(setq column-number-mode t)

;; (custom-set-variables
;;   '(auto-save-file-name-transforms '((".*" "~/.emacscache/autosaves/\\1" t)))
;;   '(backup-directory-alist '((".*" . "~/.emacscache/backups/"))))

;;;*duplicate line
(defun duplicate-line (arg)
  "Duplicate current line, leaving point in lower line."
  (interactive "*p")

  ;; save the point for undo
  (setq buffer-undo-list (cons (point) buffer-undo-list))

  ;; local variables for start and end of line
  (let ((bol (save-excursion (beginning-of-line) (point)))
        eol)
    (save-excursion

      ;; don't use forward-line for this, because you would have
      ;; to check whether you are at the end of the buffer
      (end-of-line)
      (setq eol (point))

      ;; store the line and disable the recording of undo information
      (let ((line (buffer-substring bol eol))
            (buffer-undo-list t)
            (count arg))
        ;; insert the line arg times
        (while (> count 0)
          (newline)         ;; because there is no newline in 'line'
          (insert line)
          (setq count (1- count)))
        )

      ;; create the undo information
      (setq buffer-undo-list (cons (cons eol (point)) buffer-undo-list)))
    ) ; end-of-let

  ;; put the point in the lowest line and return
  (next-line arg))

(global-set-key (kbd "C-x y") 'duplicate-line)

;;;*org mode
;; (global-set-key (kbd "C-c l") 'org-store-link)
(setf org-blank-before-new-entry '((heading . nil) (plain-list-item . nil)))
;; (setf org-export-babel-evaluate nil)

(defun my-org-mode-config ()
  "For use in `html-mode-hook'."
  (local-set-key (kbd "C-c C-h") 'helm-org-in-buffer-headings)
  )

(add-hook 'org-mode-hook 'my-org-mode-config)

;;;**org-add-ids-to-headlines-in-file
;; (require 'org-id)
(setq org-id-link-to-org-use-id 'create-if-interactive-and-no-custom-id)

(defun eos/org-custom-id-get (&optional pom create prefix)
  "Get the CUSTOM_ID property of the entry at point-or-marker POM.
   If POM is nil, refer to the entry at point. If the entry does
   not have an CUSTOM_ID, the function returns nil. However, when
   CREATE is non nil, create a CUSTOM_ID if none is present
   already. PREFIX will be passed through to `org-id-new'. In any
   case, the CUSTOM_ID of the entry is returned."
  (interactive)
  (org-with-point-at pom
    (let ((id (org-entry-get nil "CUSTOM_ID")))
      (cond
       ((and id (stringp id) (string-match "\\S-" id))
        id)
       (create
        (setq id (org-id-new (concat prefix "h")))
        (org-entry-put pom "CUSTOM_ID" id)
        (org-id-add-location id (buffer-file-name (buffer-base-buffer)))
        id)))))

(defun eos/org-add-ids-to-headlines-in-file ()
  "Add CUSTOM_ID properties to all headlines in the
   current file which do not already have one."
  (interactive)
  (org-map-entries (lambda () (eos/org-custom-id-get (point) 'create))))

;;;*C-h
;; (defvar my-overriding-binding-mode-map
;;   (let ((map (make-sparse-keymap)))
;;     (define-key map [?\C-h] 'delete-backward-char)
;;     (define-key map [?\M-h] 'backward-kill-word)
;;     map))

;; (define-minor-mode my-overriding-binding-mode
;;   "Personal global key-bindings."
;;   :global t)

;; (my-overriding-binding-mode 1)

;;;*sudo-edit
(defun sudo-edit (&optional arg)
  "Edit currently visited file as root.

With a prefix ARG prompt for a file to visit.
Will also prompt for a file to visit if current
buffer is not visiting a file."
  (interactive "P")
  (if (or arg (not buffer-file-name))
      (find-file (concat "/sudo:root@localhost:"
                         (ido-read-file-name "Find file(as root): ")))
    (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name))))
(global-set-key (kbd "C-x r e") 'sudo-edit)

;;; Default web browser
(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "tor-browser")

;;; Local Variables:
;;; eval: (outline-minor-mode 1)
;;; outline-regexp: ";;;\\*+\\|\\`"
;;; End:
