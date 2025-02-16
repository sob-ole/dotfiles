;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

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

(load-theme 'doom-solarized-light t)
(setq doom-theme 'doom-solarized-light)

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

(add-hook 'sh-mode-common-hook #'my-sh-mode-common-hook)

;; C++ DEV expericence
(use-package! ac-clang
  :ensure t)
(use-package! cmake-ide
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

;; Настройка GIT
;; Интеграция Git-обёрток (ПР-ы, Issue, и т.д.)
(use-package! forge
  :ensure t)

;; Несколько терминалов
(use-package! multi-vterm
  :config
  (add-hook 'vterm-mode-hook
                  (lambda ()
                  (setq-local evil-insert-state-cursor 'box)
                  (evil-insert-state)))
  (define-key vterm-mode-map [return]                      #'vterm-send-return)

  (setq vterm-keymap-exceptions nil)
  (evil-define-key 'insert vterm-mode-map (kbd "C-e")      #'vterm--self-insert)
  (evil-define-key 'insert vterm-mode-map (kbd "C-f")      #'vterm--self-insert)
  (evil-define-key 'insert vterm-mode-map (kbd "C-a")      #'vterm--self-insert)
  (evil-define-key 'insert vterm-mode-map (kbd "C-v")      #'vterm--self-insert)
  (evil-define-key 'insert vterm-mode-map (kbd "C-b")      #'vterm--self-insert)
  (evil-define-key 'insert vterm-mode-map (kbd "C-w")      #'vterm--self-insert)
  (evil-define-key 'insert vterm-mode-map (kbd "C-u")      #'vterm--self-insert)
  (evil-define-key 'insert vterm-mode-map (kbd "C-d")      #'vterm--self-insert)
  (evil-define-key 'insert vterm-mode-map (kbd "C-n")      #'vterm--self-insert)
  (evil-define-key 'insert vterm-mode-map (kbd "C-m")      #'vterm--self-insert)
  (evil-define-key 'insert vterm-mode-map (kbd "C-p")      #'vterm--self-insert)
  (evil-define-key 'insert vterm-mode-map (kbd "C-j")      #'vterm--self-insert)
  (evil-define-key 'insert vterm-mode-map (kbd "C-k")      #'vterm--self-insert)
  (evil-define-key 'insert vterm-mode-map (kbd "C-r")      #'vterm--self-insert)
  (evil-define-key 'insert vterm-mode-map (kbd "C-t")      #'vterm--self-insert)
  (evil-define-key 'insert vterm-mode-map (kbd "C-g")      #'vterm--self-insert)
  (evil-define-key 'insert vterm-mode-map (kbd "C-c")      #'vterm--self-insert)
  (evil-define-key 'insert vterm-mode-map (kbd "C-SPC")    #'vterm--self-insert)
  (evil-define-key 'normal vterm-mode-map (kbd "C-d")      #'vterm--self-insert)
  (evil-define-key 'normal vterm-mode-map (kbd ",c")       #'multi-vterm)
  (evil-define-key 'normal vterm-mode-map (kbd ",n")       #'multi-vterm-next)
  (evil-define-key 'normal vterm-mode-map (kbd ",p")       #'multi-vterm-prev)
  (evil-define-key 'normal vterm-mode-map (kbd "i")        #'evil-insert-resume)
  (evil-define-key 'normal vterm-mode-map (kbd "o")        #'evil-insert-resume)
  (evil-define-key 'normal vterm-mode-map (kbd "<return>") #'evil-insert-resume))

;; Размер vterm при открытии
(set-popup-rule! "*doom:vterm-popup:*" :size 0.15 :vslot -4 :select t :quit nil :ttl 0)

(defun my/vterm-enable-modeline ()
  (setq-local mode-line-format (doom-modeline 'main)))
(add-hook 'vterm-mode-hook #'my/vterm-enable-modeline)

;; LeetCode
(use-package! leetcode
  :ensure t)
(setq leetcode-prefer-language "c++")
(setq leetcode-prefer-sql "mysql")
(setq leetcode-save-solutions t)
(setq leetcode-directory "~/leetcode")

(use-package! telega
  :ensure t
  :commands (telega)
  :defer t)

(use-package! evil-tutor
  :ensure t)

(use-package! pdf-tools
  :ensure t)
