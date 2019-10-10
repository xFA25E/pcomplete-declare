;;; pcomplete-declare.el --- Define shell commands declaratively  -*- lexical-binding: t; -*-

;; Copyright (C) 2019

;; Author: xFA25E
;; Keywords: extensions

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; TODO: check for unique flag and option names
;; TODO: write good documentation

;;; Code:

(require 'pcomplete)
(require 'subr-x)

(defun pcomplete-declare-string-in-sequence-p (string sequence)
  ""
  (cl-some (lambda (name) (string-equal string name)) sequence))

(defun pcomplete-declare-maybe-help (message)
  ""
  (when pcomplete-show-help
    (let ((pcomplete-help (list 'identity (or message ""))))
      (pcomplete--help)
      (throw 'pcompleted t))))

(defun pcomplete-declare-make-completions (type)
  ""
  (cond ((eq type :directory)
         (pcomplete-dirs))
        ((eq type :file)
         (pcomplete-entries))
        ((eq type :executable)
         (pcomplete-executables))
        ((functionp (eval type))
         (funcall (eval type)))
        (t
         (eval type))))

(defun pcomplete-declare-name-of-flag-p (name flag)
  ""
  (and (eq (plist-get flag :type) :flag)
       (pcomplete-declare-string-in-sequence-p
        name (plist-get flag :names))))

(defun pcomplete-declare-name-of-option-p (name flag)
  ""
  (and (eq (plist-get flag :type) :option)
       (pcomplete-declare-string-in-sequence-p
        name (plist-get flag :names))))

(defun pcomplete-declare-name-of-subcommand-p (name subcommand)
  ""
  (and (eq (plist-get subcommand :type) :subcommand)
       (string-equal name (plist-get subcommand :name))))

(defun pcomplete-declare-flag-p (arg candidates)
  ""
  (cl-some
   (lambda (candidate)
     (pcomplete-declare-name-of-flag-p arg candidate))
   candidates))

(defun pcomplete-declare-option-p (arg candidates)
  ""
  (cl-some
   (lambda (candidate)
     (pcomplete-declare-name-of-option-p arg candidate))
   candidates))

(defun pcomplete-declare-subcommand-p (arg candidates)
  ""
  (cl-some
   (lambda (candidate)
     (pcomplete-declare-name-of-subcommand-p arg candidate))
   candidates))

(defun pcomplete-declare-remove-flag (arg candidates)
  ""
  (let (removed)
    (cl-values (cl-remove-if
                (lambda (candidate)
                  (when (pcomplete-declare-name-of-flag-p arg candidate)
                    (setq removed candidate)
                    (not (plist-get candidate :multiple))))
                candidates)
               removed)))

(defun pcomplete-declare-remove-option (arg candidates)
  ""
  (let (removed)
    (cl-values (cl-remove-if
                (lambda (candidate)
                  (when (pcomplete-declare-name-of-option-p arg candidate)
                    (setq removed candidate)
                    (not (plist-get candidate :multiple))))
                candidates)
               removed)))

(defun pcomplete-declare-subcommand (arg candidates)
  ""
  (cl-find-if
   (lambda (candidate)
     (pcomplete-declare-name-of-subcommand-p arg candidate))
   candidates))

(defun pcomplete-declare-remove-positional-candidate (candidates)
  ""
  (cl-loop for rest-candidates on candidates
           for candidate = (car rest-candidates)
           if (not (eq (plist-get candidate :type) :positional))
           collect candidate into new-candidates
           else return (cl-values (if (plist-get candidate :multiple)
                                      candidates
                                    (append new-candidates (cdr rest-candidates)))
                                  candidate)
           finally return (cl-values candidates nil)))

(defun pcomplete-declare-make-candidates (candidates)
  ""
  (mapcan (lambda (candidate)
            (cl-copy-list (plist-get candidate :names)))
          candidates))

(defun pcomplete-declare-make-flag-option-completions (candidates)
  ""
  (mapcan (lambda (candidate)
            (when (memq (plist-get candidate :type) '(:flag :option))
              (cl-copy-list (plist-get candidate :names))))
          candidates))

(defun pcomplete-declare-can-complete-positionals-p (candidates)
  ""
  (cl-some
   (lambda (candidate) (eq (plist-get candidate :type) :positional))
   candidates))

(defun pcomplete-declare-can-complete-subcommands-p (candidates)
  ""
  (cl-some
   (lambda (candidate) (eq (plist-get candidate :type) :subcommand))
   candidates))

(defun pcomplete-declare-make-positional-completions (candidates)
  ""
  (cl-loop for candidate in candidates
           if (eq (plist-get candidate :type) :positional)
           return (pcomplete-declare-make-completions
                   (plist-get candidate :completions))))

(defun pcomplete-declare-make-subcommand-completions (candidates)
  ""
  (cl-loop for candidate in candidates
           if (eq (plist-get candidate :type) :subcommand)
           collect (plist-get candidate :name)))

(defun pcomplete-declare-remove-candidates (subcommand)
  ""
  (cl-loop for relement on subcommand
           for element = (car relement)
           if (not (eq element :candidates))
           collect element into result
           else return (append result (cddr relement))))

(defun pcomplete-declare-run-completions (candidates)
  ""
  (let (before-prev prev)
    (while (< pcomplete-index pcomplete-last)
      (setq before-prev prev)

      (let ((arg (pcomplete-arg)))
        (cond ((pcomplete-declare-flag-p arg candidates)
               (cl-destructuring-bind (new-candidates removed)
                   (pcomplete-declare-remove-flag arg candidates)
                 (setq candidates new-candidates
                       prev removed)))

              ((pcomplete-declare-option-p arg candidates)
               (cl-destructuring-bind (new-candidates removed)
                   (pcomplete-declare-remove-option arg candidates)
                 (setq candidates new-candidates
                       prev removed)))

              ((not (eq (plist-get before-prev :type) :option))
               (if (pcomplete-declare-subcommand-p arg candidates)

                   (let ((subcommand (pcomplete-declare-subcommand arg
                                                                   candidates)))
                     (setq before-prev nil
                           candidates (plist-get subcommand :candidates)
                           prev (pcomplete-declare-remove-candidates
                                 subcommand)))

                 (cl-destructuring-bind (new-candidates removed)
                     (pcomplete-declare-remove-positional-candidate candidates)
                   (setq candidates new-candidates
                         prev removed))))

              (t
               (setq prev nil))))

      (pcomplete-next-arg))

    (pcomplete-declare-maybe-help (plist-get prev :help))

    (cond ((eq (plist-get prev :type) :option)
           (throw 'pcomplete-completions
                  (pcomplete-declare-make-completions
                   (plist-get prev :completions))))

          ((pcomplete-match "^-" 'last)
           (throw 'pcomplete-completions
                  (pcomplete-declare-make-flag-option-completions candidates)))

          ((or (pcomplete-declare-can-complete-positionals-p candidates)
               (pcomplete-declare-can-complete-subcommands-p candidates))
           (let ((arg (pcomplete-arg 'last))
                 (subcommand-completions
                  (pcomplete-declare-make-subcommand-completions candidates))
                 (positional-completions
                  (pcomplete-declare-make-positional-completions candidates)))
             (cond
              ((string-empty-p arg)
               (throw 'pcomplete-completions
                      (append subcommand-completions
                              (if (functionp positional-completions)
                                  (all-completions (pcomplete-arg 'last)
                                                   positional-completions)
                                positional-completions))))

              ((try-completion arg subcommand-completions)
               (throw 'pcomplete-completions
                      subcommand-completions))

              (t
               (throw 'pcomplete-completions
                      positional-completions)))))
          (t
           (throw 'pcomplete-completions
                  (pcomplete-all-entries))))))

(defun pcomplete-declare-parse-flag (raw-flag)
  ""
  (let (keyword-found
        names
        (keywords raw-flag)
        (result '(:type :flag)))
    (while (not (or (null keywords) keyword-found))
      (if (keywordp (car keywords))
          (setq keyword-found t)
        (push (concat "-" (symbol-name (car keywords))) names)
        (setq keywords (cdr keywords))))

    (if (null names)
        (error "Empty flag")
      (setq result (cons :names (cons names result))))

    (if-let ((help (plist-get keywords :help)))
        (if (not (stringp help))
            (error "Help property should be a string in %S"
                   (plist-get result :names))
          (setq result (cons :help (cons help result)))))

    (if-let ((multiple (plist-get keywords :multiple)))
        (if (not (booleanp multiple))
            (error "Multiple property should be a boolean in %S"
                   (plist-get result :names))
          (setq result (cons :multiple (cons multiple result)))))
    result))

(defun pcomplete-declare-parse-option (raw-option)
  ""
  (let (keyword-found
        names
        (keywords raw-option)
        (result '(:type :option)))
    (while (not (or (null keywords) keyword-found))
      (if (keywordp (car keywords))
          (setq keyword-found t)
        (push (concat "-" (symbol-name (car keywords))) names)
        (setq keywords (cdr keywords))))

    (if (null names)
        (error "Empty flag")
      (setq result (cons :names (cons names result))))

    (if-let ((help (plist-get keywords :help)))
        (if (not (stringp help))
            (error "Help property should be a string in %S"
                   (plist-get result :names))
          (setq result (cons :help (cons help result)))))

    (if-let ((multiple (plist-get keywords :multiple)))
        (if (not (booleanp multiple))
            (error "Multiple property should be a boolean in %S"
                   (plist-get result :names))
          (setq result (cons :multiple (cons multiple result)))))

    (if-let ((completions (plist-get keywords :completions)))
        (if (not (or (functionp completions)
                     (memq completions '(:directory :file :executable))
                     (listp completions)))
            (error "Completion property should be a function or a list or one of
the following keywords: :directory :file :executable.
In %S" (plist-get result :names))
          (setq result (cons :completions (cons completions result))))
      (error "In option %S should be present a completion flag"
             (plist-get result :names)))

    result))

(defun pcomplete-declare-parse-positional (raw-positional)
  ""
  (let ((keywords raw-positional)
        (result '(:type :positional)))

    (if-let ((help (plist-get keywords :help)))
        (if (not (stringp help))
            (error "Help property should be a string in %S"
                   (plist-get result :names))
          (setq result (cons :help (cons help result)))))

    (if-let ((multiple (plist-get keywords :multiple)))
        (if (not (booleanp multiple))
            (error "Multiple property should be a boolean in %S"
                   (plist-get result :names))
          (setq result (cons :multiple (cons multiple result)))))

    (if-let ((completions (plist-get keywords :completions)))
        (if (not (or (memq completions '(:directory :file :executable))
                     (functionp (eval completions))
                     (listp (eval completions))))
            (error "Completion property should be a function or a list or one of
the following keywords: :directory :file :executable.
In %S" (plist-get result :names))
          (setq result (cons :completions (cons completions result))))
      (error "In option %S should be present a completion flag"
             (plist-get result :names)))

    result))

(defun pcomplete-declare-parse-subcommand (raw-subcommand)
  ""
  (let ((result '(:type :subcommand))
        (body raw-subcommand))

    (if (keywordp (car body))
        (error "Invalid subcommand name %S" (car body))
      (setq result (cons :name (cons (symbol-name (car body)) result))
            body (cdr body)))

    (when (eq (car body) :help)
      (if (not (stringp (cadr body)))
          (error "Subcommand's %S help property should be a string"
                 (plist-get result :name))
        (setq result (cons :help (cons (cadr body) result))
              body (cddr body))))

    (cons :candidates (cons (pcomplete-declare-parse-candidates body) result))))

(defun pcomplete-declare-parse-candidate-group
    (candidates parse-function stop-sequence)
  ""
  (let (result)
    (cl-loop for rcandidate on candidates
             for candidate = (car rcandidate)
             if (consp candidate)
             do (push (funcall parse-function candidate) result)
             else if (memq candidate stop-sequence)
             return (cl-values (cdr rcandidate)
                               result
                               candidate)
             else do (error "Unexpected parameter %S" candidate)
             finally return (cl-values nil result nil))))

(defun pcomplete-declare-parse-candidates (candidates)
  ""
  (let (result
        prev
        (stop-sequence '(&option &positional &subcommand))
        (parse-function #'pcomplete-declare-parse-flag))
    (while (not (null candidates))
      (cl-destructuring-bind (cands res next)
          (pcomplete-declare-parse-candidate-group candidates
                                                   parse-function
                                                   stop-sequence)
        (cl-case next
          (&option
           (setq stop-sequence '(&positional &subcommand)
                 parse-function #'pcomplete-declare-parse-option))
          (&positional
           (setq stop-sequence '(&subcommand)
                 parse-function #'pcomplete-declare-parse-positional))
          (&subcommand
           (setq stop-sequence nil
                 parse-function #'pcomplete-declare-parse-subcommand)))

        (when (eq prev '&positional)
          (let ((mcount (cl-count-if (lambda (c) (plist-get c :multiple)) res)))
            (cond ((< 1 mcount)
                   (error "Too many multiple positional candidates"))
                  ((and (= 1 mcount) (not (plist-get (car res) :multiple)))
                   (error "Only the last positional candidate can be multiple"))))
          (setq res (reverse res)))

        (setq prev next
              candidates cands
              result (append result res))))

    result))

(defun pcomplete-declare-make-function-name (command)
  ""
  (intern (concat "pcomplete/" (symbol-name command))))

;;;###autoload
(defmacro pcomplete-declare (command &rest candidates)
  ""
  (declare (indent defun))
  `(defun ,(pcomplete-declare-make-function-name command) ()
     ,@(if (stringp (car candidates))
           `(,(car candidates)
             (pcomplete-declare-run-completions
              ',(pcomplete-declare-parse-candidates (cdr candidates))))
         `(,(concat "Completions for " (symbol-name command) " command.")
           (pcomplete-declare-run-completions
            ',(pcomplete-declare-parse-candidates candidates))))))

(provide 'pcomplete-declare)
;;; pcomplete-declare.el ends here
