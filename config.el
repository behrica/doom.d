;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Carsten Behring"
      user-mail-address "carsten.behring@gmail.com")

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
(setq doom-font (font-spec :family "Hack" :size 20))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


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
(after! cider
  (add-hook 'company-completion-started-hook 'custom/set-company-maps)
  (add-hook 'company-completion-finished-hook 'custom/unset-company-maps)
  (add-hook 'company-completion-cancelled-hook 'custom/unset-company-maps)
  (define-key clojure-mode-map (kbd "C-c c c") 'clerk-show)
  (define-key clojure-mode-map (kbd "C-c c b") 'clerk-show-buffer)
  (define-key clojure-mode-map (kbd "C-c c t s") 'clerk-tap-sexp-at-point-with-viewer))

(defun custom/unset-company-maps (&rest unused)
  "Set default mappings (outside of company).
    Arguments (UNUSED) are ignored."
  (general-def
    :states 'insert
    :keymaps 'override
    "<down>" nil
    "<up>"   nil
    "RET"    nil
    [return] nil
    "C-n"    nil
    "C-p"    nil
    "C-j"    nil
    "C-k"    nil
    "C-h"    nil
    "C-u"    nil
    "C-d"    nil
    "C-s"    nil
    "C-S-s"   (cond ((featurep! :completion helm) nil)
                    ((featurep! :completion ivy)  nil))
    "C-SPC"   nil
    "TAB"     nil
    [tab]     nil
    [backtab] nil))

(defun custom/set-company-maps (&rest unused)
  "Set maps for when you're inside company completion.
    Arguments (UNUSED) are ignored."
  (general-def
    :states 'insert
    :keymaps 'override
    "<down>" #'company-select-next
    "<up>" #'company-select-previous
    "RET" #'company-complete
    [return] #'company-complete
    "C-w"     nil  ; don't interfere with `evil-delete-backward-word'
    "C-n"     #'company-select-next
    "C-p"     #'company-select-previous
    "C-j"     #'company-select-next
    "C-k"     #'company-select-previous
    "C-h"     #'company-show-doc-buffer
    "C-u"     #'company-previous-page
    "C-d"     #'company-next-page
    "C-s"     #'company-filter-candidates
    "C-S-s"   (cond ((featurep! :completion helm) #'helm-company)
                    ((featurep! :completion ivy)  #'counsel-company))
    "C-SPC"   #'company-complete-common
    "TAB"     #'company-complete-common-or-cycle
    [tab]     #'company-complete-common-or-cycle
    [backtab] #'company-select-previous))

(defun notify-send (msg)
  (interactive)
  (shell-command (concat "notify-send '" msg "'")))

(defun notify-line ()
  (interactive)
  (notify-send (concat "line: " (number-to-string (line-number-at-pos)))))

(defun cider-interactive-notify-and-eval (code)
  (interactive)
  (notify-send code)
  (cider-interactive-eval
   code
   (cider-interactive-eval-handler nil (point))
   nil
   nil))

(defun notespace/eval-and-realize-note-at-this-line ()
  (interactive)
  (save-buffer)
  (cider-interactive-notify-and-eval
   (concat "(notespace.api/eval-and-realize-note-at-line "
           (number-to-string (line-number-at-pos))
           ")")))

(defun notespace/eval-and-realize-notes-from-line ()
  (interactive)
  (save-buffer)
  (cider-interactive-notify-and-eval
   (concat "(notespace.api/eval-and-realize-notes-from-line "
           (number-to-string (line-number-at-pos))
           ")")))

(defun notespace/init-with-browser ()
  (interactive)
  (save-buffer)
  (cider-interactive-notify-and-eval
   (concat "(notespace.api/init-with-browser)")))

(defun notespace/init ()
  (interactive)
  (save-buffer)
  (cider-interactive-notify-and-eval
   (concat "(notespace.api/init)")))

(defun notespace/eval-this-notespace ()
  (interactive)
  (save-buffer)
  (cider-interactive-notify-and-eval
   "(notespace.api/eval-this-notespace)"))

(defun notespace/eval-and-realize-this-notespace ()
  (interactive)
  (save-buffer)
  (cider-interactive-notify-and-eval
   "(notespace.api/eval-and-realize-this-notespace)"))

(defun notespace/render-static-html ()
  (interactive)
  (cider-interactive-notify-and-eval
   "(notespace.api/render-static-html)"))

(defun buffer-whole-string (buffer)
  (with-current-buffer buffer
    (remove-overlays nil nil 'cider-temporary t)
    (cider--clear-compilation-highlights)
    (cider--quit-error-window)
    (save-restriction
      (widen)
      (buffer-substring-no-properties (point-min) (point-max)))))

(defun clerk-show-buffer-2 ()
  (interactive)
  (save-buffer)
  (message "%s" (prin1-to-string (buffer-whole-string (current-buffer))))
  (cider-interactive-eval
   (concat "(nextjournal.clerk/show! (java.io.StringReader.  \""  (prin1-to-string (buffer-whole-string (current-buffer))) "\" ))")))

(defun clerk-show-buffer ()
  (interactive)
  (save-buffer)
(write-region (buffer-whole-string (current-buffer)) nil "/tmp/dummy.clj")
  (let
      ((filename
        (buffer-file-name)))
    (when filename
      (cider-interactive-eval
       (concat "(nextjournal.clerk/show! \"/tmp/dummy.clj\" )")))))




(defun clerk-show ()
  (interactive)
  (save-buffer)

  (let
      ((filename
        (buffer-file-name)))
    (when filename
      (cider-interactive-eval
       (concat "(nextjournal.clerk/show! \"" (tramp-file-local-name filename) "\")")))))



(map! (:localleader
       (:map (clojure-mode-map)
        (:prefix ("N" . "Notespace")
         "e" #'notespace/eval-this-notespace
         "r" #'notespace/eval-and-realize-this-notespace
         "n" #'notespace/eval-and-realize-note-at-this-line
         "l" #'notespace/eval-and-realize-notes-from-line
         "s" #'notespace/render-static-html
         (:prefix ("I" . "Init")
          "i b" #'notespace/init-with-browser
          "i i" #'notespace/init)))))
         
        

(setq cider-print-quota 10000)
(setq cider-repl-buffer-size-limit 10000)
(setq cider-use-overlays t)
(setq cljr-hotload-dependencies t)
(xclip-mode)
;; (require 'mouse)
;; (xterm-mouse-mode -1)
;(global-undo-tree-mode 1)
(toggle-frame-fullscreen)
(require 'cider-eval-sexp-fu)
;;; os/exwm/config.el -*- lexical-binding: t; -*-


(setq! highlight-indent-guides-responsive 'top)
(setq! highlight-indent-guides-method 'bitmap)


(setq! cider-lein-global-options "with-profile test")


(setq cider-clojure-cli-global-options "-J-XX:-OmitStackTraceInFastThrow -Atest:add-foreign")

(use-package company-box
  :hook (company-mode . company-box-mode))

(use-package parinfer-rust-mode
  :hook clojure-mode
    :init
    (setq parinfer-rust-auto-download t))
(add-to-list 'load-path "/usr/share/emacs/site-lisp/eaf")
(add-to-list 'load-path "/usr/share/emacs/site-lisp/eaf/core")
(add-to-list 'load-path "/usr/share/emacs/site-lisp/eaf/app/browser")
(require 'eaf)
(require 'eaf-browser)


;; (use-package eaf
;;   :load-path "/usr/share/emacs/site-lisp/eaf"
;;   :custom
;;                                         ; See https://github.com/emacs-eaf/emacs-application-framework/wiki/Customization
;;   (eaf-browser-continue-where-left-off t)
;;   (eaf-browser-enable-adblocker t)
;;   (browse-url-browser-function 'eaf-open-browser)
;;   :config
;;   (defalias 'browse-web #'eaf-open-browser)
;;   (eaf-bind-key scroll_up "C-n" eaf-pdf-viewer-keybinding)
;;   (eaf-bind-key scroll_down "C-p" eaf-pdf-viewer-keybinding)
;;   (eaf-bind-key take_photo "p" eaf-camera-keybinding)
;;   (eaf-bind-key nil "M-q" eaf-browser-keybinding))


(setq conda-anaconda-home "/opt/miniconda3")
(setq conda-env-executables-dir "bin")



;; (defun cider-tap (&rest r) ; inspired by https://github.com/clojure-emacs/cider/issues/3094
;;   (cons (concat "(let [__value "
;;                 (caar r)
;;                 "] (tap> {:clay-tap? true :form (quote " (caar r) ") :value __value}) __value)")
;;         (cdar r)))

;; (advice-add 'cider-nrepl-request:eval
;; :filter-args #'cider-tap)


(defun clay-require ()
    (interactive)
    (cider-nrepl-sync-request:eval
           ""))

(defun clay-init ()
    (interactive)
    (cider-nrepl-sync-request:eval ""))

(defun portal.api/open ()
  (interactive)
  (cider-nrepl-sync-request:eval
    "(do (ns dev) (def portal ((requiring-resolve 'portal.api/open))) (add-tap (requiring-resolve 'portal.api/submit)))"))

(defun portal.api/clear ()
  (interactive)
  (cider-nrepl-sync-request:eval "(portal.api/clear)"))

(defun portal.api/close ()
  (interactive)
  (cider-nrepl-sync-request:eval "(portal.api/close)"))



(defun clojure-run-scratch-clj ()
  (interactive)
  (cider-interactive-eval "(load-file \"/home/carsten/.clojure/scratch.clj\")"
                          nil
                          nil
                          nil)

  )



(defun clojure-defsc-last ()
  (interactive)
  (cider-interactive-eval "(eval `(sc.api/defsc ~(sc.api/last-ep-id)))"
                          nil
                          nil
                          nil))


(setq org-agenda-files (list "~/Dropbox/sync/org/todos.org"))




(setq clerk-viewer-list '("default"
                          ":html"
                          ":latex"
                          ":table"
                          "nextjournal.clerk.viewer/html-viewer"
                          "nextjournal.clerk.viewer/vega-lite-viewer"
                          "nextjournal.clerk.viewer/map-viewer"
                          "nextjournal.clerk.viewer/markdown-viewer"
                          "nextjournal.clerk.viewer/katex-viewer"
                          "nextjournal.clerk.viewer/fallback-viewer"
                          "nextjournal.clerk.viewer/string-viewer"))

(defun clerk-tap-last-sexp-with-viewer (viewer)
  (interactive
   (list (completing-read "Choose viewer: " clerk-viewer-list nil t)))

  (let ((tapped-form (concat "(clojure.core/->> "
                             (cider-last-sexp)
                             (if (equal "default" viewer)
                                 (concat " (nextjournal.clerk/with-viewer {:transform-fn identity})")
                               (if (string-prefix-p ":" viewer)
                                   (concat " (nextjournal.clerk/with-viewer " "(keyword \"" (substring viewer 1) "\")" ")")
                                   (concat " (nextjournal.clerk/with-viewer " "(symbol \"" viewer "\")" ")"))
                               )

                             " (clojure.core/tap>))")))
    (cider-interactive-eval tapped-form
                            nil
                            nil
                            (cider--nrepl-pr-request-map))))


(defun clerk-tap-sexp-at-point-with-viewer (viewer)
  (interactive
   (list (completing-read "Choose viewer: " clerk-viewer-list  nil t)))

  (save-excursion
    (goto-char (cadr (cider-sexp-at-point 'bounds)))
    (clerk-tap-last-sexp-with-viewer viewer)))

(defun cider-tap (&rest r)
  (cons (concat "(let [__value "
                (caar r)
                "] (tap> __value) __value)")
        (cdar r)))

(defun clerk-nrepl-auto-tap ()
    (interactive)
    (advice-add 'cider-nrepl-request:eval
                :filter-args #'cider-tap))

(defun clerk-open-tap-inspector ()
  (interactive)
  (cider-nrepl-sync-request:eval
   (concat "(require '[nextjournal.clerk :as clerk])"
           "(clerk/serve! {:browse true})"
           "(Thread/sleep 1000)"
           "(nextjournal.clerk/show! 'nextjournal.clerk.tap)")


   ))


(after! tramp
  (setq tramp-inline-compress-start-size 1000)
  (setq tramp-copy-size-limit 10000)
  (setq vc-handled-backends '(Git))
  (setq tramp-verbose 1)
  (setq tramp-default-method "scp")
  (setq tramp-use-ssh-controlmaster-options nil)
  (setq projectile--mode-line "Projectile")
  (setq tramp-verbose 1))
