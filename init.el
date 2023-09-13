(setq inhibit-startup-message t)

(defvar emacs/default-font-size 140)

(scroll-bar-mode -1)		;; Disable scroll-bar
(tool-bar-mode -1)		;; Disable tool-bar	
(tooltip-mode -1)		;; Disable tooltip
(set-fringe-mode 15)		;; Disable fringes (blank spaces) on left and right of text area		
(menu-bar-mode -1)		;; Disable menu bar
(recentf-mode 1)		;; Remember which files have been recently opened
(savehist-mode 1)		;; Save history of minibuffer inputs
(save-place-mode 1)		;; Remember previous cursor position when opening a file
(global-auto-revert-mode 1)	;; Automatically detect and update buffer to relect changes to files on disk
(electric-pair-mode 1)		;; Turn on automatic parens pairing
(delete-selection-mode 1)	;; Delete selected text by typing


(setq use-dialog-box nil)	;; Do not show questions in a dialog box
(setq history-length 25)	;; Limit history to 25 items
(setq visible-bell t)		;; Set up the visible bell

(setq tab-width 4)			;; Set tab-width to 4 spaces
	

;; Set the default face
(set-face-attribute 'default nil :font "Fira Code Retina" :height emacs/default-font-size)

;; Set the fixed pitch face
(set-face-attribute 'fixed-pitch nil :font "Fira Code Retina" :height 1.05)

;; Set the variable pitch face
(set-face-attribute 'variable-pitch nil :font "Cantarell" :height 1.05 :weight 'regular)

(load-theme 'doom-dracula t)
		
;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; Initialize package sources
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("org" . "https://orgmode.org/elpa/")
			 ("elpa" . "https://elpa.gnu.org/packages/")))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

;; Add line numbers
(column-number-mode)
(global-display-line-numbers-mode t)

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
		term-mode-hook
		eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode -1))))

(use-package command-log-mode)

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
	 :map ivy-minibuffer-map
	 ("TAB" . ivy-alt-done)
	 ("C-l" . ivy-alt-done)
	 ("C-j" . ivy-next-line)
	 ("C-k" . ivy-previous-line)
	 :map ivy-switch-buffer-map
	 ("C-k" . ivy-previous-line)
	 ("C-l" . ivy-done)
	 ("C-d" . ivy-switch-buffer-kill)
	 :map ivy-reverse-i-search-map
	 ("C-k" . ivy-previous-line)
	 ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

(use-package all-the-icons)

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom
  (doom-modeline-height 35))

(use-package doom-themes)

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(use-package counsel
  :bind (("M-x" . counsel-M-x)
	 ("C-x b" . counsel-ibuffer)
	 ("C-x C-f" . counsel-find-file)
	 :map minibuffer-local-map
	 ("C-r" . 'counsel-minibuffer-history))
  :config
  (setq ivy-initial-inputs-alist nil))

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-varable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))


(use-package general
  :config
  (general-create-definer emacs/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (emacs/leader-keys
   "t"   '(:ignore t :which-key "toggles")
   "t m" '(counsel-load-theme :which-key "choose theme")
   "t s" '(hydra-text-scale/body :which-key "scale-text")
   "t f" '(neotree-toggle :which-key "neotree file viewer")
   "t t" '(vterm-toggle :which-key "vterm")
   "t r" '(recentf-open :which-key "recent files")))

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)
  (define-key evil-insert-state-map (kbd "TAB") (lambda () (interactive) (insert "\t")))
  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)
  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package hydra)

(defhydra hydra-text-scale (:timeout 4)
	  "scale text"
	  ("j" text-scale-increase "in")
	  ("k" text-scale-decrease "out")
	  ("f" nil "finished" :exit t))

