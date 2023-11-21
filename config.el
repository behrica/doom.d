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

  ;; (setq tab-always-indent 'complete)
  (setq cider-repl-buffer-size-limit 100000)
  (setq cider-repl-tab-command t)
  ;; (add-hook 'company-completion-started-hook 'custom/set-company-maps)
  ;; (add-hook 'company-completion-finished-hook 'custom/unset-company-maps)
  ;; (add-hook 'company-completion-cancelled-hook 'custom/unset-company-maps)
  (define-key clojure-mode-map (kbd "TAB") 'company-capf)
  (define-key clojure-mode-map (kbd "C-c c c") 'clerk-show)
  (define-key clojure-mode-map (kbd "C-c c b") 'clerk-show-buffer)
  (define-key cider-inspector-mode-map (kbd "<normal-state> t") 'cider-inspector-tap-current-val-with-clerk-viewer)
  (define-key clojure-mode-map (kbd "C-c c t s") 'clerk-tap-sexp-at-point-with-viewer))

(global-set-key (kbd "TAB") #'company-capf)

;; (defun custom/unset-company-maps (&rest unused)
;;   "Set default mappings (outside of company).
;;     Arguments (UNUSED) are ignored."
;;   (general-def
;;     :states 'insert
;;     :keymaps 'override
;;     "<down>" nil
;;     "<up>"   nil
;;     "RET"    nil
;;     [return] nil
;;     "C-n"    nil
;;     "C-p"    nil
;;     "C-j"    nil
;;     "C-k"    nil
;;     "C-h"    nil
;;     "C-u"    nil
;;     "C-d"    nil
;;     "C-s"    nil
;;     "C-S-s"   (cond ((featurep! :completion helm) nil)
;;                     ((featurep! :completion ivy)  nil))
;;     "C-SPC"   nil
;;     "TAB"     nil
;;     [tab]     nil
;;     [backtab] nil))

;; (defun custom/set-company-maps (&rest unused)
;;   "Set maps for when you're inside company completion.
;;     Arguments (UNUSED) are ignored."
;;   (general-def
;;     :states 'insert
;;     :keymaps 'override
;;     "<down>" #'company-select-next
;;     "<up>" #'company-select-previous
;;     "RET" #'company-complete
;;     [return] #'company-complete
;;     "C-w"     nil  ; don't interfere with `evil-delete-backward-word'
;;     "C-n"     #'company-select-next
;;     "C-p"     #'company-select-previous
;;     "C-j"     #'company-select-next
;;     "C-k"     #'company-select-previous
;;     "C-h"     #'company-show-doc-buffer
;;     "C-u"     #'company-previous-page
;;     "C-d"     #'company-next-page
;;     "C-s"     #'company-filter-candidates
;;     "C-S-s"   (cond ((featurep! :completion helm) #'helm-company)
;;                     ((featurep! :completion ivy)  #'counsel-company))
;;     "C-SPC"   #'company-complete-common
;;     "TAB"     #'company-complete-common-or-cycle
;;     [tab]     #'company-complete-common-or-cycle
;;     [backtab] #'company-select-previous))


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


(setq cider-print-quota 10000)
(setq cider-repl-buffer-size-limit 10000)
(setq cider-use-overlays t)
(setq cljr-hotlad-dependencies t)
(xclip-mode)
;; (require 'mouse)
;; (xterm-mouse-mode -1)
;(global-undo-tree-mode 1)
(toggle-frame-fullscreen)
(require 'cider-eval-sexp-fu)


(setq! highlight-indent-guides-responsive 'top)
(setq! highlight-indent-guides-method 'bitmap)


(setq! cider-lein-global-options "with-profile test")



(use-package company-box
  :hook (company-mode . company-box-mode))

(use-package parinfer-rust-mode
  :hook clojure-mode
    :init
    (setq parinfer-rust-auto-download t))


(setq conda-anaconda-home "/opt/miniconda3")
(setq conda-env-executables-dir "bin")


(defun clojure-defsc-last ()
  (interactive)
  (cider-interactive-eval "(eval `(sc.api/defsc ~(sc.api/last-ep-id)))"
                          nil
                          nil
                          nil))


(setq org-agenda-files (list "~/Dropbox/sync/org/todos.org"))









(after! tramp
  (setq tramp-inline-compress-start-size 1000)
  (setq tramp-copy-size-limit 10000)
  (setq vc-handled-backends '(Git))
  (setq tramp-default-method "scp")
  (setq tramp-use-ssh-controlmaster-options t)
  (setq projectile--mode-line "Projectile")
  (setq tramp-verbose 4)
  (add-to-list 'tramp-remote-path 'tramp-own-remote-path)

)

(custom-set-variables
 '(tramp-remote-path (quote (tramp-own-remote-path)) nil (tramp)))

(defun print-find-clojure-lsp ()
  (interactive)
  (message "exec-path: %s" (exec-path))
  (message "find-python: %s" (executable-find "clojure-lsp")))


(require 'clerk-mode)
(add-hook 'clojure-mode #'clerk-mode)


(after! clerk-mode
  (define-key clojure-mode-map (kbd "C-c c c") 'clerk-show)
  ;; (define-key clojure-mode-map (kbd "C-c c b") 'clerk-show-buffer)
  ;; (define-key cider-inspector-mode-map (kbd "<normal-state> t") 'cider-inspector-tap-current-val-with-clerk-viewer)
  ;; (define-key clojure-mode-map (kbd "C-c c t s") 'clerk-tap-sexp-at-point-with-viewer)
  )


(setq gc-cons-threshold (* 100 1024 1024)
      read-process-output-max (* 1024 1024)
      treemacs-space-between-root-nodes nil
      company-minimum-prefix-length 1
     )



(use-package lsp-mode
  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-enable-indentation nil)
  (setq lsp-completion-enable nil)
  (setq lsp-keymap-prefix "C-c l")
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         ;; (clojure-mode . lsp)
         ;; if you want which-key integration
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)


(after! lsp-mode


  (lsp-register-client
   (make-lsp-client :new-connection (lsp-tramp-connection "clojure-lsp")
                    :major-modes '(clojure-mode)
                    :remote? t
                    :server-id 'clojure-lsp-remote)))



;; (lsp-register-client

;;  (make-lsp-client
;;   :semantic-tokens-faces-overrides '(:types (("macro" . font-lock-keyword-face)
;;                                              ("keyword" . clojure-keyword-face)
;;                                              ("event" . default)))
;;   :new-connection (lsp-tramp-connection "clojure-lsp")   :major-modes '(clojure-mode clojurec-mode clojurescript-mode)
;;   :library-folders-fn (lambda (_workspace) (list lsp-clojure-workspace-cache-dir))
;;   uri-handlers (lsp-ht ("jar" #'lsp-clojure--file-in-jar))
;;   :tion-handlers (lsp-ht ("code-lens-references" #'lsp-clojure--show-references))
;;   :notification-handlers (lsp-ht ("clojure/textDocument/testTree" #'lsp-clojure--handle-test-tree))
;;   :initialization-options '(:dependency-scheme "jar"
;;                             :show-docs-arity-on-same-line? t)
;;   :custom-capabilities `((experimental . ((testTree . ,(and (require 'lsp-treemacs nil t) t)))))
;;   :remote? t
;;   :server-id 'clojure-lsp-remote))

(defun clay/start ()
  (interactive)
  (cider-interactive-eval "
    (require '[scicloj.clay.v2.api])
    (scicloj.clay.v2.api/start!)")
  t)

(defun clay/show-namespace ()
  (interactive)
  (clay/start)
  (save-buffer)
  (let
      ((filename
        (buffer-file-name)))
    (when filename
      (cider-interactive-eval
       (concat "(scicloj.clay.v2.api/show-namespace! \"" filename "\" {})")))))

(defun clay/show-namespace-and-write-html ()
  (interactive)
  (clay/start)
  (save-buffer)
  (let
      ((filename
        (buffer-file-name)))
    (when filename
      (cider-interactive-eval
       (concat "(scicloj.clay.v2.api/show-namespace-and-write-html! \"" filename "\" {:toc? true})")))))

(defun clay/generate-and-show-namespace-quarto ()
  (interactive)
  (clay/start)
  (save-buffer)
  (let
      ((filename
        (buffer-file-name)))
    (when filename
      (cider-interactive-eval
       (concat "(scicloj.clay.v2.api/generate-and-show-namespace-quarto! \"" filename "\" {})")))))

(defun clay/generate-namespace-light-quarto ()
  (interactive)
  (clay/start)
  (save-buffer)
  (let
      ((filename
        (buffer-file-name)))
    (when filename
      (cider-interactive-eval
       (concat "(scicloj.clay.v2.api/generate-namespace-light-quarto! \"" filename "\" {})")))))

(defun clay/cider-interactive-notify-and-eval (code)
  (cider-interactive-eval
   code
   (cider-interactive-eval-handler nil (point))
   nil
   nil))


(defun clay/send (code)
  (clay/start)
  (clay/cider-interactive-notify-and-eval
   (concat "(scicloj.clay.v2.api/handle-form! (quote " code "))")))

(defun clay/send-last-sexp ()
  (interactive)
  (clay/start)
  (clay/send (cider-last-sexp)))

(defun clay/send-defun-at-point ()
  (interactive)
  (clay/start)
  (clay/send (thing-at-point 'defun)))



(defun clojure-tap (&rest r)
  (cons (concat "(let [__value "
                (caar r)
                "] (tap> __value) __value)")
        (cdar r)))

(defun cider-nrepl-enable-auto-tap ()
    (interactive)
    (advice-add 'cider-nrepl-request:eval
                :filter-args #'clojure-tap))

(defun cider-copy-jack-in (params)

  (interactive "P")
  (let ((params (thread-first params
                  (cider--update-project-dir)
                  (cider--update-jack-in-cmd))))
    (kill-new (plist-get params :jack-in-cmd))))


(defun portal/open ()
  (interactive)
  (cider-interactive-eval "
(require '[portal.api :as p])
(def p (p/open))

    ")
  t)

(defun portal/add-tap ()
  (interactive)
  (cider-interactive-eval "
    (add-tap #'p/submit)
    ")
  t)


