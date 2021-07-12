;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Hank Lee"
      user-mail-address "hank.lee.qed@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;;
;; Example from Doom Emacs Repo - https://github.com/hlissner/doom-emacs/blob/develop/docs/faq.org#how-do-i-change-the-fonts
;; "monospace" - default
;; (setq doom-font (font-spec :family "Monospace" :size 14))
;; (setq doom-font (font-spec :family "Fira Code" :size 12))
(setq doom-font (font-spec :family "Fira Mono for Powerline" :size 12))
;; When zooming in/out do not step too much (orig 2)
(setq doom-font-increment 1)

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-city-lights)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Basic config
;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq which-key-idle-delay 0.4)

;; Disables Vim behavior where ESC from Normal mode moves cursor 1 space back
(setq evil-move-cursor-back nil)

;; Frame setting
(add-to-list 'initial-frame-alist
             '(fullscreen . maximized))

;; Vim Jumplist Keymap
(define-key evil-normal-state-map (kbd "C-p") 'evil-jump-forward)

;; Set special keys (both left / right option should be interpreted as meta)
(setq ns-right-alternate-modifier 'left) ;; should be left otherwise left option fails to send Meta

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Tabs/indentation configuration - http://ergoemacs.org/emacs/emacs_tabs_space_indentation_setup.html
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Disable electric mode globally (https://www.reddit.com/r/emacs/comments/2mu7yi/disable_electric_indent_mode/)
;; (add-hook 'after-change-major-mode-hook (lambda () (electric-indent-mode -1)))
(defun remove-electric-indent-mode ()
  (electric-indent-local-mode -1))
(add-hook 'json-mode-hook 'remove-electric-indent-mode)
(setq-default tab-always-indent 'complete)

;; Zen mode config
(setq +zen-text-scale 1)

;;;;;;;;;;;;;;;;;;;;;;
;; Window resizing (Zoom - with Golden Ratio) - https://github.com/cyrus-and/zoom
;;;;;;;;;;;;;;;;;;;;;;
(custom-set-variables
 '(zoom-mode t))

(custom-set-variables
 '(zoom-size '(0.618 . 0.618)))

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; LSP config
;;;;;;;;;;;;;;;;;;;;;;;;;;

(after! lsp-ui
  (setq lsp-ui-peek-enable t)
  (define-key lsp-ui-mode-map [remap xref-find-definitions] #'lsp-ui-peek-find-definitions)
  (define-key lsp-ui-mode-map [remap xref-find-references] #'lsp-ui-peek-find-references))

;; Disable formatting automatically on type
;; (use-package-hook! lsp-mode
;;   :post-config
;;   (setq lsp-enable-on-type-formatting nil))

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Text region configs (expand region)
;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-key evil-normal-state-map (kbd "+" ) 'er/expand-region)

;; set left margin to show git-gutter (if no buffer margin then gutter not shown)
(setq-default left-margin-width 1)
(set-window-buffer nil (current-buffer))

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Treemacs config
;;;;;;;;;;;;;;;;;;;;;;;;;;

;; add keymap to return to treemacs panel -> https://github.com/hlissner/doom-emacs/issues/1177

;; ??? (define-key global-state-map (kbd "+" ) 'er/expand-region)

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Orgmode config
;;;;;;;;;;;;;;;;;;;;;;;;;;


;; Limit image size (to avoid large images taking over screen)
;; tips on editing config for org -> https://github.com/hlissner/doom-emacs/issues/407
(after! org
  (setq org-directory "~/org/"
        org-want-todo-bindings t
        org-enforce-todo-dependencies t
        org-todo-keywords
        '(
          (sequence "TODO(t)" "NEXT(n)" "IN-PROGRESS(i!)" "WAITING(w@)" "|" "DONE(d)" "CANCELLED(c@)")
        )
        org-default-notes-file (concat org-directory "journal.org")
        org-archive-location (concat org-directory "archive.org::* Archive from %s")
        org-agenda-files (list org-directory)
        org-log-done 'time
        org-log-into-drawer t
        org-image-actual-width 300 ;; limit image size (avoid large images taking over screen) - https://emacs.stackexchange.com/questions/26363/downscaling-inline-images-in-org-mode

        ;; org-roam
        org-roam-directory "~/org/"
        )
  ;; Org-download (images)
  (setq org-startup-with-inline-images t)
  (setq org-capture-templates
        '(
          ;; scheduled events (appointments + anything with time)
          ("s" "scheduled items" entry
            (file+datetree org-default-notes-file)
            "* TODO %^{Title}%?\nSCHEDULED: %^T"
            )

          ;; Notes
          ("n" "notes" entry
            (file+datetree+prompt org-default-notes-file)
            "* %^{Title} %U\n%?"
            )

          ;; todo items (into inbox)
          ;; from : https://sachachua.com/blog/2015/02/org-mode-reusing-date-file-datetree-prompt/
          ("t" "todos" entry
            (file+datetree+prompt org-default-notes-file)
            "* TODO %^{Title}%?\nSCHEDULED: <%(org-read-date nil nil org-read-date-final-answer)>"
            )

          ;; Queue (someday items, etc)
          ("q" "queue items" entry
            (file+headline "~/org/queue.org" "Links")
            "* %A %? %U"
            )

          ;; Active list (buy, projects, etc)
          ("a" "Active list")
          ("ab" "Buy list" entry
            (file+headline "~/org/journal.org" "Buy")
            "* %^{Title}%?\n:BUY:"
            )

          ;; habit
          ("h" "Habit" entry
            (file+headline "~/org/journal.org" "Habits")
            "* NEXT %^{Title}%?\n%U\n:PROPERTIES:\nSCHEDULED: %(format-time-string \"%<<%Y-%m-%d %a .+1d>>\")\n:STYLE: habit\n:END:\n"
            )
          ))
  (setq org-hide-emphasis-markers t) ; hide bold+italics marker chars (just do the operation)
  ;; Setup Org mode bullet point prettify
  (add-hook 'org-mode-hook (lambda () (org-superstar-mode 1)))
  )
;; smooth scrolling for images (org mode)
(pixel-scroll-mode)
;; (setq pixel-dead-time 0) ; Never go back to the old scrolling behaviour.
(setq pixel-resolution-fine-flag t) ; Scroll by number of pixels instead of lines (t = frame-char-height pixels).
;; (setq mouse-wheel-scroll-amount '(1)) ; Distance in pixel-resolution to scroll each mouse wheel event.

;;;;;;;;;;;;;;;;;;;;;;
;; Org download (images)
;;;;;;;;;;;;;;;;;;;;;;
(use-package! org-download
  :ensure t
  :defer t
  :init
  ;; Add handlers for drag-and-drop when Org is loaded.
  (with-eval-after-load 'org
    (org-download-enable)))

(global-evil-matchit-mode 1)

;;;;;;;;;;;;;;;;;;;;;;
;; Org refile config
;;;;;;;;;;;;;;;;;;;;;;
;; Targets include this file and any file contributing to the agenda - up to 9 levels deep
(setq org-refile-targets (quote ((nil :maxlevel . 6)
                                  (org-agenda-files :maxlevel . 6))))

;;;;;;;;;;;;;;;;;;;;;;
;; Org-archive config
;;;;;;;;;;;;;;;;;;;;;;
;; (setq org-archive-hook org-save-all-org-buffers)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages (quote (lsp-ui slime))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )



;;;;;;;;;;;;;;;;;;;;;;
;; Sly (IDE features for Common Lisp)
;;;;;;;;;;;;;;;;;;;;;;
;; (setq inferior-lisp-program "sbcl")
;; (after! sly
;;   (setq sly-command-switch-to-existing-lisp 1))
