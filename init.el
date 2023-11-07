
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Paquetes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Repositiorios de paquetes
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; use-package simplifica mucho este archivo de configuracion
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure 't)

;; IDO mode
(ido-mode 1)
(setq ido-everywhere t)
(setq ido-enable-flex-matching t)

;; Doom theme
(use-package doom-themes
  :ensure t
  :config
  (load-theme 'doom-one t)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

;; Doom modeline
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
 )

;; all the icons
;; es necesario instalar las fuentes:
;;   M-x all-the-icons-install-fonts
;;   M-x nerd-icons-install-fonts
(use-package all-the-icons
  :ensure t)

;; Centaur tabs
(use-package centaur-tabs
  :ensure t
  :config
  (setq centaur-tabs-set-bar 'under
	centaur-tabs-set-icons t
	centaur-tabs-gray-out-icons 'buffer
	centaur-tabs-height 32
	x-underline-at-descent-line t
	centaur-tabs-style "wave")
  (centaur-tabs-mode t))

;; ORG MODE
;; (setq org-hide-emphasis-markers t)
(use-package org-bullets
    :config
    (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

(add-hook 'org-mode-hook 'org-indent-mode )
(add-hook 'org-mode-hook 'visual-line-mode )

(setq org-latex-caption-above nil)
(setq org-latex-toc-command "\\thispagestyle{fancy} \\tableofcontents")

(setq org-latex-pdf-process
      '("latexmk -pdflatex='pdflatex -interaction nonstopmode' -pdf -bibtex -f %f"))



(unless (boundp 'org-latex-classes)
  (setq org-latex-classes nil))
(add-to-list 'org-latex-classes
             '("informe-laruex"
               "\\documentclass[11pt,a4paper]{article}
\\usepackage[utf8]{inputenc}
\\usepackage[T1]{fontenc}
\\usepackage{palatino}
\\usepackage{fixltx2e}
\\usepackage{graphicx}
\\usepackage{longtable}
\\usepackage{float}
\\usepackage{wrapfig}
\\usepackage{rotating}
\\usepackage[normalem]{ulem}
\\usepackage{amsmath}
\\usepackage{textcomp}
\\usepackage{marvosym}
\\usepackage{wasysym}
\\usepackage{amssymb}
\\usepackage{hyperref}
\\usepackage{mathpazo}
\\usepackage{color}
\\usepackage{enumerate}
\\definecolor{bg}{rgb}{0.95,0.95,0.95}
\\tolerance=1000
      [NO-DEFAULT-PACKAGES]
      [PACKAGES]
      [EXTRA]
\\linespread{1.1}
\\usepackage{a4wide}
\\usepackage{makecell}
\\usepackage{fancyhdr}
\\setlength{\\headheight}{64pt}
\\pagestyle{fancy}
\\fancyhf{}
\\fancyhead[L]{
  \\mbox{\\makecell[cl]{\\includegraphics[scale=0.08]{/home/flakito/LARUEX/Logos/laruex_logo.png}}}}

\\fancyhead[R]{
  \\mbox{\\makecell[r]{{\\sc Laboratorio de Radiactividad}
      \\\\{\\sc de la Universidad de Extremadura}
      \\\\{\\small Avda. de la Universidad s/n}
      \\\\{\\small 10004 Cáceres}
      \\\\{\\small Tel: +34 927 257 153}
      \\\\{\\small e-mail: laruex@unex.es}
    }}}

\\renewcommand{\\headrulewidth}{1pt}
\\usepackage{lastpage}
\\lfoot{{\\small Pedro Monroy}}
\\cfoot{{\\small Estado de la Red SPIDA}}
\\rfoot{\\thepage\\ of \\pageref{LastPage}}

\\hypersetup{pdfborder=0 0 0}"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")))
;; AUCTEX
;; LATEX
(use-package tex
  :ensure auctex)


;; Elpy para archivos python
(defun elpy/display-fill-column ()
  (setq display-fill-column-indicator 1)
  (setq display-fill-column-indicator-column 79)
  (display-fill-column-indicator-mode))

(use-package elpy
  :ensure t
  :defer t
  :init
  (advice-add 'python-mode :before 'elpy-enable)
  :hook (elpy-mode . elpy/display-fill-column))

(add-hook 'elpy-mode-hook (lambda ()
                            (add-hook 'before-save-hook
                                      'elpy-format-code nil t)))

;; Python docstring tool
;; (use-package py-pyment
;;     :after python
;;     :config
;;     (setq py-pyment-options '("--output=google")))

;; Hide Show esconder/mostrar bloques de código
(use-package hideshow
  :bind (("C-c C-<up>" . hs-hide-block)
         ("C-c C-<down>" . hs-show-block)
	 ("C-c C-<home>" . hs-show-all)
	 ("C-c C-<end>" . hs-hide-all)
	 )
  :init (add-hook #'prog-mode-hook #'hs-minor-mode)
  :diminish hs-minor-mode
  :config
  ;; Add `json-mode' and `javascript-mode' to the list
  (setq hs-special-modes-alist
        (mapcar 'purecopy
                '((c-mode "{" "}" "/[*/]" nil nil)
                  (c++-mode "{" "}" "/[*/]" nil nil)
                  (java-mode "{" "}" "/[*/]" nil nil)
                  (js-mode "{" "}" "/[*/]" nil)
                  (json-mode "{" "}" "/[*/]" nil)
                  (javascript-mode  "{" "}" "/[*/]" nil)))
	)
  )


(use-package company
  :ensure t
  :diminish company-mode
  :init
  (global-company-mode)
  ;; (add-hook 'after-init-hook 'global-company-mode)
  :config
  ;; set default `company-backends'
  (setq company-backends
        '((company-files          ; files & directory
           company-keywords       ; keywords
           company-capf)  ; completion-at-point-functions
          (company-abbrev company-dabbrev)
          ))
  (use-package company-statistics
    :ensure t
    :init
    (company-statistics-mode))
  ;; (use-package company-web
  ;;   :ensure t)
  ;; (use-package company-try-hard
  ;;   :ensure t
  ;;   :bind
  ;;   (("C-<tab>" . company-try-hard)
  ;;    :map company-active-map
  ;;    ("C-<tab>" . company-try-hard)))
  (use-package company-quickhelp
    :ensure t
    :config
    (company-quickhelp-mode))
  )

;; Dashboard pantalla de inicio
(use-package dashboard
  :ensure t
  :init
  (progn
    (setq dashboard-items '((recents . 7)))
    (setq dashboard-show-shortcuts nil)
    ;;(setq dashboard-week-agenda t)
    (setq dashboard-center-content t)
    (setq dashboard-set-file-icons t)
    (setq dashboard-startup-banner 'logo)
    (setq dashboard-set-heading-icons t)
    )
  :config
  (dashboard-setup-startup-hook)
  )

;;
;; Which key
;; ----------------------
(use-package which-key
  :ensure t
  :config
  (which-key-mode)
  (which-key-setup-side-window-bottom)
  )

;; (global-set-key [f8] 'neotree-toggle)

;; -- Neotree --
;; (use-package neotree :ensure t
;;   :init
;;   (setq neo-window-fixed-size nil
;; 	neo-theme (if (display-graphic-p) 'icons 'arrow)
;; 	neo-show-updir-line nil
;; 	neo-modern-sidebar t
;; 	neo-auto-indent-point t
;; 	neo-cwd-line-style 'button)

;;   :config
;;   (add-to-list
;;    'window-size-change-functions
;;    (lambda (frame)
;;      (let ((neo-window (neo-global--get-window)))
;;        (unless (null neo-window)
;;          (setq neo-window-width (window-width neo-window))))))

;;   (defun neotree-project-dir-toggle ()
;;     "Open NeoTree using the project root, using find-file-in-project,
;; or the current buffer directory."
;;     (interactive)
;;     (let ((project-dir
;;            (ignore-errors
;;            ;;; Pick one: projectile or find-file-in-project
;;              (projectile-project-root)
;;              ;;(ffip-project-root)
;;              ))
;;           (file-name (buffer-file-name))
;;           (neo-smart-open t))
;;       (if (and (fboundp 'neo-global--window-exists-p)
;;                (neo-global--window-exists-p))
;;           (neotree-hide)
;; 	(progn
;;           (neotree-show)
;;           (if project-dir
;;               (neotree-dir project-dir))
;;           (if file-name
;;               (neotree-find file-name))))))

;;   :bind
;;   (("M-ö" . neotree-project-dir-toggle)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Archivos de configuración
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Scratch buffer
;; (setq inhibit-startup-message t)
;;       initial-major-mode 'org-mode)

;; Definimos un archivo de configuracion para las modificaciones de emacs
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

;; Keep folders clean (create new directory when not yet existing)
(make-directory (expand-file-name ".emacs_backups/" user-emacs-directory) t)
(setq backup-directory-alist `(("." . ,(expand-file-name ".emacs_backups/" user-emacs-directory))))

;; Backups y autosalvados se graban en carpeta /home/flakito/.emacs.d/auto-save-list/
;; (setq
;;     backup-directory-alist '(("." . "/home/flakito/.emacs.d/auto-save-list/"))
;;     backup-by-copying t
;;     auto-save-file-name-transforms '((".*" "/home/flakito/.emacs.d/auto-save-list/" t))
;;     kept-new-versions 6
;;     kept-old-versions 2
;;     delete-old-versions t
;;     version-control t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Personalizción opciones por defecto
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Destactivar barra de menús por defecto
;; tranquilo pulsando <f10> se acceden a las opciones
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

;; for smooth scrolling and disabling the automatical recentering of emacs when moving the cursor
;; (pixel-scroll-mode 1)


;; Dired mode
;; (define-key dired-mode-map (kbd "<right>") 'dired-find-alternate-file) ; was dired-advertised-find-file
(eval-after-load "dired" '(progn
			    (define-key dired-mode-map (kbd "<right>") 'dired-find-alternate-file)))
(add-hook 'dired-mode-hook
	  (lambda ()
	    (define-key dired-mode-map (kbd "<left>")
	      (lambda () (interactive) (find-alternate-file "..")))
					; was dired-up-directory
	    )
	  )
(put 'dired-find-alternate-file 'disabled nil)

;; Tipo de letra por defecto
(add-to-list 'default-frame-alist '(font . "Inconsolata"))

;; Mostrar siempre el número de columna
(setq column-number-mode t)

;; Highlight the line we are currently on
(global-hl-line-mode 1)

;; Cambiar de ventanas usando S-<right>, S-<left>, S-<up> y S-<down>
(windmove-default-keybindings)

;; Al teclear se sobreescribe la región seleccionada
(delete-selection-mode 1)

;; Borra toda la línea (includo el salto de linea)
(setq kill-whole-line 1)

;; Mantener los buffers actualizados automáticamente
(global-auto-revert-mode t)

;; Mostrar paréntesis coincidentes
(show-paren-mode 1)
(electric-pair-mode)

;; Transforma las pregutnas  yes-or-no en y-or-n
(defalias 'yes-or-no-p 'y-or-n-p)

;; Para programar en python: borra los espacios al final
(add-hook 'before-save-hook 'delete-trailing-whitespace)
