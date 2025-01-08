;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Использование Unicode по умолчанию

;; Установка шрифта
;; Set preferred coding systems
(prefer-coding-system 'utf-8)
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)

;; Define font specifications
(setq doom-font (font-spec :family "Hack" :size 15 ))
(setq doom-variable-pitch-font (font-spec :family "Hack" :size 15 ))
(setq-default line-spacing 0)

;; Performance optimization
(setq inhibit-compacting-font-caches t)

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

;; (use-package! org-modern)
;; Option 2: Globally
;; (with-eval-after-load 'org (global-org-modern-mode))

(use-package! projectile
  :ensure t
  :config
  (define-key projectile-mode-map (kbd "C-x p") 'projectile-command-map)
  (define-key projectile-mode-map (kbd "C-x C-r") 'projectile-ripgrep)
  (projectile-mode +1)
  (setq projectile-run-use-comint-mode t))

(setq ff-always-try-to-create nil)


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
(use-package! tree-sitter-langs)
;; Глобальная подсветка синтаксиса
(global-tree-sitter-mode)

(defun my-enable-tree-sitter-hl-mode ()
  (when (derived-mode-p 'c-mode 'c++-mode 'sh-mode 'cmake-mode)
    (tree-sitter-hl-mode 1)))

(add-hook 'tree-sitter-after-on-hook #'my-enable-tree-sitter-hl-mode)

;; (use-package! rtags)
;; (require 'rtags)
;; (use-package! cmake-ide)
;; (cmake-ide-setup)


;; (use-package! flycheck-plantuml)
;; ;; Диаграммы Plantuml
;; (with-eval-after-load 'flycheck
;;   (require 'flycheck-plantuml)
;;   (flycheck-plantuml-setup))

;; (setq plantuml-output-type "svg")

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

;; ;; Отрисовка отступов
(use-package! highlight-indent-guides)
(setq highlight-indent-guides-auto-enabled nil)
(set-face-background 'highlight-indent-guides-odd-face "darkgray")
(set-face-background 'highlight-indent-guides-even-face "dimgray")
(set-face-foreground 'highlight-indent-guides-character-face "dimgray")
(setq highlight-indent-guides-method `bitmap)
(add-hook 'prog-mode-hook 'highlight-indent-guides-mode)

;; Перемещение текста
(use-package! move-text)
(move-text-default-bindings)
