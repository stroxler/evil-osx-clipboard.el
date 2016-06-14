;;; evil-osx-clipboard.el --- a simple package                     -*- lexical-binding: t; -*-

;; Copyright (C) 2016 Steven Troxler

;; Author: Steven Troxler <steven.troxler@gmail.com>
;; Keywords: lisp
;; Version: 0.0.1

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;  Purpose:
;;
;; For users of evil, provide interactive functions to allow system clipboard
;; copy and paste, assuming that `pbcopy` is off normally.
;;
;; Assuming you set up reasonable keyboard bindings, this behavior is in line
;; line with normal vim use in the terminal or gui: the vim copy and paste
;; commands don't clobber the system clipboard, but the normal copy and paste
;; operators for the terminal for gui apps work.
;;
;; It matters that typical vim yank/paste (emacs kill/yank) commands not
;; clobber the system clipboard if you use a clipboard history manager, since
;; you often have hundreds of small edits within the application.
;;
;; The specific use case this was designed for is spacemacs running in vim
;; or hybrid editing style, with (turn-off-pbcopy) called in the initialization
;; routines. But it should work with a vanilla evil install and pbcopy turned
;; off.
;;
;; Assuming you map commands appropriately, this behavior
;; is in line with what most gui vims or vim in terminals to do - the normal
;; copy and paste commands for either gui or in-terminal environments work
;; for system copy and paste, but the vim registers (emacs kill ring) is not
;; integrated. If you use a clipboard manager like OSX's clipmenu, this is
;; often desirable so that normal editing commands don't clobber your sytem
;; clipboard history
;;
;; Usage:
;;
;; M-x evil-osx-clipboard/copy
;; M-x evil-osx-clipboard/paste
;;
;; You can map these functions to what I think are reasonable defaults for
;; both linux (control-shift-c and control-shift-v) and osx (super-c and
;; super-v) by calling
;;    (evil-osx-clipboard/set-osx-defaults)
;; and/or
;;    (evil-osx-clipboard/set-linux-defaults)
;; in your init scripts.
;;
;; If you prefer custom keybindings or custom modes in which to use the
;; bindings, you can bind them manually.

;;; Code:

;; Note:
;;  I still don't really understand package managment in emacs, and
;;  especially how it interacts with spacemacs.
;;
;;  This use-package call appears to be an incorrect way of ensuring
;;  dependencies load. It throws a warning when you first compile,
;;  but then it does fine as long as your setup does, in fact, include
;;  evil and pbcopy. Interestingly, evil doens't throw a warning, only
;;  pbcopy.
;;
;;  If I change this to require, it errs out on the require to pbcopy,
;;  which might be because the load path isn't set correctly or something.
;;
;;  For the moment, I can live with the warning, but if someone
;;  knows the correct way to do it (perhaps defining all my functions in
;;  a conditional block) then pull requests are welcome.
(use-package pbcopy
  :ensure t)
(use-package evil
  :ensure t)

;;;###autoload
(evil-define-operator evil-osx-clipboard/copy
                      (beg end type register yank-handler)
  "copy to the system clipboard"
  (turn-on-pbcopy)
  (evil-yank beg end type register yank-handler)
  (turn-off-pbcopy)
  )

;;;###autoload
(defun evil-osx-clipboard/paste (&optional arg)
  "paste from the system clipboard"
  (interactive)
  (turn-on-pbcopy)
  (yank arg)
  (turn-off-pbcopy)
  )


;;;###autoload
(defun evil-osx-clipboard/set-osx-defaults ()
  "set control-shift-c/v as copy and paste from system clipboard"
  (interactive)
	(define-key evil-normal-state-map (kbd "s-c") 'evil-osx-clipboard/copy)
	(define-key evil-visual-state-map (kbd "s-c") 'evil-osx-clipboard/copy)
	(define-key evil-insert-state-map (kbd "s-v") 'evil-osx-clipboard/paste)
	(global-set-key (kbd "s-c") 'evil-osx-clipboard/copy)
	(global-set-key (kbd "s-v") 'evil-osx-clipboard/paste)
)

(provide 'evil-osx-clipboard)
;;; evil-osx-clipboard.el ends here
