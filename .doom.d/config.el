;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Bert Deferme"
      user-mail-address "REDACTED")

(setq treemacs-width 32
      company-idle-delay nil)

;; Switch to the new window after splitting
(setq evil-split-window-below t
      evil-vsplit-window-right t)

(setq projectile-project-search-path '("~/code/" "~/org/" "~/.local/src"))

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
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))
(setq doom-font (font-spec :family "Fira Code" :size 14)
      doom-variable-pitch-font (font-spec :family "Fira Code") ; inherits `doom-font''s :size
      doom-unicode-font (font-spec :family "Fira Code" :size 14)
      doom-big-font (font-spec :family "Fira Code" :size 34))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-zenburn) ;; I switch this very often

;;(setq doom-one-brighter-comments t
;;            doom-one-comment-bg nil)
(custom-set-faces!
  '(aw-leading-char-face
    :weight bold :foreground "red" :height 1.5))

;; Deft for searching quickly
(setq deft-directory "~/org/")
(setq deft-recursive t)

;;;; If you use `org' and don't want your org files in the default location below,
;;;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/agenda/")
(setq org-archive-location (concat org-directory ".archive/%s::"))
(setq org-roam-directory "~/org/roam")
(setq org-roam-buffer-width 0.15)

;;;; Some org settings
(after! org
  (setq org-log-done t)
  (setq org-log-into-drawer t)
  (setq org-deadline-warning-days 3)
  (setq org-habit-completed-glyph ?X)
  (setq org-habit-today-glyph ?-)
  (setq org-startup-folded t)
  (setq org-habit-show-all-today t)
  (setq org-habit-following-days 1)
  (setq org-clock-in-switch-to-state "STRT")
  (setq org-todo-repeat-to-state "LOOP")
  (setq org-agenda-todo-ignore-scheduled 'future)
  (setq org-agenda-tags-todo-honor-ignore-options t)
  (setq org-agenda-skip-deadline-prewarning-if-scheduled t)
  (setq org-clock-idle-time 15)
  (setq org-duration-format (quote h:mm))
  (setq org-tags-exclude-from-inheritance '("monthA" "weekA")) ;; No inheritance for these tags
  (setq org-global-properties
      '(("Effort_ALL" .
         "0:15 0:45 1:30 2:15 3:00 3:45 4:30 5:15 6:00 0:00")))
  (setq org-columns-default-format "%50ITEM(Task) %2PRIORITY %10Effort(Effort){:} %10CLOCKSUM %16TIMESTAMP_IA"))

(after! org-clock
  (setq org-clock-persist t)
  (org-clock-persistence-insinuate))

(after! org
(setq org-todo-keywords '((sequence "IDEA(i)" "TODO(t)" "NEXT(n!)" "STRT(s!)" "PROJ(p@)" "GOAL(g)" "WAIT(w@/!)" "HOLD(h@)" "LOOP(r)" "|" "DONE(d!)" "KILL(k@)"))))

(after! org
  (add-to-list 'org-modules 'org-habit)
  (setq org-id-link-to-org-use-id 'create-if-interactive))

(map! :leader :desc "Habits" :n "t h" #'org-habit-toggle-habits)

(after! org
  (setq org-capture-templates
        `(("c" "CLIENT")
          ("cm" "CLIENT Meeting" entry
           (file+headline "~/org/agenda/client.org" "Meetings")
           "* STRT %? :meeting:\n%i\n"
           :jump-to-captured t :clock-in t :clock-keep t)
          ("t" "TODO" entry
           (file "~/org/agenda/inbox.org")
           "* TODO %?\n:PROPERTIES:\n:CREATED: %U\n:END:\n%i\n"
           :kill-buffer t)
          ("i" "IDEA" entry
           (file "~/org/agenda/inbox.org")
           "* TODO %?\n:PROPERTIES:\n:CREATED: %U\n:END:\n%i\n"
           :kill-buffer t)
        )))

(defun org-agenda-process-inbox-item()
  "Process a single item in the org-agenda."
  (interactive)
  (org-with-wide-buffer
   (org-agenda-set-tags)
   (org-agenda-priority)
   (call-interactively 'org-agenda-set-effort)
   (org-agenda-refile nil nil t)))

(setq org-stuck-projects '("-routine/PROJ|AREA" ("STRT" "NEXT")))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
;;(setq display-line-numbers-type nil)

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;;(after! org
;;(set-popup-rule! "^\\*Org Agenda" :side 'bottom :size 0.75 :select t :ttl nil))
;;(after! org
;;(set-popup-rule! "^\\*Org QL View" :side 'bottom :size 0.55 :select t :ttl nil))

(use-package! org-super-agenda
  :after org-agenda
  :init
  (setq org-agenda-skip-scheduled-if-done t
      org-agenda-skip-deadline-if-done t
      org-agenda-include-deadlines t
      org-agenda-block-separator nil
      org-agenda-compact-blocks t
      org-agenda-start-day nil ;; i.e. today
      org-agenda-span 1
      org-clocktable-defaults '(:maxlevel 3 :lang "en" :scope file :block nil :wstart 1 :mstart 1 :tstart nil :tend nil :step nil :stepskip0 nil :fileskip0 t :tags nil :match nil :emphasize nil :link nil :narrow 40! :indent t :hidefiles nil :formula nil :timestamp nil :level nil :tcolumns nil :formatter nil)
      org-super-agenda-header-map nil
      org-agenda-start-on-weekday nil)
  (setq org-agenda-custom-commands
        '(("A" "ALL"
           ((agenda "" ((org-agenda-overriding-header "")
                        (org-super-agenda-groups
                         '((:log t)
                           (:discard (:category ("someday")))
                           (:name "Today"
                                  :time-grid t
                                  :habit t
                                  :date today
                                  :scheduled today
                                  :order 1)))))))
          ("o" "Overview"
           ((agenda "" ((org-agenda-overriding-header "")
                        (org-super-agenda-groups
                         '((:log t)
                           (:discard (:category ("someday")))
                           (:name "Today"
                                  :time-grid t
                                  :habit t
                                  :date today
                                  :scheduled today
                                  :order 1)))))
            (alltodo "" ((org-agenda-overriding-header "")
                         (org-super-agenda-groups
                          '((:log t)
                            (:discard (:tag ("someday" "habit" "routine") :todo ("PROJ" "GOAL")))
                            (:name "MIT"
                                   :tag ("mit" "wit")
                                   :order 0)
                            (:name "Monthly"
                                   :tag ("monthA")
                                   :order 1)
                            (:name "Reading"
                                   :and (
                                   :todo ("NEXT" "STRT")
                                   :tag ("reading"))
                                   :order 1)
                            (:name "Weekly"
                                   :tag ("weekA" "weekB" "weekly")
                                   :order 1)
                            (:name "Started"
                                   :todo ("STRT")
                                   :order 2)
                            (:name "Next to do"
                                   :todo ("NEXT")
                                   :order 8)
                            (:name "Important"
                                   :priority "A"
                                   :order 3)
                            (:name "Due Today"
                                   :deadline today
                                   :order 4)
                            (:name "Scheduled Soon"
                                   :scheduled future
                                   :order 8)
                            (:name "Due Soon"
                                   :deadline future
                                   :order 7)
                            (:name "Overdue"
                                   :deadline past
                                   :order 6)
                            (:name "Waiting"
                                   :todo ("WAIT" "HOLD")
                                   :order 20)
                            (:discard (:anything))))))))
           ("p" "Personal Overview"
           ((agenda "" ((org-agenda-overriding-header "")
                        (org-super-agenda-groups
                         '((:discard (:tag ("work") :category ("someday" "client")))
                           (:log t)
                           (:name "Today"
                                  :time-grid t
                                  :habit t
                                  :date today
                                  :scheduled today
                                  :order 1)))))
            (alltodo "" ((org-agenda-overriding-header "")
                         (org-super-agenda-groups
                          '((:log t)
                            (:discard (:tag ("work" "habit" "routine") :category ("g_personal" "someday") :todo ("PROJ" "GOAL")))
                            (:name "MIT"
                                   :tag ("mit" "wit")
                                   :order 1)
                            (:name "Monthly"
                                   :tag ("monthA")
                                   :order 1)
                            (:name "Reading"
                                   :and (
                                   :todo ("NEXT" "STRT")
                                   :tag ("reading"))
                                   :order 1)
                            (:name "Weekly"
                                   :tag ("weekA" "weekB" "weekly")
                                   :order 2)
                            (:name "Started"
                                   :todo ("STRT")
                                   :order 3)
                            (:name "Next to do"
                                   :todo ("NEXT")
                                   :order 11)
                            (:name "Important"
                                   :priority "A"
                                   :order 3)
                            (:name "Due Today"
                                   :deadline today
                                   :order 5)
                            (:name "Scheduled Soon"
                                   :scheduled future
                                   :order 9)
                            (:name "Due Soon"
                                   :deadline future
                                   :order 8)
                            (:name "Overdue"
                                   :deadline past
                                   :order 6)
                            (:name "Waiting"
                                   :todo ("WAIT" "HOLD")
                                   :order 20)
                            (:discard (:anything))))))))
           ("w" "Work Overview"
           ((agenda "" ((org-agenda-overriding-header "")
                        (org-super-agenda-groups
                         '((:discard (:tag ("personal" "habit" "goals") :category ("someday" "g_personal" "g_shared")))
                           (:log t)
                           (:name "Today"
                                  :time-grid t
                                  :date today
                                  :habit t
                                  :scheduled today
                                  :order 1)))))
            (alltodo "" ((org-agenda-overriding-header "")
                         (org-super-agenda-groups
                          '((:discard (:tag ("personal" "habit" "routine" "goals" "someday") :todo ("PROJ" "GOAL")))
                            (:name "MIT"
                                   :tag ("mit" "wit")
                                   :order 0)
                            (:name "Monthly"
                                   :tag ("monthA")
                                   :order 1)
                            (:name "Reading"
                                   :and (
                                   :todo ("NEXT" "STRT")
                                   :tag ("reading"))
                                   :order 1)
                            (:name "Weekly"
                                   :tag ("weekA" "weekB" "weekly")
                                   :order 1)
                            (:name "Started"
                                   :todo ("STRT")
                                   :order 2)
                            (:name "Next to do"
                                   :todo ("NEXT")
                                   :order 9)
                            (:name "Important"
                                   :priority "A"
                                   :order 3)
                            (:name "Due Today"
                                   :deadline today
                                   :order 4)
                            (:name "Scheduled Soon"
                                   :scheduled future
                                   :order 8)
                            (:name "Due Soon"
                                   :deadline future
                                   :order 7)
                            (:name "Overdue"
                                   :deadline past
                                   :order 6)
                            (:name "Waiting"
                                   :todo ("WAIT" "HOLD")
                                   :order 20)
                            (:discard (:anything))))))))
           ("n" "Narrow mode"
           ((agenda "" ((org-agenda-overriding-header "")
                        (org-super-agenda-groups
                         '((:log t)
                           (:discard (:category ("someday")))
                           (:name "Today"
                                  :time-grid t
                                  :date today
                                  :scheduled today
                                  :order 1)))))
            (alltodo "" ((org-agenda-overriding-header "")
                         (org-super-agenda-groups
                          '((:discard (:tag ("habit" "routine" "someday") :todo ("PROJ" "GOAL")))
                            (:name "MIT"
                                   :tag ("mit" "wit")
                                   :order 0)
                            (:discard (:anything))))))))
           ))
  :config
  (org-super-agenda-mode))

(use-package! org-gcal
:after org
:config
(setq org-gcal-client-id "REDACTED"
org-gcal-client-secret "REDACTED"
org-gcal-local-timezone "Europe/Brussels"
org-gcal-file-alist '(
                      ("REDACTED" .  "~/org/agenda/g_personal.org")
                      ("REDACTED@group.calendar.google.com" .  "~/org/agenda/g_shared.org")
                      )))
(map! :leader
      :desc "Update roam buffer"
      "n j t" #'org-journal-open-current-journal-file)

(map! :leader
      :desc "Update roam buffer"
      "n r u" #'org-roam-buffer-update)

(map! :leader
      :desc "Open org-ql-search"
      "n q s" #'org-ql-search)

(map! :leader
      :desc "Open org-ql-view"
      "n q v" #'org-ql-view)

(map! :leader
      :desc "Sync gcal"
      "o a f" #'org-gcal-fetch)

(map! :leader
      :desc "Download screenshot"
      "i d s" #'org-download-screenshot)

(map! :leader
      :desc "Download URL from clipboard"
      "i d p" #'org-download-yank)

(map! :after evil-org-agenda
      :map evil-org-agenda-mode-map
      :m "sf" #'org-agenda-filter)

(map! :after evil-org-agenda
      :map evil-org-agenda-mode-map
      :m "P" 'org-agenda-process-inbox-item)

;; For python
(add-hook! 'python-mode-hook (modify-syntax-entry ?_ "w"))
;; For ruby
(add-hook! 'ruby-mode-hook (modify-syntax-entry ?_ "w"))
;; For Javascript
(add-hook! 'js2-mode-hook (modify-syntax-entry ?_ "w"))

(setq org-superstar-headline-bullets-list '("⁖" "●" "◉" "○" "✸"))
;;
(after! org
  (require 'org-roam-protocol))
;;
(after! org
  (setq org-priority-highest ?A)
  (setq org-priority-lowest ?G)
  (setq org-priority-default ?F))
;;
(after! org-fancy-priorities
  (setq org-fancy-priorities-list '((?A . "MIT ") ;; Most important thing
   (?B . "WIT ") ;; Work most important thing
    (?C . "URG ")
    (?D . "HIGH")
    (?E . "MED ")
    (?F . "NORM")
    (?G . "LOW ")))
   (setq org-priority-faces '((?A :foreground "red" :weight bold)
     (?B :foreground "red" :weight bold)
     (?C :foreground "red" :weight bold)
     (?D :foreground "orange" :weight bold)
     (?E :foreground "orange" :weight bold)
     (?F :foreground "green" :weight bold)
     (?G :foreground "blue" :weight bold))))

(map! :i "C-." #'completion-at-point)

(use-package! websocket
    :after org-roam)

(use-package! org-roam-ui
    :after org-roam ;; or :after org
;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
;;         a hookable mode anymore, you're advised to pick something yourself
;;         if you don't care about startup time, use
;;  :hook (after-init . org-roam-ui-mode)
    :config
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          org-roam-ui-open-on-start t))

(use-package! org-pomodoro
  :after org
  :config
  (setq org-pomodoro-play-sounds nil
        org-pomodoro-clock-break nil
        org-pomodoro-manual-break t))

(use-package! org-download
  :after org
  :config
  (setq org-download-method 'attach
        org-download-screenshot-method "maim -s %s"))

;; @see https://bitbucket.org/lyro/evil/issue/511/let-certain-minor-modes-key-bindings
(with-eval-after-load 'git-timemachine
  (evil-make-overriding-map git-timemachine-mode-map 'normal)
  ;; force update evil keymaps after git-timemachine-mode loaded
  (add-hook 'git-timemachine-mode-hook #'evil-normalize-keymaps))

(setq org-list-demote-modify-bullet
      '(("+" . "-") ("-" . "+") ("*" . "+") ("1." . "a.")))

(defun my-inhibit-emojify-mode ()
  "Counter-act a globalized hl-highlight-mode."
  (add-hook 'after-change-major-mode-hook
            (lambda () (emojify-mode 0))
            :append :local))

(add-hook 'org-agenda-mode-hook 'my-inhibit-emojify-mode)

(setq org-agenda-clockreport-parameter-plist '(:link t :maxlevel 3 :narrow 80))

(keyfreq-mode 1)
(keyfreq-autosave-mode 1)

;;;; Show a clock in the modeline
(setq display-time-24hr-format '1)
(setq display-time-day-and-date '1)
(setq display-time-format "|%Y-%m-%d %a %H:%M|")
(display-time-mode 1)

;;;; Golden ratio mode
(use-package zoom
  :hook (doom-first-input . zoom-mode)
  :config
  (setq zoom-size '(0.618 . 0.618)
        zoom-ignored-major-modes '(dired-mode vterm-mode help-mode helpful-mode rxt-help-mode help-mode-menu org-mode)
        zoom-ignored-buffer-names '("*doom:scratch*" "*info*" "*helpful variable: argv*")
        zoom-ignored-buffer-name-regexps '("^\\*calc" "\\*helpful variable: .*\\*" "^\\*Minibuf")))

(map! :after zoom
      :leader
      :desc "Toggle Zoom mode"
      "w z" #'zoom-mode)
