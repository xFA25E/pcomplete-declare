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

(defun pcomplete-declare-rimer-timer-names ()
  "Get current running timer names."
  (let ((result (pcomplete-process-result "rimer" "remote" "report")))
    (if (string-empty-p result)
        (list "TIMER")
      (cl-loop for line in (split-string result "\n")
               collect (first (split-string line " "))))))

;;;###autoload (autoload 'pcomplete/rimer "pcomplete-declare-rimer")
(pcomplete-declare rimer
  (h -help :help "Prints help information")
  (V -version :help "Prints version information")

  &subcommand
  (help :help "Prints this message or the help of the given subcommand(s)"
        &positional
        (:completions '("help" "daemon" "remote")
                      :help "The subcommand whose help message to display"))
  (daemon :help "Starts main background process"
          &positional
          (:completions :executable :help "\
Updater is a program that will be executed on every timer step (see remote
subcommand). This program should take 4 command line arguments in the following
order:

$ <UPDATER> <name> <kind> <time elapsed> <duration> <state>

State can be \"running\", \"paused\" or \"halted\" Kind can be \"countdown\" or
\"stopwatch\". In case the kind is a \"stopwatch\" the duration will be a max
u64. It's okey because max u64 is bigger than the human lifetime."))

  (remote :help "\
This subcommand manages main rimer process. It can add, pause, resume and halt
timers."
          &option
          (d -duration :completions '("SECS") :help "Seconds to run")
          (s -step :completions '("SECS") :help "\
Updater is executed every <SECS> seconds [default: 10]")

          &positional
          (:completions '("stopwatch" "countdown" "pause" "halt" "resume"
                          "report" "quit")
                        :help "Remote command")
          (:completions #'pcomplete-declare-rimer-timer-names
                        :help "Timer name")))

(provide 'pcomplete-declare-rimer)
;;; pcomplete-declare-rimer.el ends here
