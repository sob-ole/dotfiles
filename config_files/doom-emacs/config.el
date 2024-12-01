;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
;; Установка шрифта
(setq doom-font (font-spec :family "DejaVu Sans Mono" :size 16))
(setq doom-variable-pitch-font (font-spec :family "DejaVu Sans Mono" :size 16))

;; Настройка темы
(setq custom-safe-themes t)
(disable-theme 'default)
(load-theme 'doom-gruvbox t)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

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

;; C++ DEV expericence
(use-package! ac-clang)
(use-package! cmake-ide)

(use-package! lsp-treemacs
  :after lsp)

;; Иконки для меню автодоплнения (для corfu)
(use-package! kind-icon
  :ensure t
  :after corfu
  ;:custom
  ; (kind-icon-blend-background t)
  ; (kind-icon-default-face 'corfu-default) ; only needed with blend-background
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

;; Treemacs - проектный файловый обзорщик в левой половине окна
(use-package! treemacs)
(treemacs-follow-mode)

(use-package! tree-sitter)
;; Глобальная подсветка синтаксиса
(global-tree-sitter-mode)

(defun my-enable-tree-sitter-hl-mode ()
  (when (derived-mode-p 'c-mode 'c++-mode 'sh-mode 'cmake-mode)
    (tree-sitter-hl-mode 1)))

(add-hook 'tree-sitter-after-on-hook #'my-enable-tree-sitter-hl-mode)

(use-package! flycheck-plantuml)
;; Диаграммы Plantuml
(with-eval-after-load 'flycheck
  (require 'flycheck-plantuml)
  (flycheck-plantuml-setup))

(setq plantuml-output-type "svg")

(map! :n "C-/" #'comment-line) ; Normal mode
(map! :i "C-/" #'comment-line) ; Insert mode
(map! :v "C-/" #'comment-line) ; Visual mode

;; Настройки mode-line
(setq doom-modeline-vcs-max-length 40);; Название git-ветки

;; Настройки часов
;; Не оповещять о новых письмах (убирает лишнюю точку *)
(setq display-time-mail-directory nil) ;; Не проверять почту
(setq display-time-format "%H:%M")
(setq display-time-mail-function nil)
(display-time-mode 1)

;; ;; Отрисовка пробелов
;; (add-hook 'prog-mode-hook #'whitespace-mode)
;; (setq whitespace-style '(face tabs spaces trailing))
;; (add-hook 'completion-list-mode-hook (lambda () (whitespace-mode -1)))
;; (add-hook 'help-mode-hook (lambda () (whitespace-mode -1)))
;; (add-hook 'special-mode-hook (lambda () (whitespace-mode -1)))
;; (set-face-attribute 'whitespace-tab nil :background "gray20" :foreground "gray40")
;; (set-face-attribute 'whitespace-space nil :background nil :foreground "gray30")
;; (set-face-attribute 'whitespace-trailing nil :background "red1" :foreground nil)
