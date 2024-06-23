;;; helm-sx.el --- Helm interface for SX mode.         -*- lexical-binding: t; -*-

;; Copyright (C) 2024, 813gan

;; URL: https://github.com/813gan/helm-sx.el
;; Author: 813gan
;; Keywords: convenience tools helm
;; Version: 1.0
;; Package: helm-sx
;; Package-Requires: (sx helm)

;;; Commentary
;; # helm-sx.el
;;
;; Emacs Helm interface for [sx.el - StackExchange client](https://github.com/vermiculus/sx.el)
;; Once evaluated this file will declare Helm sources and functions for all Stack Exchange forums;
;; sources are called `helm-source-sx-$forum` for example `helm-source-sx-stackoverflow`.
;; helm functions for particular forum are called `helm-sx-$site` eg `helm-sx-stackoverflow`.
;;
;; ## Installation
;;
;; You can just download file `helm-sx.el` and install it using `M-x package-install-file`.
;; [el-get recipe](https://github.com/dimitri/el-get/pull/2949) is also available.

;;; Code:

(require 'sx-search)
(require 'sx-interaction)
(require 'sx-site)
(require 'helm-source)

(defcustom helm-sx-input-idle-delay 0.6
  "`helm-input-idle-delay' used for helm-sx."
  :type 'float
  :group 'helm-net)

(defcustom helm-sx-actions
  '(("Browse question with SX" . sx-open-link)
    ("Browse URL" . browse-url)
    ("Browse URL with EWW" . (lambda (candidate)
			       (eww-browse-url candidate)))
    ("Copy URL to clipboard" . (lambda (candidate)
				 (kill-new  candidate)))
    ("Browse URL with webkit xwidget" . (lambda (candidate)
					  (xwidget-webkit-browse-url candidate))))
  "List of actions for sx-helm sources."
  :group 'helm-sx
  :type '(alist :key-type string :value-type function))


(defun helm-sx--question-alist-to-src-cons (question)
  (let ((title (alist-get 'title question))
	(is_answered (alist-get 'is_answered question))
	(answer_count (alist-get 'answer_count question))
	(link (alist-get 'link question)))
    (cons (format "[%s %i] %s" (if is_answered "+" "x") answer_count title)
	  link) ))

(defun helm-sx-search (sx-helm-forum)
  (mapcar
   'helm-sx--question-alist-to-src-cons
   (sx-search-get-questions sx-helm-forum 1 helm-pattern)))

(defcustom helm-sx-forums
  (sx-site-get-api-tokens)
  "List of Stack Exchange forums."
  :group 'helm-sx
  :type  '(repeat (choice string)))

;; stolen from helm-info
(defun helm-sx-create-sources nil
  "Create helm sources and commands for all SX sites."
  (dolist (site helm-sx-forums)
    (let ((sym (intern (concat "helm-source-sx-" site))))
      (set sym (helm-make-source (concat "helm-sx-" site) 'helm-source-sync
		 :action 'helm-sx-actions
		 :candidates (lambda nil (helm-sx-search site))
		 :requires-pattern 3
		 :nohighlight 't
		 :match '(identity)
		 :volatile 't
		 ))
      (defalias (intern (concat "helm-sx-" site))
	(lambda ()
	  (interactive)
	  (helm :sources sym
		:input-idle-delay helm-sx-input-idle-delay
		:buffer (format "*helm sx %s*" site))) ))))

(helm-sx-create-sources)

(provide 'helm-sx)

;;; helm-sx.el ends here
