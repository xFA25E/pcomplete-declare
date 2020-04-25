;;; pcomplete-declare-rimer.el --- completions for rimer  -*- lexical-binding: t; -*-

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

(eval-and-compile
  (defun pcomplete-declare-rimer-timer-names ()
    "Get current running timer names."
    (let ((result (pcomplete-process-result "rimer" "report")))
      (if (string-empty-p result)
          (list "TIMER")
        (cl-loop for line in (split-string result "\n")
                 collect (first (split-string line " ")))))))

;;;###autoload (autoload 'pcomplete/rimer "pcomplete-declare-rimer")
(pcomplete-declare rimer
  (-help :help "Prints help information")
  (-version :help "Prints version information")
  &option
  (-name :completions #'pcomplete-declare-rimer-timer-names :help "Timer name")
  (-duration :completions '("SECS") :help "Seconds to run")
  (-step :completions '("SECS") :help "\
Updater is executed every <SECS> seconds [default: 10]")
  &positional
  (:completions '("start" "add" "pause" "halt" "resume" "report" "quit")
                :help "Command")
  (:completions :executable :help "\
Updater is a program that will be executed on every timer step. This
program should take 4 command line arguments in the following order:

$ <UPDATER> <name> <elapsed time> <total duration> <state>

State can be \"running\", \"paused\" or \"halted\""))

(provide 'pcomplete-declare-rimer)
;;; pcomplete-declare-rimer.el ends here
