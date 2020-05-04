;;; pcomplete-declare-abduco.el --- Completions for abduco  -*- lexical-binding: t; -*-

;; Copyright (C) 2020  Valeriy Litkovskyy

;; Author: Valeriy Litkovskyy <valeriy.litkovskyy@mail.polimi.it>
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

(require 'pcomplete-declare)

(defun pcomplete-declare-abduco-list-sessions ()
  "Get abduco sessions."
  (mapcar (lambda (line) (car (last (split-string line))))
          (cdr (split-string (pcomplete-process-result "abduco" "-l")
                             "\n"))))

;;;###autoload (autoload 'pcomplete/abduco "pcomplete-declare-abduco")
(pcomplete-declare abduco
  (v :help "Print version information to standard output and exit.")
  (r :help "Readonly session, i.e. user input is ignored.")
  (f :help "\
Force creation of session when there is an already terminated session of the
same name, after showing its exit status.")
  (l :help "\
Attach with the lowest priority, meaning this client will be the last to control
the size.")

  &option
  (e :completions '("^\\") :help "\
Set the key to detach which by default is set to CTRL+\ i.e. ^\ to detachkey.")
  (c :completions '("NAME")
     :help "Create a new session and attach immediately to it.")
  (n :completions '("NAME")
     :help "Create a new session but do not attach to it.")

  (A :completions #'pcomplete-declare-abduco-list-sessions
     :help "\
Try to connect to an existing session, upon failure create said session and
attach immediately to it.")

  (a :completions #'pcomplete-declare-abduco-list-sessions
     :help "Attach to an existing session.")

  &positional
  (:completions :executable :help "Command to execute."))

(provide 'pcomplete-declare-abduco)
;;; pcomplete-declare-abduco.el ends here
