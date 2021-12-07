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
;;      A little hackish, but it handles syntax highlighting and comments fairly well.
;;
;;
;;
;;; Code:
(defvar lark-indent-line 'indent-relative) ;; Works well, honestly

(defvar lark-mode-map)                  ;; If we want to add keybindings later, we can.

(defmacro lark-symbol-def (charclass)
  "Abstraction for terminals and rules, match against CHARCLASS.
        Match symbol and syntax characters separately."
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

(defvar lark-regex
  (rx "/" (+ nonl) "/" (* (any "imslux"))))

(defvar lark-string
  (rx (seq (group (or "\"" "'")) (*\? (not (any "1\\"))) (backref 1))))

(defvar lark-builtin
  (rx "%" (or "import" "declare" "override" "ignore" "extend")))

(defvar lark-comment
  (rx bol (group "//") (group (* nonl)) line-end))

(defvar lark-specialchar
  (rx (or "|" "+" "*" "?" "~")))

(defvar lark-alias
  (rx (zero-or-more blank "->" bow)
      (group (+ alnum))))
;; Regexes work, verified using highlight in lab12.lark

(defconst lark-font-lock-words
;; Symbol definition name.
;;Treat the symbol itself, the optional ?, and the required : differently
  `(
    (,lark-definition (1 font-lock-keyword-face) (2 font-lock-type-face) (3 font-lock-keyword-face))
    (,lark-regex . font-lock-constant-face)
    (,lark-string . font-lock-string-face)
    (,lark-builtin . font-lock-builtin-face)
    (,lark-specialchar . font-lock-keyword-face)
    (,lark-alias . font-lock-variable-name-face)
    (,lark-comment (1 font-lock-comment-delimiter-face) (2 font-lock-comment-face ))))

(defvar lark-mode-syntax-table
  (let ((st (make-syntax-table)))
    (modify-syntax-entry ?_ "w" st)
    (modify-syntax-entry ?/ ". 12" st)
    (modify-syntax-entry ?\n ">" st)
    st))

;;;###autoload
(define-derived-mode lark-mode bnf-mode "Lark Syntax"
  "Major mode for editing Python Lark EBNF notation"
  (setq font-lock-defaults '((lark-font-lock-words)))
  (setq comment-start "//")
  (set-syntax-table lark-mode-syntax-table))


;;;###autoload
(add-to-list 'auto-mode-alist '("\\.lark\\'" . lark-mode))
(provide 'lark-mode)
;;; lark-mode.el ends here
