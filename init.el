;; File used for storing customization information.
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; Bootstrap `use-package`
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package)
  (setq use-package-verbose t))

(require 'bind-key)

;;(use-package benchmark-init
;;  :ensure t
;;  :config
;;  (add-hook 'after-init-hook 'benchmark-init/deactivate))

;;; User Interface

;; Hide the menu bar on all frames.
(when (and (not (eq system-type 'darwin)) (fboundp 'menu-bar-mode))
  (menu-bar-mode -1))

;; Hide the tool bar on all frames.
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))

;; Hide vertical scrool bars on all frames.
(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1))

;; Disable cursor blinking.
(when (fboundp 'blink-cursor-mode)
  (blink-cursor-mode -1))

;; Do not ring the bell.
(setq ring-bell-function #'ignore)

;; Inhibit the startup screen.
(setq inhibit-startup-screen t)

;; Clear initial scratch message.
(setq initial-scratch-message nil)

;; Prefer short Yes/No questions.
(fset 'yes-or-no-p #'y-or-n-p)

;; Set the default font.
(if (eq system-type 'windows-nt) (set-frame-font "Consolas-12"))

;; Enable column-number mode to display current column number in the
;; mode line.
(setq column-number-mode t)

;; Disable backup files.
(setq make-backup-files nil)

;; Highlight current line.
(global-hl-line-mode)

;; Use space to indent by default.
(setq-default indent-tabs-mode nil)

;; Modify the title bar.
(setq frame-title-format '("%b @ Emacs " emacs-version))

;; Enable automatic parens pairing (Electric Pair mode).
(electric-pair-mode t)

;; Enable Show Paren mode.
(show-paren-mode 1)

;; Open file or url at point.
(global-set-key (kbd "C-x @ f") 'find-file-at-point)

;; Prevent shell commands from being echoed.
(defun my-comint-init ()
  (setq comint-process-echoes t))
(add-hook 'comint-mode-hook 'my-comint-init)

(setq whitespace-style '(face empty tabs lines-tail trailing))

;; C/C++ Style
;; C-c C-o
(c-add-style
 "my-c-style"
 '((c-basic-offset . 4)
   (c-offsets-alist
    (arglist-cont-nonempty . +)
    (substatement-open . 0)
    (topmost-intro-cont . 0)
    (inline-open . 0)
    (innamespace . [0]))))
(defun my-c-mode-hook ()
  (c-set-style "my-c-style")
  (whitespace-mode t)
  (display-line-numbers-mode))
(add-hook 'c-mode-hook 'my-c-mode-hook)
(add-hook 'c++-mode-hook 'my-c-mode-hook)

;; tomorrow-theme
(use-package color-theme-sanityinc-tomorrow
  :ensure t
  :config
  (load-theme 'sanityinc-tomorrow-night t))

;; magit --- A Git porcelain inside Emacs
;;
;; Commands:
;; C-x g      magit-status
;;
;; https://magit.vc
;; https://github.com/magit/magit
(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status))

;; projectile --- Project Interaction Library for Emacs
;;
;; Commands:
;; C-c p f    projectile-find-file
;;
;; https://www.projectile.mx
;; https://github.com/bbatsov/projectile
(use-package projectile
  :ensure t
  :functions projectile-mode
  :config
  (add-to-list 'projectile-globally-ignored-directories "build" t)
  (projectile-mode 1)
  :bind-keymap ("C-c p" . projectile-command-map))

;; cmake-mode --- major-mode for editing CMake sources
(use-package cmake-mode
  :ensure t
  :mode (("CMakeLists\\.txt\\'" . cmake-mode)
         ("\\.cmake\\'" . cmake-mode)))

;; helm
(use-package helm
  :ensure t
  :config
  (require 'helm-config)
  (setq helm-ff-file-name-history-use-recentf t)
  (setq helm-echo-input-in-header-line t)
  (setq helm-buffers-fuzzy-matching t)
  (setq helm-recentf-fuzzy-match t)
  (setq helm-split-window-inside-p t)
  (helm-autoresize-mode 1)
  (helm-mode 1)
  :bind (("M-x" . helm-M-x)
         ("C-x C-f" . helm-find-files)
         ("C-x b" . helm-mini)))
(use-package helm-projectile
  :ensure t
  :config
  (setq projectile-completion-system 'helm)
  (helm-projectile-on))

;; clang-format
(use-package clang-format
  :ensure t
  :bind (("C-c i" . clang-format-region)
         ("C-c u" . clang-format-buffer)))