(emacs/leader-keys
  "g"   '(:ignore t :which-key "git")
  "g s" '(magit-status :which-key "git status"))

(emacs/leader-keys
  "k"   '(:ignore t :which-key "kill")
  "k b" '(kill-buffer-and-window :which-key "kill buffer"))

(emacs/leader-keys
  "j"   '(:ignore t :which-key "escape")
  "j k" '(evil-force-normal-state :which-key "mode"))

(emacs/leader-keys
  "b"   '(:ignore t :which-key "buffer")
  "b k" '(kill-buffer-and-window :which-key "kill buffer")
  "b s" '(counsel-switch-buffer :which-key "switch buffer"))

(emacs/leader-keys
  "h"   '(:ignore t :which-key "help")
  "h k" '(Helper-describe-bindings :which-key "key bindings"))

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (when (file-directory-p "~/projects")
    (setq projectile-project-search-path '("~/projects")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :config (counsel-projectile-mode))

(use-package magit
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

;(use-package evil-magit
;  :after magit)

(setq auth-sources '("~/.authinfo"))

(use-package forge)

(setq transient-default-level 5)

(defun emacs/org-mode-setup ()
  (org-indent-mode 1)
  (variable-pitch-mode 1)
  (visual-line-mode 1)
  (setq org-indent-indentation-per-level 3)
  (setq org-adapt-indentation t))

(defun emacs/org-font-setup ()
  ;; Replace list hyphen with dot
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

  ;; Set faces for heading levels
  (dolist (face '((org-level-1 . 1.2)
                  (org-level-2 . 1.1)
                  (org-level-3 . 1.05)
                  (org-level-4 . 1.0)
                  (org-level-5 . 1.0)
		  (org-level-6 . 1.0)
                  (org-level-7 . 1.0)
                  (org-level-8 . 1.0)))
    (set-face-attribute (car face) nil :font "Cantarell" :weight 'regular :height (cdr face)))

  ;; Ensure that anything that should be fixed-pitch in Org files appears that way
  (set-face-attribute 'org-block nil 	:inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil   	:inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-table nil   	:inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch))

(use-package org
  :hook (org-mode . emacs/org-mode-setup)
  :config
  (setq org-ellipsis " ▾")

  (setq org-agenda-start-with-log t)
  (setq org-log-done 'time)
  (setq org-log-into-drawer t)
  
  (setq org-agenda-files
		'("~/.emacs.d/org-files/Tasks.org"
		  "~/.emacs.d/org-files/Habits.org"
		  "~/.emacs.d/org-files/Birthdays.org"))

  (require 'org-habit)
  (add-to-list 'org-modules 'org-habit)
  (setq org-habit-graph-column 60)


  (setq org-refile-targets
    '(("Archive.org" :maxlevel . 1)
      ("Tasks.org" :maxlevel . 1)))

  ;; Save Org buffers after refiling!
  (advice-add 'org-refile :after 'org-save-all-org-buffers)

  (setq org-tag-alist
    '((:startgroup)
       ; Put mutually exclusive tags here
       (:endgroup)
       ("@errand" . ?E)
       ("@home" . ?H)
       ("@work" . ?W)
       ("agenda" . ?a)
       ("planning" . ?p)
       ("publish" . ?P)
       ("batch" . ?b)
       ("note" . ?n)
       ("idea" . ?i)))

  ;; Configure custom agenda views
  (setq org-agenda-custom-commands
   '(("d" "Dashboard"
     ((agenda "" ((org-deadline-warning-days 7)))
      (todo "NEXT"
        ((org-agenda-overriding-header "Next Tasks")))
      (tags-todo "agenda/ACTIVE" ((org-agenda-overriding-header "Active Projects")))))

    ("n" "Next Tasks"
     ((todo "NEXT"
        ((org-agenda-overriding-header "Next Tasks")))))

    ("W" "Work Tasks" tags-todo "+work-email")

    ;; Low-effort next actions
    ("e" tags-todo "+TODO=\"NEXT\"+Effort<15&+Effort>0"
     ((org-agenda-overriding-header "Low Effort Tasks")
      (org-agenda-max-todos 20)
      (org-agenda-files org-agenda-files)))

    ("w" "Workflow Status"
     ((todo "WAIT"
            ((org-agenda-overriding-header "Waiting on External")
             (org-agenda-files org-agenda-files)))
      (todo "REVIEW"
            ((org-agenda-overriding-header "In Review")
             (org-agenda-files org-agenda-files)))
      (todo "PLAN"
            ((org-agenda-overriding-header "In Planning")
             (org-agenda-todo-list-sublevels nil)
             (org-agenda-files org-agenda-files)))
      (todo "BACKLOG"
            ((org-agenda-overriding-header "Project Backlog")
             (org-agenda-todo-list-sublevels nil)
             (org-agenda-files org-agenda-files)))
      (todo "READY"
            ((org-agenda-overriding-header "Ready for Work")
             (org-agenda-files org-agenda-files)))
      (todo "ACTIVE"
            ((org-agenda-overriding-header "Active Projects")
             (org-agenda-files org-agenda-files)))
      (todo "COMPLETED"
            ((org-agenda-overriding-header "Completed Projects")
             (org-agenda-files org-agenda-files)))
      (todo "CANC"
            ((org-agenda-overriding-header "Cancelled Projects")
             (org-agenda-files org-agenda-files)))))))

  (setq org-capture-templates
    `(("t" "Tasks / Projects")
      ("tt" "Task" entry (file+olp "~/.emacs.d/org-files//Tasks.org" "Inbox")
           "* TODO %?\n  %U\n  %a\n  %i" :empty-lines 1)

      ("j" "Journal Entries")
      ("jj" "Journal" entry
           (file+olp+datetree "~/.emacs.d/org-files//Journal.org")
           "\n* %<%I:%M %p> - Journal :journal:\n\n%?\n\n"
           ;; ,(dw/read-file-as-string "~/Notes/Templates/Daily.org")
           :clock-in :clock-resume
           :empty-lines 1)
      ("jm" "Meeting" entry
           (file+olp+datetree "~/.emacs.d/org-files/Journal.org")
           "* %<%I:%M %p> - %a :meetings:\n\n%?\n\n"
           :clock-in :clock-resume
           :empty-lines 1)

      ("w" "Workflows")
      ("we" "Checking Email" entry (file+olp+datetree "~/.emacs.d/org-files/Journal.org")
           "* Checking Email :email:\n\n%?" :clock-in :clock-resume :empty-lines 1)

      ("m" "Metrics Capture")
      ("mw" "Weight" table-line (file+headline "~/.emacs.d/org-files/Metrics.org" "Weight")
       "| %U | %^{Weight} | %^{Notes} |" :kill-buffer t)))

  (define-key global-map (kbd "C-c j")
			  (lambda () (interactive) (org-capture nil "jj")))
  
  (emacs/org-font-setup))

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(defun emacs/org-mode-visual-fill ()
  (setq visual-fill-column-width 200
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . emacs/org-mode-visual-fill))

(use-package dired
  :ensure nil
  :commands (dired dired-jump)
  :bind (("C-x C-j" . dired-jump))
  ; :custom (dired-listing-switches "-agho --group-directories-first")
  :config
  (evil-collection-define-key 'normal 'dired-mode-map
    "h"  	'dired-single-up-directory
    "l"		'dired-single-find-file
    "d"		'dired-create-directory
    "f"		'dired-create-empty-file))

(use-package dired-single)

(use-package all-the-icons-dired
  :hook (dired-mode . all-the-icons-dired-mode))

(use-package dired-hide-dotfiles
  :hook (dired-mode . dired-hide-dotfiles-mode)
  :config
  (evil-collection-define-key 'normal 'dired-mode-map
    "H" 'dired-hide-dotfiles-mode))

(use-package neotree
  :config
  (setq neo-autorefresh t
        neo-smart-open t
        neo-show-hidden-files t
        neo-window-width 20
        neo-window-fixed-size 20
        inhibit-compacting-font-caches t
        projectile-switch-project-action 'neotree-projectile-action
        neo-theme (if (display-graphic-p) 'icons))

  ;; Define a custom face for NeoTree
  (defface neotree-face
    '((t (:height 0.8)))
    "Custom face for NeoTree buffer.")

  ;; Truncate long file names in NeoTree and apply the custom face
  (add-hook 'neo-after-create-hook
            (lambda (_)
              (with-current-buffer (get-buffer neo-buffer-name)
                (setq truncate-lines t)
                (setq word-wrap nil)
                (make-local-variable 'auto-hscroll-mode)
                (setq auto-hscroll-mode nil)
                (buffer-face-set 'neotree-face)))))

(add-hook 'emacs-startup-hook
          (lambda ()
	    (set-frame-parameter (selected-frame) 'alpha '(95 . 85))
	    (toggle-frame-maximized)
            (neotree-toggle)))


(use-package vterm
:config
(setq shell-file-name "/bin/sh"
      vterm-max-scrollback 5000))

(use-package vterm-toggle
  :after vterm
  :config
  (setq vterm-toggle-fullscreen-p nil)
  (setq vterm-toggle-scope 'project)
  (add-to-list 'display-buffer-alist
               '((lambda (buffer-or-name _)
                     (let ((buffer (get-buffer buffer-or-name)))
                       (with-current-buffer buffer
                         (or (equal major-mode 'vterm-mode)
                             (string-prefix-p vterm-buffer-name (buffer-name buffer))))))
                  (display-buffer-reuse-window display-buffer-at-bottom)
                  ;;(display-buffer-reuse-window display-buffer-in-direction)
                  ;;display-buffer-in-direction/direction/dedicated is added in emacs27
                  ;;(direction . bottom)
                  ;;(dedicated . t) ;dedicated is supported in emacs27
                  (reusable-frames . visible)
                  (window-height . 0.3))))


(use-package typescript-mode
  :config (add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-mode)))

(setq custom-file (locate-user-emacs-file "custom-vars.el"))
(load custom-file 'noerror 'nomessage)

;; (setq backup-directory-alist '((".*" . (concat (projectile-project-root) ".trash/"))))
;; Handle temp and backup files to declutter working directory
(defun move-unwanted-files-to-trash ()
  "Move files ending in * or ~ or # to a .trash directory in the current project root."
  (interactive)
  (let ((trash-dir (concat (projectile-project-root) ".trash/")))
    (unless (file-exists-p trash-dir)
      (make-directory trash-dir t))
    (dolist (file (directory-files default-directory nil "\\*\\|~\\|#"))
      (rename-file file (expand-file-name file trash-dir) t))))

(global-set-key (kbd "C-c t") 'move-unwanted-files-to-trash)		;; Move backup files to .trash with command
(add-hook 'evil-normal-state-entry-hook 'move-unwanted-files-to-trash)	;; Move backup files to .trash on normal-mode-entry
(add-hook 'evil-insert-state-entry-hook 'move-unwanted-files-to-trash)	;; Move backup files to .trash on insert-mode-entry
(add-hook 'evil-visual-state-entry-hook 'move-unwanted-files-to-trash)	;; Move backup files to .trash on visual-mode-entry
(add-hook 'before-save-hook 'move-unwanted-files-to-trash)		;; Move backup files to .trash on save   

;(use-package ob-ipython)
(use-package ein)


(defvar ein-notebook-keybindings
  '(("C-c C-d" . ein:worksheet-delete-cell)))

 (add-hook 'ein:notebook-mode-hook
          (lambda ()
            (dolist (binding ein-notebook-keybindings)
              (define-key ein:notebook-mode-map (kbd (car binding)) (cdr binding)))))

(setq ein:output-area-inlined-images t)

(with-eval-after-load "magit-rebase"
  (magit-define-popup-option 'magit-rebase-popup
    ?S "gpg sign" "--gpg-sign=" #'read-from-minibuffer))

;;

;(org-babel-do-load-languages
; 'org-babel-load-languages
; '(
;   (emacs-lisp . t)
;   (python . t)
;   (ein .t)
;   ))
;
;
;(add-to-list 'org-structure-template-alist
;             '("p" . "src python :results output\n\n"))
;
;(setq org-confirm-babel-evaluate nil)

