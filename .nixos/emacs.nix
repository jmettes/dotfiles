{ pkgs ? import <nixpkgs> {} }:

# some day emacs will look as nice as this: https://lepisma.github.io/2017/10/28/ricing-org-mode/

let
  myEmacs = pkgs.emacs;

  # https://nixos.org/nixpkgs/manual/#sec-emacs-config
  myEmacsConfig = pkgs.writeText "default.el" ''
(setq user-full-name "Jonathan Mettes")
(setq user-mail-address "jonathan@jmettes.com")

;; disable welcome splash screen
(setq inhibit-startup-message t)
(setq inhibit-startup-screen nil)

;; hide menu bar
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)

;; font size
(set-face-attribute 'default nil :height 120)

;; marking text
(delete-selection-mode t)
(transient-mark-mode t)
(setq x-select-enable-clipboard t)

;; spaces as tabs
(setq tab-width 2
      indent-tabs-mode nil)

;; disable backup files
(setq make-backup-files nil)

;; keybindings
(global-set-key (kbd "RET") 'newline-and-indent)
(global-set-key (kbd "C-/") 'comment-or-uncomment-region)
(global-set-key (kbd "C-=") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)

;; show parens
(show-paren-mode t)

(require 'use-package)
(package-initialize)

;; set theme to solarized
;;(load-theme 'solarized-dark t)
;;(custom-set-faces (if (not window-system) '(default ((t (:background "nil"))))))

;; set theme to spacemacs
(load-theme 'spacemacs-dark t)

(use-package spaceline
  :demand t
  :init
  (setq powerline-default-separator 'arrow-fade)
  :config
  (require 'spaceline-config)
  (spaceline-spacemacs-theme))

;; disable ring-bell - i find the flashing annoying
(setq ring-bell-function 'ignore)

;; make cursor the width of the character it is under
;; i.e. full width of a TAB
(setq x-stretch-cursor t)

;; fontify code in code blocks
(setq org-src-fontify-natively t)
(setq org-src-tab-acts-natively t)

;; enable babel
(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)
   (gnuplot . t)
   (shell . t)))

;; specific python version
(setq org-babel-python-command "python3.8")

;; run babel without asking
(setq org-confirm-babel-evaluate nil)

 ;; evil-mode
(use-package evil
    :ensure t
    :config
    (evil-mode 1))

;; enable inline images on startup
(setq org-startup-with-inline-images t)

(defun redisplay-images ()
  (when org-inline-image-overlays
     (org-redisplay-inline-images)))

;; refresh inline images before saving
(add-hook 'before-save-hook 'redisplay-images)

;; refresh inline images after running babel
(add-hook 'org-babel-after-execute-hook 'redisplay-images)

;; display inline base64 images
;; https://emacs.stackexchange.com/a/41664

;; EXAMPLE:
;; [[img:iVBORw0KGgoAAAANSUhEUgAAABMAAAAICAYAAAAbQcSUAAAABHNCSVQICAgIfAhkiAAAABxJREFU
;; KFNj/A8EDFQCTFQyB2zMqGGkh+bgDTMAopkEDG8sASwAAA]]
;; then run: M-x org-display-inline-images

(require 'org)
(require 'org-element)
(require 'subr-x) ;; for when-let

(defun org-image-update-overlay (file link &optional data-p refresh)
  "Create image overlay for FILE associtated with org-element LINK.
If DATA-P is non-nil FILE is not a file name but a string with the image data.
If REFRESH is non-nil don't download the file but refresh the image.
See also `create-image'.
This function is almost a duplicate of a part of `org-display-inline-images'."
  (when (or data-p (file-exists-p file))
    (let ((width
       ;; Apply `org-image-actual-width' specifications.
       (cond
        ((not (image-type-available-p 'imagemagick)) nil)
        ((eq org-image-actual-width t) nil)
        ((listp org-image-actual-width)
         (or
          ;; First try to find a width among
          ;; attributes associated to the paragraph
          ;; containing link.
          (let ((paragraph
             (let ((e link))
               (while (and (setq e (org-element-property
                        :parent e))
                   (not (eq (org-element-type e)
                        'paragraph))))
               e)))
        (when paragraph
          (save-excursion
            (goto-char (org-element-property :begin paragraph))
            (when
            (re-search-forward
             "^[ \t]*#\\+attr_.*?: +.*?:width +\\(\\S-+\\)"
             (org-element-property
              :post-affiliated paragraph)
             t)
              (string-to-number (match-string 1))))))
          ;; Otherwise, fall-back to provided number.
          (car org-image-actual-width)))
        ((numberp org-image-actual-width)
         org-image-actual-width)))
      (old (get-char-property-and-overlay
        (org-element-property :begin link)
        'org-image-overlay)))
      (if (and (car-safe old) refresh)
      (image-refresh (overlay-get (cdr old) 'display))
    (let ((image (create-image file
                   (and width 'imagemagick)
                   data-p
                   :width width)))
      (when image
        (let* ((link
            ;; If inline image is the description
            ;; of another link, be sure to
            ;; consider the latter as the one to
            ;; apply the overlay on.
            (let ((parent
               (org-element-property :parent link)))
              (if (eq (org-element-type parent) 'link)
              parent
            link)))
           (ov (make-overlay
            (org-element-property :begin link)
            (progn
              (goto-char
               (org-element-property :end link))
              (skip-chars-backward " \t")
              (point)))))
          (overlay-put ov 'display image)
          (overlay-put ov 'face 'default)
          (overlay-put ov 'org-image-overlay t)
          (overlay-put
           ov 'modification-hooks
           (list 'org-display-inline-remove-overlay))
          (push ov org-inline-image-overlays)
          ov)))))))

(defun org-display-user-inline-images (&optional _include-linked _refresh beg end)
  "Like `org-display-inline-images' but for image data links.
_INCLUDE-LINKED and _REFRESH are ignored.
Restrict to region between BEG and END if both are non-nil.
Image data links have a :image-data-fun parameter.
\(See `org-link-set-parameters'.)
The value of the :image-data-fun parameter is a function
taking the PROTOCOL, the LINK, and the DESCRIPTION as arguments.
If that function returns nil the link is not interpreted as image.
Otherwise the return value is the image data string to be displayed.

Note that only bracket links are allowed as image data links
with one of the formats [[PROTOCOL:LINK]] or [[PROTOCOL:LINK][DESCRIPTION]] are recognized."
  (interactive)
  (when (and (called-interactively-p 'any)
         (use-region-p))
    (setq beg (region-beginning)
      end (region-end)))
  (when (display-graphic-p)
    (org-with-wide-buffer
     (goto-char (or beg (point-min)))
     (when-let ((image-data-link-parameters
     (cl-loop for link-par-entry in org-link-parameters
          with fun
          when (setq fun (plist-get (cdr link-par-entry) :image-data-fun))
          collect (cons (car link-par-entry) fun)))
    (image-data-link-re (regexp-opt (mapcar 'car image-data-link-parameters)))
    (re (format "\\[\\[\\(%s\\):\\([^]]+\\)\\]\\(?:\\[\\([^]]+\\)\\]\\)?\\]"
        image-data-link-re)))
       (while (re-search-forward re end t)
     (let* ((protocol (match-string-no-properties 1))
    (link (match-string-no-properties 2))
    (description (match-string-no-properties 3))
    (image-data-link (assoc-string protocol image-data-link-parameters))
    (el (save-excursion (goto-char (match-beginning 1)) (org-element-context)))
    image-data)
       (when (and el
              (eq (org-element-type el) 'link))
         (setq image-data
           (or (let ((old (get-char-property-and-overlay
                   (org-element-property :begin el)
                   'org-image-overlay)))
             (and old
                  (car-safe old)
                  (overlay-get (cdr old) 'display)))
           (funcall (cdr image-data-link) protocol link description)))
         (when image-data
           (let ((ol (org-image-update-overlay image-data el t t)))
         (when (and ol description)
           (overlay-put ol 'after-string description)))))))))))

(advice-add #'org-display-inline-images :after #'org-display-user-inline-images)

(defun org-inline-data-image (_protocol link _description)
  "Interpret LINK as base64-encoded image data."
  (base64-decode-string link))

(org-link-set-parameters
 "img"
 :image-data-fun #'org-inline-data-image)

(require 'org-download)

(defun org-download-screenshot-img ()
  "Capture screenshot and insert img link with base64 encoded data."
  (interactive)
  (let ((file (expand-file-name org-download-screenshot-file)))
    (shell-command (format org-download-screenshot-method file))
    (insert "[[img:"
            (with-temp-buffer
              (let ((coding-system-for-read 'no-conversion))
                (insert-file-contents file)
                (base64-encode-region (point-min) (point-max) t)
                (buffer-string)))
            "]]"))
  (org-display-user-inline-images))

(defun org-activate-yank-img-links ()
  "Activate keybinding S-C-y for yanking [[img:...]] links in function `org-mode'.
Hook this function into `org-mode-hook'."
  (org-defkey org-mode-map (kbd "S-C-y") #'org-download-screenshot-img))

(add-hook 'org-mode-hook #'org-activate-yank-img-links)


;; indent content under headings
(setq org-startup-indented t)


;; scale up size of latex preview
;; note: previewing latex: c-c c-x c-l
(setq org-format-latex-options (plist-put org-format-latex-options :scale 2.0))

;; automatically render latex on startup
(setq org-startup-with-latex-preview t)

;; automatically toggle latex when cursor exits/enters
(add-hook 'org-mode-hook 'org-fragtog-mode)
'';

  emacsWithPackages = (pkgs.emacsPackagesNgGen myEmacs).emacsWithPackages;
in

  emacsWithPackages (epkgs: (with epkgs; [
    (pkgs.runCommand "default.el" {} ''
mkdir -p $out/share/emacs/site-lisp
cp ${myEmacsConfig} $out/share/emacs/site-lisp/default.el
'')
    org
    org-download
    gnuplot-mode
    gnuplot
    spacemacs-theme
    spaceline
    org-fragtog
  ]) ++ (with epkgs.melpaStablePackages; [
    magit
    use-package
    #solarized-theme
    nix-mode
    python-mode
    evil
    better-defaults
  ]) ++ [
    # pkgs.notmuch
  ])
