;;; lark-mode.el --- Major mode for Lark EBNF Syntax  -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2021 Rohan Goyal
;;
;; Author: Rohan Goyal  <https://github.com/rohan-goyal>
;; Maintainer: Rohan Goyal  <goyal.rohan.03@gmail.com>
;; Created: November 15, 2021
;; Modified: November 15, 2021
;; Version: 0.0.1
;; Homepage: https://github.com/Rohan-Goyal/lark-mode
;;
;; This file is not part of GNU Emacs.
;;; Commentary:
;;      A little hackish. Handles syntax highlighting, comments
;;
;;
;;
;;; Code:
;; (defun lark-indent-line ()
;;   "Indent a lark line."
;;   (interactive)
;;   (beginning-of-line)
;;   ;; (message "Hello World")
;;   (if (bobp)  ; Check for rule 1
;;       (indent-line-to 0)
;;     (let ((cur-indent 0))
;;       (if (looking-at "|")
;;           (progn
;;             (save-excursion
;;               (forward-line -1)
;;               (beginning-of-line)
;;               (if (looking-at lark-definition)
;;                   (progn (setq cur-indent (+ (current-indentation) (search-forward ":")))(message (search-forward ":")))
;;                                         ; NOTE: Ideally should indent to colon position. Fix that later
;;                 (setq cur-indent (current-indentation))))))
;;       (indent-line-to cur-indent))))
;; If a line starts with |, check line above.
;; If line above includes a definition (regex-checked), indent to after the first colon.
                                        ;
;; Else, no indentation - start at first column.
;;
;; TODO


(defvar lark-indent-line 'indent-relative)

(defvar lark-mode-map)

(defmacro lark-symbol-def (charclass)
  "Abstraction for terminals and rules, match against CHARCLASS."
  `(rx bol
       (group (? "?"))
       (group (+ (any ,charclass digit "_")))
       (group ":")))

(defvar lark-definition
  (lark-symbol-def alphabetic))

(defvar lark-rule-name
  (lark-symbol-def lower))

(defvar lark-terminal-name
  (lark-symbol-def upper))

;; (defvar lark-definition
  ;; (lark-symbol-def letter))

(defvar lark-regex
  (rx "/" (+ nonl) "/" (* (any "imslux"))))

;; (defvar lark-string ; FIXME?
;;   (rx "\"" (* nonl) "\"" (? "i"))) ; i makes it case-insensitive

;; (defvar lark-string
;;   "\\(\"\\|'\\)[^\\1]+?\\1")

(defvar lark-string
  (rx (seq (group (or "\"" "'")) (*\? (not (any "1\\"))) (backref 1))))

(defvar lark-builtin
  (rx "%" (or "import" "declare" "override" "ignore" "extend")))

(defvar lark-comment
  (rx bol (group "//") (group (* nonl)) line-end))

; (defvar lark-builtin

;   (regexp-opt '("%import" "%declare" "%override" "%ignore" "%extend")))


(defvar lark-specialchar
  (rx (or "|" "+" "*" "?" "~")))

(defvar lark-alias
  (rx (zero-or-more blank "->" bow)
      (group (+ alnum))))
;; Regexes work, verified using highlight in lab12.lark

(defconst lark-font-lock-words
  `(
    (,lark-definition (1 font-lock-keyword-face) (2 font-lock-type-face) (3 font-lock-keyword-face))
                                        ; Symbol definition name.
                                        ; Treat the symbol itself, the optional ?, and the required : differently
    (,lark-regex . font-lock-constant-face)
    (,lark-string . font-lock-string-face)
    (,lark-builtin . font-lock-builtin-face)
    (,lark-specialchar . font-lock-keyword-face)
    (,lark-alias . font-lock-variable-name-face)
    (,lark-comment (1 font-lock-comment-delimiter-face) (2 font-lock-comment-face ))))

(defvar lark-mode-syntax-table
  (let ((st (make-syntax-table)))
    (modify-syntax-entry ?_ "w" st)
    ;; (modify-syntax-entry ?# "<" st)
    (modify-syntax-entry ?/ ". 12" st)
    (modify-syntax-entry ?\n ">" st)
   st))

;;;###autoload
(define-derived-mode lark-mode bnf-mode "Lark Syntax"
  "Major mode for editing Python Lark EBNF notation"
  (setq font-lock-defaults '((lark-font-lock-words)))
  (setq comment-start "//")
  ;; (setq comment-end "\n")
  (set-syntax-table lark-mode-syntax-table))


;;;###autoload
(add-to-list 'auto-mode-alist '("\\.lark\\'" . lark-mode))
(provide 'lark-mode)
;;; lark-mode.el ends here
