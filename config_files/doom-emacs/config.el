;;; $DOOMDIR/config.el -*- lexical-binding: programming pet project memeprogramming pet project memet; -*-

;; Использование Unicode по умолчанию

;; Установка шрифта
;; ;; Set preferred coding systems
(prefer-coding-system 'utf-8)
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)

;; Define a reusable font spec variable
(defvar my-default-font (font-spec :family "Hack" :size 16)
  "The default font specification for Emacs.")

;; Apply the font specifications
(setq doom-font my-default-font)
(setq doom-variable-pitch-font my-default-font)
(setq-default line-spacing 0)

;; Force Hack for Cyrillic script
(when (member "Hack" (font-family-list))
  (set-fontset-font t 'cyrillic my-default-font))

;; Performance optimization
(setq inhibit-compacting-font-caches t)

;; Настройка темы
(setq custom-safe-themes t)
(disable-theme 'default)

(load-theme 'doom-gruvbox t)
(setq doom-theme 'doom-gruvbox)

(defun my-load-theme (theme)
  "Disable all other themes and load THEME."
  (interactive
   (list (completing-read "Load custom theme: " (mapcar #'symbol-name (custom-available-themes)))))
  (mapc #'disable-theme custom-enabled-themes) ;; Unload all active themes
  (load-theme (intern theme) t)) ;; Load the selected theme

(global-set-key (kbd "C-c T") #'my-load-theme)

(setq display-line-numbers-type t)

(setq org-directory "~/org/")

(setq large-file-warning-threshold 500000000) ;; 500 MB

(use-package! org-modern
  :ensure t)
;; Option 2: Globally
(with-eval-after-load 'org (global-org-modern-mode))

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


;; C++ DEV expericence
(use-package! ac-clang
  :ensure t)

(use-package! lsp-treemacs
  :ensure t
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
(use-package! treemacs
  :ensure t)
(treemacs-follow-mode)

(use-package! tree-sitter
  :ensure t)
(use-package! tree-sitter-langs
  :ensure t)
;; Глобальная подсветка синтаксиса
(global-tree-sitter-mode)

(defun my-enable-tree-sitter-hl-mode ()
  (when (derived-mode-p 'c-mode 'c++-mode 'sh-mode 'cmake-mode)
    (tree-sitter-hl-mode 1)))

(add-hook 'tree-sitter-after-on-hook #'my-enable-tree-sitter-hl-mode)

;; (use-package! rtags)
;; (require 'rtags)

(map! :n "C-/" #'comment-line) ; Normal mode
(map! :i "C-/" #'comment-line) ; Insert mode
(map! :v "C-/" #'comment-line) ; Visual mode

;; Настройки mode-line
(setq doom-modeline-vcs-max-length 40);; Длина строки названия git-ветки

;; Настройки часов
;; Не оповещять о новых письмах (убирает лишнюю точку *)
(setq display-time-mail-directory nil) ;; Не проверять почту
(setq display-time-format "%H:%M")
(setq display-time-mail-function nil)
(display-time-mode 1)

;; ;; Отрисовка отступов
(use-package! highlight-indent-guides
  :ensure t)
(setq highlight-indent-guides-auto-enabled nil)
(set-face-background 'highlight-indent-guides-odd-face "darkgray")
(set-face-background 'highlight-indent-guides-even-face "dimgray")
(set-face-foreground 'highlight-indent-guides-character-face "dimgray")
(setq highlight-indent-guides-method `bitmap)
(add-hook 'prog-mode-hook 'highlight-indent-guides-mode)

;; Перемещение текста
(use-package! drag-stuff
  :ensure t)
(drag-stuff-global-mode 1)
(drag-stuff-define-keys)

;; Размер vterm при открытии
(set-popup-rule! "*doom:vterm-popup:*" :size 0.15 :vslot -4 :select t :quit nil :ttl 0)

(defun my/vterm-enable-modeline ()
  (setq-local mode-line-format (doom-modeline 'main)))
(add-hook 'vterm-mode-hook #'my/vterm-enable-modeline)

(use-package! telega
  :ensure t
  :commands (telega)
  :defer t)

(use-package! evil-tutor
  :ensure t)

(use-package! pdf-tools
  :ensure t)

(use-package! transwin
  :ensure t)

(use-package! org-habit-stats
  :ensure t)
(define-key org-mode-map (kbd "C-c h") 'org-habit-stats-view-habit-at-point)
(define-key org-agenda-mode-map (kbd "H") 'org-habit-stats-view-habit-at-point-agenda)

(defun set-emacs-transparency (alpha)
  "Set the background transparency of Emacs. ALPHA should be an integer between 0 (transparent) and 100 (opaque)."
  (interactive "nEnter alpha transparency value (0–100): ")
  (set-frame-parameter nil 'alpha-background alpha)
  (setf (alist-get 'alpha-background default-frame-alist) alpha))

(set-emacs-transparency 90)

;; Перемещение порядка рабочих пространств .projectile на "{}"
(map! :leader
      (:prefix ("TAB" . "workspace")
       :desc "Swap workspace left"  "{" #'+workspace/swap-left
       :desc "Swap workspace right" "}" #'+workspace/swap-right))

;; Отключение записи vim-макросов
(define-key evil-normal-state-map "q" nil)
(define-key evil-visual-state-map "q" nil)


(use-package! vue-mode)
