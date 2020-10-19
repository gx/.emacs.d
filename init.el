;; File used for storing customization information.
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

;; Fix a bug in Emacs 26.2
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

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

;; Disable cursor blinking (for graphical frames).
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

;; Set the size of a frame in pixels.
(setq frame-resize-pixelwise t)

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

(use-package treemacs
  :ensure t
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (progn
    (setq treemacs-collapse-dirs                 (if treemacs-python-executable 3 0)
          treemacs-deferred-git-apply-delay      0.5
          treemacs-directory-name-transformer    #'identity
          treemacs-display-in-side-window        t
          treemacs-eldoc-display                 t
          treemacs-file-event-delay              5000
          treemacs-file-extension-regex          treemacs-last-period-regex-value
          treemacs-file-follow-delay             0.2
          treemacs-file-name-transformer         #'identity
          treemacs-follow-after-init             t
          treemacs-git-command-pipe              ""
          treemacs-goto-tag-strategy             'refetch-index
          treemacs-indentation                   2
          treemacs-indentation-string            " "
          treemacs-is-never-other-window         nil
          treemacs-max-git-entries               5000
          treemacs-missing-project-action        'ask
          treemacs-move-forward-on-expand        nil
          treemacs-no-png-images                 nil
          treemacs-no-delete-other-windows       t
          treemacs-project-follow-cleanup        nil
          treemacs-persist-file                  (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
          treemacs-position                      'left
          treemacs-recenter-distance             0.1
          treemacs-recenter-after-file-follow    nil
          treemacs-recenter-after-tag-follow     nil
          treemacs-recenter-after-project-jump   'always
          treemacs-recenter-after-project-expand 'on-distance
          treemacs-show-cursor                   nil
          treemacs-show-hidden-files             t
          treemacs-silent-filewatch              nil
          treemacs-silent-refresh                nil
          treemacs-sorting                       'alphabetic-asc
          treemacs-space-between-root-nodes      t
          treemacs-tag-follow-cleanup            t
          treemacs-tag-follow-delay              1.5
          treemacs-user-mode-line-format         nil
          treemacs-user-header-line-format       nil
          treemacs-width                         35
          treemacs-workspace-switch-cleanup      nil)

    ;; The default width and height of the icons is 22 pixels. If you are
    ;; using a Hi-DPI display, uncomment this to double the icon size.
    ;;(treemacs-resize-icons 44)

    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode t)
    (pcase (cons (not (null (executable-find "git")))
                 (not (null treemacs-python-executable)))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple))))
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag)))

(use-package treemacs-evil
  :after treemacs evil
  :ensure t)

(use-package treemacs-projectile
  :after treemacs projectile
  :ensure t)

(use-package treemacs-icons-dired
  :after treemacs dired
  :ensure t
  :config (treemacs-icons-dired-mode))

(use-package treemacs-magit
  :after treemacs magit
  :ensure t)

(use-package treemacs-persp ;;treemacs-persective if you use perspective.el vs. persp-mode
  :after treemacs persp-mode ;;or perspective vs. persp-mode
  :ensure t
  :config (treemacs-set-scope-type 'Perspectives))

(use-package company
  :ensure t
  :defer t
  :init
  (global-company-mode)
  :config
  (progn
    ;; Use Company for completion
    (bind-key [remap completion-at-point] #'company-complete company-mode-map)
    (setq company-tooltip-align-annotations t
          ;; Easy navigation to candidates with M-<n>
          company-show-numbers t)
    (setq company-dabbrev-downcase nil))
  :diminish company-mode)
;; Documentation popups for Company
(use-package company-quickhelp
  :ensure t
  :defer t
  :init (add-hook 'global-company-mode-hook #'company-quickhelp-mode))

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

;; lsp-mode
(use-package which-key
  :ensure t
  :config (which-key-mode))
(use-package dap-mode
  :ensure t)
(use-package lsp-mode
  :ensure t
  :hook ((c-mode . lsp)
         (c++-mode . lsp)
         (python-mode . lsp)
         (lsp-mode . (lambda()
                       (let ((lsp-keymap-prefix "C-c l"))
                         (lsp-enable-which-key-integration)))))
  :init
  (setq gc-cons-threshold 100000000
        read-process-output-max (* 1024 1024)
        lsp-idle-delay 0.5
        lsp-prefer-capf t)
  :config
  (define-key lsp-mode-map (kbd "C-c l") lsp-command-map)
  :commands lsp)
(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode)
(use-package helm-lsp
  :ensure t
  :commands helm-lsp-workspace-symbol)
(use-package lsp-treemacs
  :ensure t
  :commands lsp-treemacs-errors-list)
(use-package helm-xref
  :ensure t)
