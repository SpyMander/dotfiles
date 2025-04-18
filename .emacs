;; Set up package.el to work with MELPA
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; and `package-pinned-packages`. Most users will not need or want to do this.
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)

(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(package-initialize)
;;(package-refresh-contents)


;; Download Evil
;;(unless (package-installed-p 'evil)
;;  (package-install 'evil))

;; Enable Evil
;;(setq backward-char 'k')

;; bad idea????
(server-start)

;; lsp stuff
(global-flycheck-mode +1)

(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'objc-mode-hook 'irony-mode)

(add-hook 'c++-mode-hook #'eglot-ensure)
(add-hook 'c-mode-hook #'eglot-ensure)

(setq flycheck-gcc-language-standard "c++20")

;;zig
;;(add-hook 'zig-mode-hook #'eglot-ensure)

(use-package eglot
	:hook
	(zig-mode . eglot-ensure)
	:config
	(setq eglot-autoshutdown t)
	(add-to-list 'eglot-server-programs '(zig-mode . ("zls"))))

(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)

(lsp-treemacs-sync-mode 1)

;; cpp c company hooks
(global-company-mode 1)
(eval-after-load 'company
  '(add-to-list 'company-backends 'company-irony))
;;(setq lsp-keymap-prefix "s-l")

(require 'lsp-mode)

;; window stuff
(add-to-list 'default-frame-alist '(undecorated . t))
;;(set-fringe-mode 0)
(add-to-list 'default-frame-alist '(internal-border-width . 0))
;; no splash
(setq inhibit-startup-screen t)

(require 'ergoemacs-status)
(ergoemacs-status-mode)

(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)

(load-theme 'wombat)
(set-frame-font "Inconsolata Nerd Font Mono 12" nil t)

(defun my-resize-margins ()
  (let ((margin-size (/ (- (frame-width) 80) 2)))
    (set-window-margins nil margin-size margin-size)))

(add-hook 'window-configuration-change-hook #'my-resize-margins)
(my-resize-margins)

;; vim config
(require 'evil)

(setq display-line-numbers-type 'relative) 
(global-display-line-numbers-mode)


(define-key evil-normal-state-map (kbd "j") 'backward-char)
(define-key evil-normal-state-map (kbd "k") 'next-line)
(define-key evil-normal-state-map (kbd "l") 'previous-line)
(define-key evil-normal-state-map (kbd ";") 'forward-char)

(define-key evil-visual-state-map (kbd "j") 'backward-char)
(define-key evil-visual-state-map (kbd "k") 'next-line)
(define-key evil-visual-state-map (kbd "l") 'previous-line)
(define-key evil-visual-state-map (kbd ";") 'forward-char)

(define-key evil-motion-state-map (kbd "j") 'backward-char)
(define-key evil-motion-state-map (kbd "k") 'next-line)
(define-key evil-motion-state-map (kbd "l") 'previous-line)
(define-key evil-motion-state-map (kbd ";") 'forward-char)

;;(define-key evil-motion-operator-map (kbd "j") 'backward-char)
;;(define-key evil-motion-operator-map (kbd "k") 'next-line)
;;(define-key evil-motion-operator-map (kbd "l") 'previous-line)
;;(define-key evil-motion-operator-map (kbd ";") 'forward-char)

;;(global-unset-key (kbd "C-F"))

(define-key evil-insert-state-map (kbd "C-f") nil)
(define-key evil-visual-state-map (kbd "C-f") nil)
;;(global-unset-key (kbd "C-f"))

(define-key evil-insert-state-map (kbd "C-f") 'normal-mode)
(define-key evil-visual-state-map (kbd "C-f") 'normal-mode)
(define-key evil-normal-state-map (kbd "C-a") 'save-buffer)

(evil-mode 1)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(company company-irony ctags-update ergoemacs-status
	     evil-visual-mark-mode flycheck-irony irony-eldoc
	     lsp-treemacs lsp-ui org-modern zig-mode)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; org config
(add-hook 'org-mode-hook 'org-indent-mode)

;;auto sudo file explore
(defun sudo-find-file () (interactive)
  (let ((filepath))
  (setq filepath (format "/sudo::/home/spy/%s" (read filepath)))
  (message "%s" filepath)
  (find-file-literally filepath)))

(keymap-global-set "C-c s" 'sudo-find-file)

(setq backup-directory-alist `(("." . "~/.saves")))

