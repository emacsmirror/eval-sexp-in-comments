;;; eval-sexp-in-comments.el --- evaluate sexps in comments

;; Copyright (C) 2001  Alex Schroeder

;; This program is free software: you can redistribute it and/or modify it under
;; the terms of the GNU General Public License as published by the Free Software
;; Foundation, either version 3 of the License, or (at your option) any later
;; version.
;;
;; This program is distributed in the hope that it will be useful, but WITHOUT
;; ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
;; FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
;; details.
;;
;; You should have received a copy of the GNU General Public License along with
;; GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.

;; Emacs Lisp Archive Entry
;; Filename: eval-sexp-in-comments.el
;; Version: 1.0.0
;; Keywords: lisp
;; Author: Alex Schroeder <alex@gnu.org>
;; Maintainer: Alex Schroeder <alex@gnu.org>
;; Created: 2001-01-07
;; Description: evaluate sexps in comments
;; URL: https://github.com/kensanata/eval-sexp-in-comments
;; Compatibility: Emacs20, XEmacs21

;; `eval-last-sexp-in-comments' attempts to evaluate the last sexp using
;; `eval-last-sexp' (the latter usually being on C-x C-e).  If that
;; raises an error, however, `eval-last-sexp-in-comments' will try to
;; uncomment the last sexp in a temporary buffer and evaluate
;; `eval-last-sexp' there.  This is usefull when you have commented
;; debugging code in you elisp files, which you want to use.  Instead of
;; uncommenting the region, hitting C-x C-e, and commenting the stuff
;; again when you are done, just redefine C-x C-e, such that
;; `eval-last-sexp-in-comments' is called instead of `eval-last-sexp'.

;; Test by evaluating all the following expressions while they are
;; commented.  Some of them are supposed to work, others not.

;; (let ((str "Commented sexp works"))
;;    (message str))
;; (let ((str "Commented sexp works with nested comment"))
;;    ;; nested comment!
;;    (message str))
;; (let ((str "Commented sexp works with empty commented lines"))
;;
;;    (message str))
;; (let ((str "This does not work due to garbage"))
;;    garbage!
;;    (message str))
; (let ((str "This does not work due to different indentation"))
;;    (message str))
;;; (let ((str "This does not work due to different indentation"))
;;    (message str))

(defun eval-last-sexp-in-comments (stuff)
  "Evaluate sexp before point; print value in minibuffer.
With argument, print output into current buffer.
This works even if the sexp before point is commented out."
  (interactive "P")
  (condition-case var
      (eval-last-sexp stuff)
    (error
     (save-excursion
       (let ((start (point))
	     end comment-intro str)
	 (setq end (progn
		     (beginning-of-line)
		     (if (not (looking-at "^\\s *;+"))
			 (signal (car var) (cdr var))
		       (setq comment-intro (concat "^" (match-string 0) "[^;]"))
		       (while (and (forward-line -1)
				   (looking-at comment-intro)))
		       (if (not (looking-at comment-intro))
			 (forward-line 1))
		       (point)))
	       str (buffer-substring-no-properties start end))
	 (with-temp-buffer
	   (insert str)
	   (message str)
	   (goto-char (point-min))
	   (while (re-search-forward comment-intro nil t)
	     (replace-match ""))
	   (goto-char (point-max))
	   (eval-last-sexp stuff)))))))

(define-key emacs-lisp-mode-map (kbd "C-x C-e") 'eval-last-sexp-in-comments)

(provide 'eval-sexp-in-comments)
;;; eval-sexp-in-comments.el ends here
