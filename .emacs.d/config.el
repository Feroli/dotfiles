(setq user-full-name "Fernando Ania"
      user-mail-address "javierania21@gmail.com")

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file)

(use-package moe-theme
  :if (window-system)
  :ensure t
  :init )

(defun switch-theme (theme)
  "Disables any currently active themes and loads THEME."
  ;; This interactive call is taken from `load-theme'
  (interactive
   (list
    (intern (completing-read "Load custom theme: "
                             (mapc 'symbol-name
                                   (custom-available-themes))))))
  (let ((enabled-themes custom-enabled-themes))
    (mapc #'disable-theme custom-enabled-themes)
    (load-theme theme t)))

(defun disable-active-themes ()
  "Disables any currently active themes listed in `custom-enabled-themes'."
  (interactive)
  (mapc #'disable-theme custom-enabled-themes))

(bind-key "s-<f12>" 'switch-theme)
(bind-key "s-<f11>" 'disable-active-themes)

(add-to-list 'default-frame-alist
             '(font . "Inconsolata-14"))

;; These functions are useful. Activate them.
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'dired-find-alternate-file 'disabled nil)

;; Answering just 'y' or 'n' will do
(defalias 'yes-or-no-p 'y-or-n-p)

;; Keep all backup and auto-save files in one directory
(setq backup-directory-alist '(("." . "~/.saves")))
(setq auto-save-file-name-transforms '((".*" "~/.saves/auto-save-list/" t)))

;; UTF-8 please
(setq locale-coding-system 'utf-8) ; pretty
(set-terminal-coding-system 'utf-8) ; pretty
(set-keyboard-coding-system 'utf-8) ; pretty
(set-selection-coding-system 'utf-8) ; please
(prefer-coding-system 'utf-8) ; with sugar on top
(setq-default indent-tabs-mode nil)

;; Turn off the blinking cursor
(blink-cursor-mode -1)

(setq-default indent-tabs-mode nil)
(setq-default indicate-empty-lines t)

;; Don't count two spaces after a period as the end of a sentence.
;; Just one space is needed.
(setq sentence-end-double-space nil)

;; delete the region when typing, just like as we expect nowadays.
(delete-selection-mode t)

(show-paren-mode t)

(column-number-mode t)

(global-visual-line-mode)
(diminish 'visual-line-mode)

(setq uniquify-buffer-name-style 'forward)

;; -i gets alias definitions from .bash_profile
(setq shell-command-switch "-ic")

;; Don't beep at me
(setq visible-bell t)

;; highlight line
(global-hl-line-mode t)

;; Delete trailing white space on save
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; files in bin should start in sh mode
(add-to-list 'auto-mode-alist '("/bin/" . sh-mode))

(defun occur-dwim ()
  "Call `occur' with a sane default."
  (interactive)
  (push (if (region-active-p)
            (buffer-substring-no-properties
             (region-beginning)
             (region-end))
          (thing-at-point 'symbol))
        regexp-history)
  (call-interactively 'occur))

(bind-key "M-s o" 'occur-dwim)

(use-package page-break-lines
  :ensure t)

(global-set-key (kbd "C-M-g") 'google-this-search) ; Ctrl+Alt+g

(setq powerline-default-separator 'slant)

(let ((is-mac (string-equal system-type "darwin")))
  (when is-mac
    ;; delete files by moving them to the trash
    (setq delete-by-moving-to-trash t)
    (setq trash-directory "~/.Trash")

    ;; Don't make new frames when opening a new file with Emacs
    (setq ns-pop-up-frames nil)

    ;; set the Fn key as the hyper key
    (setq ns-function-modifier 'hyper)

    ;; Use Command-` to switch between Emacs windows (not frames)
    (bind-key "s-`" 'other-window)

    ;; Use Command-Shift-` to switch Emacs frames in reverse
    (bind-key "s-~" (lambda() () (interactive) (other-window -1)))

    ;; Because of the keybindings above, set one for `other-frame'
    (bind-key "s-1" 'other-frame)

    ;; Fullscreen!
    (setq ns-use-native-fullscreen nil) ; Not Lion style
    (bind-key "<s-return>" 'toggle-frame-fullscreen)

    ;; buffer switching
    (bind-key "s-{" 'previous-buffer)
    (bind-key "s-}" 'next-buffer)

    ;; Compiling
    (bind-key "H-c" 'compile)
    (bind-key "H-r" 'recompile)
    (bind-key "H-s" (defun save-and-recompile () (interactive) (save-buffer) (recompile)))

    ;; disable the key that minimizes emacs to the dock because I don't
    ;; minimize my windows
    ;; (global-unset-key (kbd "C-z"))

    (defun open-dir-in-finder ()
      "Open a new Finder window to the path of the current buffer"
      (interactive)
      (shell-command "open ."))
    (bind-key "s-/" 'open-dir-in-finder)

    (defun open-dir-in-iterm ()
      "Open the current directory of the buffer in iTerm."
      (interactive)
      (let* ((iterm-app-path "/Applications/iTerm.app")
             (iterm-brew-path "/opt/homebrew-cask/Caskroom/iterm2/1.0.0/iTerm.app")
             (iterm-path (if (file-directory-p iterm-app-path)
                             iterm-app-path
                           iterm-brew-path)))
        (shell-command (concat "open -a " iterm-path " ."))))
    (bind-key "s-=" 'open-dir-in-iterm)

    ;; Not going to use these commands
    (put 'ns-print-buffer 'disabled t)
    (put 'suspend-frame 'disabled t)))

(use-package exec-path-from-shell
  :if (memq window-system '(mac ns))
  :ensure t
  :init
  (exec-path-from-shell-initialize))

;; make ibuffer the default buffer lister.
(defalias 'list-buffers 'ibuffer)

(add-hook 'dired-mode-hook 'auto-revert-mode)

;; Also auto refresh dired, but be quiet about it
(setq global-auto-revert-non-file-buffers t)
(setq auto-revert-verbose nil)

(use-package recentf
  :commands ido-recentf-open
  :init
  (progn
    (recentf-mode t)
    (setq recentf-max-saved-items 200)

    (defun ido-recentf-open ()
      "Use `ido-completing-read' to \\[find-file] a recent file"
      (interactive)
      (if (find-file (ido-completing-read "Find recent file: " recentf-list))
          (message "Opening file...")
        (message "Aborting")))

    (bind-key "C-x C-r" 'ido-recentf-open)))

(bind-key "C-c l" 'org-store-link)
(bind-key "C-c c" 'org-capture)
(bind-key "C-c a" 'org-agenda)

(setq org-agenda-files
      (delq nil
            (mapcar (lambda (x) (and (file-exists-p x) x))
                    '("~/Dropbox/Agenda"))))

(bind-key "C-c c" 'org-capture)
(setq org-default-notes-file "~/Dropbox/Notes/notes.org")

(setq org-use-speed-commands t)

(setq org-image-actual-width 550)

(setq org-tags-column 45)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)
   (C . t)
   (calc . t)
   (latex . t)
   (java . t)
   (ruby . t)
   (lisp . t)
   (scheme . t)
   (sh . t)
   (sqlite . t)
   (js . t)))

(defun my-org-confirm-babel-evaluate (lang body)
  "Do not confirm evaluation for these languages."
  (not (or (string= lang "C")
           (string= lang "java")
           (string= lang "python")
           (string= lang "emacs-lisp")
           (string= lang "sqlite"))))
(setq org-confirm-babel-evaluate 'my-org-confirm-babel-evaluate)

(setq org-src-fontify-natively t
      org-src-window-setup 'current-window
      org-src-strip-leading-and-trailing-blank-lines t
      org-src-preserve-indentation t
      org-src-tab-acts-natively t)

(use-package ox-pandoc
  :ensure t)

(use-package org-pandoc :ensure t)

(use-package org-bullets
 :ensure t
 :config
 (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

;; mdfind is the command line interface to Spotlight
(setq locate-command "mdfind")
(global-set-key (kbd "C-c f l") 'locate)

;; limit to org files
(defun locate-org-files (search-string)
  (interactive "sSearch string: ")
  (locate-with-filter search-string ".org$"))

(global-set-key (kbd "C-c f o") 'locate-org-files)

;; limit locations
(defun locate-my-org-files (search-string)
  (let ((tech (concat (getenv "HOME") "/technical"))
        (pers (concat (getenv "HOME") "/personal"))
        (note (concat (getenv "HOME") "/notes"))
        (jrnl (concat (getenv "HOME") "/journal")))
    (-flatten (list "mdfind"
             (if (file-exists-p tech) (list "-onlyin" tech))
             (if (file-exists-p pers) (list "-onlyin" pers))
             (if (file-exists-p note) (list "-onlyin" note))
             (if (file-exists-p jrnl) (list "-onlyin" jrnl))
             "-interpret" search-string))))

(setq locate-make-command-line 'locate-my-org-files)

;; using find my notes script for context
(defun find-notes (words)
  "Uses my 'find-notes' shell script as a better grep
utility. Not only does it show the results in a clickable list,
it also highlights the result, allowing us to put more context in
the output."
  (interactive "sSearch for words:")
  (let ((program (concat (getenv "HOME") "/bin/dotfiles/find-notes"))
        (buffer-name (concat "*find-notes: " words "*")))
    (call-process program nil buffer-name t words)
    (switch-to-buffer buffer-name)
    (read-only-mode 1)
    (grep-mode)
    (toggle-truncate-lines)
    (beginning-of-buffer)
    (dolist (word (split-string words))
      (highlight-regexp word))))

(global-set-key (kbd "C-x C-n") 'find-notes)
(global-set-key (kbd "C-c f n") 'find-notes)

(bind-key "C-x m" 'shell)
(bind-key "C-x M" 'ansi-term)

(use-package multi-term :ensure t)

(bind-key "s-C-<left>"  'shrink-window-horizontally)
(bind-key "s-C-<right>" 'enlarge-window-horizontally)
(bind-key "s-C-<down>"  'shrink-window)
(bind-key "s-C-<up>"    'enlarge-window)

(defun vsplit-other-window ()
  "Splits the window vertically and switches to that window."
  (interactive)
  (split-window-vertically)
  (other-window 1 nil))
(defun hsplit-other-window ()
  "Splits the window horizontally and switches to that window."
  (interactive)
  (split-window-horizontally)
  (other-window 1 nil))

(bind-key "C-x 2" 'vsplit-other-window)
(bind-key "C-x 3" 'hsplit-other-window)

(use-package windmove :ensure t)
(windmove-default-keybindings)
(global-set-key (kbd "C-c <left>")  'windmove-left)
(global-set-key (kbd "C-c <right>") 'windmove-right)
(global-set-key (kbd "C-c <up>")    'windmove-up)
(global-set-key (kbd "C-c <down>")  'windmove-down)

(use-package winner
  :config
  (winner-mode t)
  :bind (("M-s-<left>" . winner-undo)
         ("M-s-<right>" . winner-redo)))

(use-package transpose-frame
  :ensure t
  :bind ("H-t" . transpose-frame))

(use-package sr-speedbar :ensure t)
(defadvice sr-speedbar-open (around ome-sr-speedbar-open disable)
  ad-do-it
  (with-current-buffer sr-speedbar-buffer-name
    (setq window-size-fixed 'width)))

(defun ome-sr-speedbar-setup ()
  ;;keep speed bar window width after resizing
  (ad-enable-advice 'sr-speedbar-open 'around 'ome-sr-speedbar-open)
  (ad-activate 'sr-speedbar-open)
  (setq sr-speedbar-skip-other-window-p t)
  (setq sr-speedbar-right-side nil))

;; (use-package main-line :ensure t
;; :init (progn
;;        (setq main-line-separator-style 'arrow)))

(use-package powerline
   :ensure t)
(custom-set-faces
 '(mode-line-buffer-id ((t (:foreground "#000000" :bold t))))
 '(which-func ((t (:foreground "#77aaff"))))
 '(mode-line ((t (:foreground "#000000" :background "#dddddd" :box nil))))
 '(mode-line-inactive ((t (:foreground "#000000" :background "#bbbbbb" :box nil)))))

(defun powerline-simpler-vc-mode (s)
  (if s
      (replace-regexp-in-string "Git[:-]" "" s)
    s))

;; Some point, we could change the text of the minor modes, but we
;; need to get the text properties and sub them /back in/. To be
;; figured out later... Like:
;;   (let* ((props (text-properties-at 1 s))
;;          (apple (set-text-properties 0 1 props "⌘"))
;;          (fly-c (set-text-properties 0 1 props "✓"))
;;          (news1 (replace-regexp-in-string "񓵸" apple s)))
;;          (news2 (replace-regexp-in-string "FlyC" fly-c news1)))

(defun powerline-simpler-minor-display (s)
    (replace-regexp-in-string
     (concat " " (mapconcat 'identity '("񓵸" "Projectile" "Fill" "BufFace") "\\|")) "" s))

(defun powerline-ha-theme ()
  "A powerline theme that removes many minor-modes that don't serve much purpose on the mode-line."
  (interactive)
  (setq-default mode-line-format
                '("%e"
                  (:eval
                   (let*
                       ((active
                         (powerline-selected-window-active))
                        (mode-line
                         (if active 'mode-line 'mode-line-inactive))
                        (face1
                         (if active 'powerline-active1 'powerline-inactive1))
                        (face2
                         (if active 'powerline-active2 'powerline-inactive2))
                        (separator-left
                         (intern
                          (format "powerline-%s-%s" powerline-default-separator
                                  (car powerline-default-separator-dir))))
                        (separator-right
                         (intern
                          (format "powerline-%s-%s" powerline-default-separator
                                  (cdr powerline-default-separator-dir))))
                        (lhs
                         (list
                          (powerline-raw "%*" nil 'l)
                          ;; (powerline-buffer-size nil 'l)
                          (powerline-buffer-id nil 'l)
                          (powerline-raw " ")
                          (funcall separator-left mode-line face1)
                          (powerline-narrow face1 'l)
                          (powerline-simpler-vc-mode (powerline-vc face1))))
                        (rhs
                         (list
                          (powerline-raw mode-line-misc-info face1 'r)
                          (powerline-raw "%4l" face1 'r)
                          (powerline-raw ":" face1)
                          (powerline-raw "%3c" face1 'r)
                          (funcall separator-right face1 mode-line)
                          (powerline-raw " ")
                          (powerline-raw "%6p" nil 'r)
                          (powerline-hud face2 face1)))
                        (center
                         (list
                          (powerline-raw " " face1)
                          (funcall separator-left face1 face2)
                          (when
                              (boundp 'erc-modified-channels-object)
                            (powerline-raw erc-modified-channels-object face2 'l))
                          (powerline-major-mode face2 'l)
                          (powerline-process face2)
                          (powerline-raw " :" face2)

                          (powerline-simpler-minor-display
                           (powerline-minor-modes face2 'l))

                          (powerline-raw " " face2)
                          (funcall separator-right face2 face1))))
                     (concat
                      (powerline-render lhs)
                      (powerline-fill-center face1
                                             (/
                                              (powerline-width center)
                                              2.0))
                      (powerline-render center)
                      (powerline-fill face1
                                      (powerline-width rhs))
                      (powerline-render rhs)))))))

(powerline-ha-theme)
(provide 'init-mode-line)

(use-package ido
  :init
  (setq ido-enable-flex-matching t)
  (setq ido-everywhere t)
  (setq ido-use-virtual-buffers t)
  (ido-mode t)
  (use-package ido-vertical-mode
    :ensure t
    :init (ido-vertical-mode 1)
    (setq ido-vertical-define-keys 'C-n-and-C-p-only)))

(use-package flx-ido :ensure t)
(flx-ido-mode 1)
;; disable ido faces to see flx highlights.
(setq ido-enable-flex-matching t)
(setq ido-use-faces nil)

(use-package whitespace
  :bind ("s-<f10>" . whitespace-mode))

(use-package company
     :ensure t)
(add-hook 'after-init-hook 'global-company-mode)

(use-package company-web :ensure t)

(use-package company-ghc :ensure t)

(use-package company-quickhelp
  :ensure t
  :config
  (company-quickhelp-mode 1))

(use-package autopair :ensure t)
;;;(autopair-global-mode 1)

(use-package ac-html :ensure t)

(use-package ac-html-angular :ensure t)

(use-package ac-html-csswatcher :ensure t)

(use-package google :ensure t)

(use-package google-this :ensure t)

(use-package ace-jump-mode
  :ensure t
  :diminish ace-jump-mode
  :commands ace-jump-mode
  :bind ("C-S-s" . ace-jump-mode))

(use-package ace-window
  :ensure t
  :config
  (setq aw-keys '(?a ?o ?e ?u ?h ?t ?n ?s))
  (ace-window-display-mode)
  :bind ("s-o" . ace-window))

(use-package ace-flyspell :ensure t)

(use-package avy
  :ensure t
  :commands avy-goto-word-1 avy-goto-char-1 avy-goto-line avy-goto-char-timer
  :bind
  ("C-c j"   . avy-goto-word-1)
  ("C-c k k" . avy-goto-char-timer)
  ("C-c k j" . avy-goto-word-1)
  ("C-c k c" . avy-goto-char-1)
  ("C-c k l" . avy-goto-line))

(use-package android-mode
  :ensure t)

(use-package c-eldoc
  :commands c-turn-on-eldoc-mode
  :ensure t
  :init (add-hook 'c-mode-hook #'c-turn-on-eldoc-mode))

(use-package clojure-mode
  :ensure t)

(use-package dash-at-point
  :ensure t
  :bind (("s-D"     . dash-at-point)
         ("C-c e"   . dash-at-point-with-docset)))

(use-package helm
  :ensure t
  :diminish helm-mode
  :init (progn
          (require 'helm-config)
          (use-package helm-projectile
            :ensure t
            :commands helm-projectile
            :bind ("C-c p h" . helm-projectile)
            :config (setq projectile-enable-caching t)
                    (setq projectile-indexing-method 'alien))
          (use-package helm-ag :defer 10  :ensure t)
          (setq helm-locate-command "mdfind -interpret -name %s %s"
                helm-ff-newfile-prompt-p nil
                helm-M-x-fuzzy-match t
                helm-bookmark-show-location t
                helm-buffers-fuzzy-matching t
                helm-completion-in-region-fuzzy-match t
                helm-file-cache-fuzzy-match t
                helm-imenu-fuzzy-match t
                helm-mode-fuzzy-match t
                helm-locate-fuzzy-match t
                helm-quick-update t
                helm-recentf-fuzzy-match t
                helm-semantic-fuzzy-match t)
          (helm-mode)
          (use-package helm-swoop :ensure t :bind ("M-i" . helm-swoop)))
  :bind (("C-c h" . helm-command-prefix)
         ("C-x b" . helm-mini)
         ("C-`" . helm-resume)
         ("M-x" . helm-M-x)
         ("C-x C-f" . helm-find-files)
         ("M-y" . helm-show-kill-ring)))

(use-package magit
  :ensure t
  :commands magit-status magit-blame
  :init
  (defadvice magit-status (around magit-fullscreen activate)
    (window-configuration-to-register :magit-fullscreen)
    ad-do-it
    (delete-other-windows))
  :config
  (setq magit-branch-arguments nil
        ;; use ido to look for branches
        magit-completing-read-function 'magit-ido-completing-read
        ;; don't put "origin-" in front of new branch names by default
        magit-default-tracking-name-function 'magit-default-tracking-name-branch-only
        magit-push-always-verify nil
        ;; Get rid of the previous advice to go into fullscreen
        magit-restore-window-configuration t)

  :bind ("C-x g" . magit-status))

;; full screen magit-status
(defadvice magit-status (around magit-fullscreen activate)
  (window-configuration-to-register :magit-fullscreen)
  ad-do-it
  (delete-other-windows))

(defun magit-quit-session ()
  "Restores the previous window configuration and kills the magit buffer"
  (interactive)
  (kill-buffer)
  (jump-to-register :magit-fullscreen))

(use-package edit-server
  :ensure t
  :config
  (edit-server-start)
  (setq edit-server-default-major-mode 'markdown-mode)
  (setq edit-server-new-frame nil))

(use-package ein
  :ensure t)

(use-package expand-region
  :ensure t
  :bind ("C-@" . er/expand-region))

(use-package flycheck
  :ensure t
  :defer 10
  :config (global-flycheck-mode t)
          (setq flycheck-html-tidy-executable "tidy5"))

(use-package flyspell
  :ensure t
  :diminish flyspell-mode
  :init
  (add-hook 'prog-mode-hook 'flyspell-prog-mode)

  (dolist (hook '(text-mode-hook org-mode-hook))
    (add-hook hook (lambda () (flyspell-mode 1))))

  (dolist (hook '(change-log-mode-hook log-edit-mode-hook org-agenda-mode-hook))
    (add-hook hook (lambda () (flyspell-mode -1))))

  :config
  (setq ispell-program-name "/usr/local/bin/aspell"
        ispell-dictionary "british" ; better for aspell
        ispell-extra-args '("--sug-mode=ultra" "--lang=en_GB")
        ispell-list-command "--list")

  (add-to-list 'ispell-local-dictionary-alist '(nil
                                                "[[:alpha:]]"
                                                "[^[:alpha:]]"
                                                "['‘’]"
                                                t
                                                ("-d" "en_US")
                                                nil
                                                utf-8)))

;; (use-package 'indent-guide
;;           :ensure t
;;           :config (indent-guide-global-mode))

(use-package gist
  :ensure t
  :commands gist-list)

(use-package macrostep
  :ensure t
  :bind ("H-`" . macrostep-expand))

(use-package markdown-mode
  :ensure t
  :mode (("\\.markdown\\'" . markdown-mode)
         ("\\.md\\'"       . markdown-mode))
         ("\\.jsx\\'" . js2-jsx-mode))

(use-package multiple-cursors
  :ensure t
  :bind (("C-S-c C-S-c" . mc/edit-lines)
         ("C->"         . mc/mark-next-like-this)
         ("C-<"         . mc/mark-previous-like-this)
         ("C-c C-<"     . mc/mark-all-like-this)
         ("C-!"         . mc/mark-next-symbol-like-this)
         ("s-d"         . mc/mark-all-dwim)))

(use-package olivetti
  :ensure t
  :bind ("s-<f6>" . olivetti-mode))

(use-package projectile
  :ensure t
  :diminish projectile-mode
  :commands projectile-mode
  :config
  (progn
    (projectile-global-mode t)
    (setq projectile-enable-caching t)
    (use-package ag
      :commands ag
      :ensure t
      :init  (setq ag-highlight-search t)
      :config(add-to-list 'ag-arguments "--word-regexp"x))))

(use-package python-mode
  :ensure t)

(use-package racket-mode
  :ensure t
  :commands racket-mode
  :config
  (setq racket-smart-open-bracket-enable t))

(use-package geiser
  :ensure t
  :config
  (setq geiser-default-implementation '(racket)))

(use-package restclient
  :ensure t
  :mode ("\\.restclient\\'" . restclient-mode))

(use-package smartparens
  :ensure t
  :diminish smartparens-mode
  :config
  (add-to-list 'sp--lisp-modes 'racket-mode)
  (add-to-list 'sp--lisp-modes 'geiser-mode)
  (require 'smartparens-config)
  (smartparens-global-mode t))

(sp-local-pair 'org-mode "~" "~" :actions '(wrap))
(sp-local-pair 'org-mode "/" "/" :actions '(wrap))
(sp-local-pair 'org-mode "*" "*" :actions '(wrap))
(add-hook 'js-mode-hook #'smartparens-mode)

(use-package smartscan
  :ensure t
  :config (global-smartscan-mode 1)
  :bind (("s-n" . smartscan-symbol-go-forward)
         ("s-p" . smartscan-symbol-go-backward)))

(use-package smex
  :if (not (featurep 'helm-mode))
  :ensure t
  :bind ("M-x" . smex))
(setq smex-save-file (expand-file-name ".smex-items" user-emacs-directory))

;;;(use-package aggressive-indent
   ;; :ensure t)
;;;(global-aggressive-indent-mode 1)

(use-package skewer-mode
  :commands skewer-mode
  :ensure t
  :config (skewer-setup))

(use-package smooth-scrolling
  :ensure t)
(add-hook 'after-init-hook 'smooth-scrolling-mode)

(use-package typescript-mode
  :ensure t)

(use-package visual-regexp
  :ensure t
  :init
  (use-package visual-regexp-steroids :ensure t)
  :bind (("C-c r" . vr/replace)
         ("C-c q" . vr/query-replace)
         ("C-c m" . vr/mc-mark) ; Need multiple cursors
         ("C-M-r" . vr/isearch-backward)
         ("C-M-s" . vr/isearch-forward)))

(use-package anzu :ensure t)
(add-hook 'after-init-hook 'global-anzu-mode)

(use-package yasnippet
  :ensure t
  :defer 10
  :diminish yas-minor-mode
  :config
  (setq yas-snippet-dirs (concat user-emacs-directory "snippets"))
  (yas-global-mode))

(use-package emmet-mode
  :ensure t
  :commands emmet-mode
  :config
  (add-hook 'html-mode-hook 'emmet-mode)
  (add-hook 'css-mode-hook 'emmet-mode))

(use-package zoom-frm
  :ensure t
  :bind (("C-M-=" . zoom-in/out)
         ("H-z"   . toggle-zoom-frame))
  :config
  (setq frame-zoom-font-difference 10))

(use-package scratch
  :ensure t)

(use-package shell-pop
  :ensure t
  :bind ("M-<f12>" . shell-pop))

(use-package slime
  :ensure t
  :init
  (setq inferior-lisp-program "/usr/local/bin/sbcl")
  (add-to-list 'slime-contribs 'slime-fancy))

(use-package quickrun
  :defer 10
  :ensure t
  :bind ("H-q" . quickrun))

(use-package visible-mode
  :bind ("H-v" . visible-mode))

(use-package virtualenvwrapper
  :ensure t
  :config
  (setq venv-location "~/.virtualenvs"))

(use-package xquery-mode
  :ensure t)

(use-package latex-extra
  :ensure t)

(use-package latex-preview-pane
  :ensure t)

(use-package undo-tree
  :ensure t)

(defun my-c-mode-hook ()
  (setq c-basic-offset 4)
  (c-set-offset 'substatement-open 0)   ; Curly braces alignment
  (c-set-offset 'case-label 4))         ; Switch case statements alignment

(add-hook 'c-mode-hook 'my-c-mode-hook)
(add-hook 'java-mode-hook 'my-c-mode-hook)

(use-package haskell-mode
      :ensure t)
(define-key haskell-mode-map [f8] 'haskell-navigate-imports)

;;enabling hasktags
(let ((my-cabal-path (expand-file-name "~/.cabal/bin")))
  (setenv "PATH" (concat my-cabal-path path-separator (getenv "PATH")))
  (add-to-list 'exec-path my-cabal-path))
(custom-set-variables '(haskell-tags-on-save t))

;; Key bindings from the wiki
(custom-set-variables
  '(haskell-process-suggest-remove-import-lines t)
  '(haskell-process-auto-import-loaded-modules t)
  '(haskell-process-type 'cabal-repl)
  '(haskell-process-log t))
(eval-after-load 'haskell-mode '(progn
  (define-key haskell-mode-map (kbd "C-c C-l") 'haskell-process-load-or-reload)
  (define-key haskell-mode-map (kbd "C-c C-z") 'haskell-interactive-switch)
  (define-key haskell-mode-map (kbd "C-c C-n C-t") 'haskell-process-do-type)
  (define-key haskell-mode-map (kbd "C-c C-n C-i") 'haskell-process-do-info)
  (define-key haskell-mode-map (kbd "C-c C-n C-c") 'haskell-process-cabal-build)
  (define-key haskell-mode-map (kbd "C-c C-n c") 'haskell-process-cabal)))
(eval-after-load 'haskell-cabal '(progn
  (define-key haskell-cabal-mode-map (kbd "C-c C-z") 'haskell-interactive-switch)
  (define-key haskell-cabal-mode-map (kbd "C-c C-k") 'haskell-interactive-mode-clear)
  (define-key haskell-cabal-mode-map (kbd "C-c C-c") 'haskell-process-cabal-build)
  (define-key haskell-cabal-mode-map (kbd "C-c c") 'haskell-process-cabal)))

;; (define-key haskell-mode-map (kbd "SPC") 'haskell-mode-contextual-space)))

(use-package hindent
     :ensure t)
(add-hook 'haskell-mode-hook #'hindent-mode)

(use-package ghc :ensure t)
(autoload 'ghc-init "ghc" nil t)
(autoload 'ghc-debug "ghc" nil t)
(add-hook 'haskell-mode-hook (lambda () (ghc-init)))

(use-package ediprolog :ensure t)
(global-set-key [f10] 'ediprolog-dwim)

(use-package jasmin)

(use-package rust-mode
  :ensure t)

(use-package angular-mode :ensure t)

(setq display-time-default-load-average nil)

(setq battery-mode-line-format "[%b%p%% %t]")

(use-package doc-view
  :commands doc-view-mode
  :config
  (define-key doc-view-mode-map (kbd "<right>") 'doc-view-next-page)
  (define-key doc-view-mode-map (kbd "<left>") 'doc-view-previous-page))

(setq mouse-wheel-scroll-amount (quote (0.01)))

(use-package server
  :config
  (server-start))

(use-package visible-mode
  :bind ("H-v" . visible-mode))

(use-package cl-lib :ensure t)

(global-set-key (kbd "M-3") '(lambda () (interactive) (insert "#")))
