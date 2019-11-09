;;; pcomplete-declare-dash.el --- Completions for dash -*- lexical-binding: t; -*-

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

(require 'pcomplete-declare)

;;;###autoload (autoload 'pcomplete/dash "pcomplete-declare-dash")
(pcomplete-declare dash
  (a :help "Export all variables assigned to.")
  (C :help "Don't overwrite existing files with “>”.")
  (e :help "\
If not interactive, exit immediately if any untested command fails. The exit
status of a command is considered to be explicitly tested if the command is used
to control an if, elif, while, or until; or if the command is the left hand
operand of an “&&” or “||” operator.")
  (f :help "Disable pathname expansion.")
  (n :help "
If not interactive, read commands but do not execute them. This is useful for
checking the syntax of shell scripts.")
  (u :help "\
Write a message to standard error when attempting to expand a variable that is
not set, and if the shell is not interactive, exit immediately.")
  (v :help "\
The shell writes its input to standard error as it is read. Use‐ ful for
debugging.")
  (x :help "\
Write each command to standard error (preceded by a ‘+ ’) before it is executed.
Useful for debugging.")
  (I :help "Ignore EOF's from input when interactive.")
  (i :help "Force the shell to behave interactively.")
  (m :help "Turn on job control (set automatically when interactive).")
  (q)
  (V :help "\
Enable the built-in vi(1) command line editor (disables -E if it has been set).")
  (E :help "\
Enable the built-in emacs(1) command line editor (disables -V if it has been
set).")
  (b :help "\
Enable asynchronous notification of background job completion. (UNIMPLEMENTED
for 4.4alpha)")
  (s :help "\
Read commands from standard input (set automatically if no file arguments are
present). This option has no effect when set after the shell has already started
running (i.e. with set).")

  &option
  (o :completions '("errexit" "noglob" "ignoreeof" "interactive"
                    "monitor" "noexec" "stdin" "xtrace" "verbose"
                    "vi" "emacs" "noclobber" "allexport" "notify"
                    "nounset" "nolog" "debug")
     :help "Dash options")
  (c :completions '("COMMANDSTRING") :help "\
Read commands from the command_string operand instead of from the standard
input. Special parameter 0 will be set from the command_name operand and the
positional parameters ($1, $2, etc.) set from the remaining argument operands."))

(provide 'pcomplete-declare-dash)
;;; pcomplete-declare-dash.el ends here
