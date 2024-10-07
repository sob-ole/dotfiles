;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face

;; Установка шрифта
;; Set the default font
(setq doom-font (font-spec :family "DejaVu Sans Mono" :size 16))

;; Optionally set the variable pitch font
(setq doom-variable-pitch-font (font-spec :family "DejaVu Sans Mono" :size 16))



;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:

;;(setq doom-font ')

(setq doom-theme 'doom-1337)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;;(use-package! whitespace
;;  :config
;;  (setq whitespace-style '(face tabs tab-mark spaces space-mark)
;;        whitespace-display-mappings '(
;;          (space-mark   ?\     [?\u00B7]     [?.])
;;         (space-mark   ?\xA0  [?\u00A4]     [?_])
;;          (tab-mark     ?\t    [?\u00BB ?\t] [?\\ ?\t]))
;;        ;; Only enable whitespace-mode in specific modes
;;        whitespace-global-modes '(not help-mode
;;                                      special-mode
;;                                      comint-mode
;;                                      minibuffer-mode
;;                                      messages-buffer-mode
;;                                      treemacs-mode
;;                                      completion-list-mode)))

;;(global-whitespace-mode +1)

(use-package! projectile
  :ensure t
  :config
  (define-key projectile-mode-map (kbd "C-x p") 'projectile-command-map)
  (define-key projectile-mode-map (kbd "C-x C-r") 'projectile-ripgrep)
  (projectile-mode +1)
  (setq projectile-run-use-comint-mode t))


;;(use-package! flycheck
;;  :ensure t)

(defun my-c-mode-common-hook ()
  "Custom settings for C/C++ programming."
  (setq tab-width 5
        c-basic-offset 5
        indent-tabs-mode nil)
  ;; Ensure finer control over specific indentation cases
  (c-set-offset 'substatement-open 0)
  (c-set-offset 'inline-open 0)
  (c-set-offset 'statement 0)
  (c-set-offset 'statement-cont 0))

(add-hook 'c-mode-common-hook #'my-c-mode-common-hook)


(defun my-sh-mode-common-hook ()
  "Custom settings for Bash programming."
  (setq tab-width 2
        sh-basic-offset 2
        indent-tabs-mode nil)
  ;; Ensure finer control over specific indentation cases
  (sh-set-offset 'substatement-open 0)
  (sh-set-offset 'inline-open 0)
  (sh-set-offset 'statement 0)
  (sh-set-offset 'statement-cont 0))

(add-hook 'sh-mode-common-hook #'my-sh-mode-common-hook)

;;(use-package! lsp-ui
;;  :commands lsp-ui-mode
;;  :hook (lsp-mode . lsp-ui-mode)
;;  :config
;;  (setq lsp-ui-sideline-enable t
;;        lsp-ui-sideline-show-diagnostics t
;;        lsp-ui-sideline-show-hover t
;;        lsp-ui-doc-enable t)) ;; Shows documentation in a pop-up


;; C++ DEV expericence
(use-package! ac-clang)
(use-package! cmake-ide)

(use-package! lsp-treemacs
  :after lsp)

(use-package! treemacs)


;; Подсветка синтаксиса
(use-package! tree-sitter)
;; Использовать глобально
(global-tree-sitter-mode)

;; Enable tree-sitter globally
(global-tree-sitter-mode)

(defun my-enable-tree-sitter-hl-mode ()
  (when (derived-mode-p 'c-mode 'c++-mode 'sh-mode 'cmake-mode)
    (tree-sitter-hl-mode 1)))

(add-hook 'tree-sitter-after-on-hook #'my-enable-tree-sitter-hl-mode)

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
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
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
