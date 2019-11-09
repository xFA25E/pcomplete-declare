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

;;

;;; Code:

(require 'pcomplete)
(require 'subr-x)

(defun pcomplete-declare-string-in-sequence-p (string sequence)
  "Check if `STRING' is in `SEQUENCE'."
  (cl-some (lambda (name) (string-equal string name)) sequence))


(defun pcomplete-declare-display-help-buffer (help)
  "Display `HELP' message in a window."
  (with-current-buffer-window
   "*Pcomplete Declare Help*" nil nil
   (insert help)
   (special-mode)))

(defun pcomplete-declare-maybe-help (message)
  "Show help `MESSAGE' if `pcomplete-help' was called."
  (when pcomplete-show-help
    (let ((pcomplete-help
           (if (<= (count ?\n message) 10)
               (list 'identity (or message ""))
             (list 'pcomplete-declare-display-help-buffer (or message "")))))
      (pcomplete--help)
      (throw 'pcompleted t))))

(defun pcomplete-declare-make-completions (type)
  "Make completions auto of :completions property in a candidate.
`TYPE' can be:
- :directory
- :file
- :executable
- a function (or lambda) that returns a list of strings
- a list of strings, or a symbol of variable with a list of strings"
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
  "Check if the `FLAG' is a valid flag candidate and contain `NAME' name."
  (and (eq (plist-get flag :type) :flag)
       (pcomplete-declare-string-in-sequence-p
        name (plist-get flag :names))))

(defun pcomplete-declare-name-of-option-p (name option)
  "Check if the `OPTION' is a valid option candidate and contain `NAME' name."
  (and (eq (plist-get option :type) :option)
       (pcomplete-declare-string-in-sequence-p
        name (plist-get option :names))))

(defun pcomplete-declare-name-of-subcommand-p (name subcommand)
  "Check if the `SUBCOMMAND' is a valid subcommand and has a `NAME' name."
  (and (eq (plist-get subcommand :type) :subcommand)
       (string-equal name (plist-get subcommand :name))))

(defun pcomplete-declare-flag-p (arg candidates)
  "Check if `ARG' is a flag in `CANDIDATES'."
  (cl-some
   (lambda (candidate)
     (pcomplete-declare-name-of-flag-p arg candidate))
   candidates))

(defun pcomplete-declare-option-p (arg candidates)
  "Check if `ARG' is an option in `CANDIDATES'."
  (cl-some
   (lambda (candidate)
     (pcomplete-declare-name-of-option-p arg candidate))
   candidates))

(defun pcomplete-declare-subcommand-p (arg candidates)
  "Check if `ARG' is a subcommand in `CANDIDATES'."
  (cl-some
   (lambda (candidate)
     (pcomplete-declare-name-of-subcommand-p arg candidate))
   candidates))

(defun pcomplete-declare-remove-flag (arg candidates)
  "Remove flag `ARG' from `CANDIDATES'.
Return a list. First element of a list is a new candidate
sequence without a `ARG' flag. Second element is removed flag"
  (let (removed)
    (cl-values (cl-remove-if
                (lambda (candidate)
                  (when (pcomplete-declare-name-of-flag-p arg candidate)
                    (setq removed candidate)
                    (not (plist-get candidate :multiple))))
                candidates)
               removed)))

(defun pcomplete-declare-remove-option (arg candidates)
  "Remove option `ARG' from `CANDIDATES'.
Return a list. First element of a list is a new candidate
sequence without a `ARG' flag. Second element is removed flag"
  (let (removed)
    (cl-values (cl-remove-if
                (lambda (candidate)
                  (when (pcomplete-declare-name-of-option-p arg candidate)
                    (setq removed candidate)
                    (not (plist-get candidate :multiple))))
                candidates)
               removed)))

(defun pcomplete-declare-subcommand (arg candidates)
  "Return subcommand candidate with name `ARG' from `CANDIDATES'."
  (cl-find-if
   (lambda (candidate)
     (pcomplete-declare-name-of-subcommand-p arg candidate))
   candidates))

(defun pcomplete-declare-remove-positional-candidate (candidates)
  "Remove next positional candidate from `CANDIDATES'.
Return a list. First element is a new candidate sequence with
next positional candidate removed. Second element is removed candidate"
  (cl-loop for rest-candidates on candidates
           for candidate = (car rest-candidates)
           if (not (eq (plist-get candidate :type) :positional))
           collect candidate into new-candidates
           else return (cl-values (if (plist-get candidate :multiple)
                                      candidates
                                    (append new-candidates (cdr rest-candidates)))
                                  candidate)
           finally return (cl-values candidates nil)))

(defun pcomplete-declare-make-flag-option-completions (candidates)
  "Make a list with flag and option names out of `CANDIDATES'."
  (mapcan (lambda (candidate)
            (when (memq (plist-get candidate :type) '(:flag :option))
              (cl-copy-list (plist-get candidate :names))))
          candidates))

(defun pcomplete-declare-can-complete-positionals-p (candidates)
  "Check if there are any positional candidates in `CANDIDATES'."
  (cl-some
   (lambda (candidate) (eq (plist-get candidate :type) :positional))
   candidates))

(defun pcomplete-declare-can-complete-subcommands-p (candidates)
  "Check if there are any subcommand candidates in `CANDIDATES'."
  (cl-some
   (lambda (candidate) (eq (plist-get candidate :type) :subcommand))
   candidates))

(defun pcomplete-declare-make-positional-completions (candidates)
  "Make a completion list of next positional candidate in `CANDIDATES'."
  (cl-loop for candidate in candidates
           if (eq (plist-get candidate :type) :positional)
           return (pcomplete-declare-make-completions
                   (plist-get candidate :completions))))

(defun pcomplete-declare-make-subcommand-completions (candidates)
  "Make a completion list of possible subcommand candidates in `CANDIDATES'."
  (cl-loop for candidate in candidates
           if (eq (plist-get candidate :type) :subcommand)
           collect (plist-get candidate :name)))

(defun pcomplete-declare-remove-candidates (subcommand)
  "Remove :candidates property from `SUBCOMMAND'."
  (cl-loop for relement on subcommand
           for element = (car relement)
           if (not (eq element :candidates))
           collect element into result
           else return (append result (cddr relement))))

(defun pcomplete-declare-run-completions (candidates)
  "Main function of `pcomplete-declare' macro.
This function provides all the completions on `CANDIDATES'"
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
  "Parse `RAW-FLAG' candidate declared by user.
Throws an error if the format is invalid"
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
  "Parse `RAW-OPTION' candidate declared by user.
Throws an error if the format is invalid"
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
  "Parse `RAW-POSITIONAL' candidate declared by user.
Throws an error if the format is invalid"
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
  "Parse `RAW-SUBCOMMAND' candidate declared by user.
Throws an error if the format is invalid"
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
  "Parse raw candidate group declared by user from `CANDIDATES'.
The group parsing ends when one of the symbols in `STOP-SEQUENCE'
is encountered. Every raw candidate in a group is passed to
`PARSE-FUNCTION'"
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

(defun pcomplete-declare-validate-unique-flags-options (candidates)
  "Ensures that all the flag and option names in `CANDIDATES' are unique."
  (let ((completions (pcomplete-declare-make-flag-option-completions
                      candidates)))
    (when (/= (length completions)
              (length (cl-remove-duplicates completions
                                            :test #'string-equal)))
      (error "Duplicate options or flags!")))

  (let ((subcommands (pcomplete-declare-make-subcommand-completions
                      candidates)))
    (dolist (subcommand subcommands)
      (pcomplete-declare-validate-unique-flags-options
       (plist-get (pcomplete-declare-subcommand subcommand candidates)
                  :candidates)))))

(defun pcomplete-declare-parse-candidates (candidates)
  "Main parse `CANDIDATES' function.
It returnes new candidates in the format required by the
`pcomplete-declare-run-completions'"
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

    (pcomplete-declare-validate-unique-flags-options result)

    result))

(defun pcomplete-declare-make-function-name (command)
  "Make new function name from `COMMAND' in a format required by `pcomplete'."
  (intern (concat "pcomplete/" (symbol-name command))))

;;;###autoload
(defmacro pcomplete-declare (command &rest candidates)
  "Define pcomplete completions in a declarative way.
`COMMAND' is a command for which the completions will be created.
It can be either 'command' or 'major-mode/command' (as required
by `pcomplete')

For `CANDIDATES' there is a particular syntax. More examples in
/pcomplete-declare-completions.el/ file.

Example:
\(pcomplete-declare mycommand
  \"This defines completion for mycommand\"
  (o -option-long :help \"my flag help\")
  (-boolean-flag :help \"help message\" :multiple t)
  &option
  (f :completions :file)
  (c -custom-option -alias-for-custom :completions '(\"bong\" \"wong\"))
  (d -directory-long :multiple t :completions :directory)
  (w -why-not-function :multiple t :completions #'some-function)
  &positional
  (:completions :executable :help \"take an executable\")
  (:completions :file :multiple t)
  &subcommand
  (subcommand1 :help \"hello\"
               (t -tig-tog :multiple t)
               &option
               (e :completions :executable)
               &positional
               (:completions :executable)
               (:completions :directory :multiple t))
  (subcommand2 (-my-flag)))

Doc-string is /optional/

Candidates *MUST* be defined in the following order:
flags -> options -> positional arguments -> subcommands

For flags and options you *MUST* omit the leading dash (=-=)

You can optionally add a ~:help~ property to any candidate with a
string which can be displayed by calling ~pcomplete-help~ command

You can start defining flags right after command name. The syntax is
this:

\(NAME1 NAME2 .. NAMEN [:help STRING] [:multiple BOOL])
\(NAME1 NAME2 .. NAMEN [:help STRING] [:multiple BOOL])
...

All the names are aliases of the same flag. This enables support for
short and long flags. If the macro encounters a ~(b -bool-flag)~, it
will interpret it as ~(\"-b\" \"--bool-flag\")~

~:multiple~ property allows a candidate to be completed multiple
times. Otherwise, it will be removed from completion list if the
flag is already in the command arguments.

An option is like a flag, but it takes an argument. To define an
option, you *MUST* start with the ~&option~ symbol (like in the example
above). The option syntax is the same as the flag syntax, except
that it takes a *MANDATORY* property ~:completions~ which will specify
option's argument completion.
&option
\(NAME1 NAME2 .. NAMEN :completions TYPE [:help STRING] [:multiple BOOL])
\(NAME1 NAME2 .. NAMEN :completions TYPE [:help STRING] [:multiple BOOL])
...

~:completions TYPE~ can be:
- One of the following keywords:
  + ~:directory~  - completes for directory
  + ~:file~ - completes for any file
  + ~:executable~ - completes for executables
- A function that returns a list of strings
- A list of strings (or a variable with list of strings)

You can define positional arguments. Those are the arguments that
*MUST* follow specific order. To define these, you *MUST* start with
~&positional~ symbol

&positional
\(:completions TYPE [:help STRING])
\(:completions TYPE [:help STRING])
...
\(:completions TYPE [:help STRING] [:multiple BOOL])

~:completions~ property is the same as in options. Also, only the last
positional argument is allowed to be ~:multiple~.

You can, also, define subcommands (like =git add|commit=). Usually
subcommands have their own set of flags, options, positionals and
subcommands. As soon as, ~pcomplete-declare~ detects that a subcommand
was given as argument, it removes all previous completion candidates
and leaves only the subcommand ones.

Subcommands start with ~&subcommand~ symbol.

&subcommand
\(subcommand1 [:help STRING]
             candidates...)
\(subcommand2 [:help STRING]
             candidates...)
...

Subcommand candidates follow the same syntax (look example)."

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
