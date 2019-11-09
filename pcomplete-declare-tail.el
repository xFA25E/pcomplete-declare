;;; pcomplete-declare-tail.el --- Completions for tail -*- lexical-binding: t; -*-

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

;;;###autoload (autoload 'pcomplete/tail "pcomplete-declare-tail")
(pcomplete-declare tail
  (F :help "same as --follow=name --retry")
  (q -quiet -silent :help "never output headers giving file names")
  (-retry :help "keep trying to open a file if it is inaccessible")
  (v -verbose :help "always output headers giving file names")
  (z -zero-terminated :help "line delimiter is NUL, not newline")
  (-help :help "display this help and exit")
  (-version :help "output version information and exit")

  &option
  (c -bytes :completions '("NUMBER") :help "\
output the last NUM bytes; or use -c +NUM to output starting with byte
NUM of each file")
  (f -follow :completions '("name" "descriptor") :help "\
output appended data as the file grows; an absent option argument
means 'descriptor'")
  (n -lines :completions '("NUMBER") :help "\
output the last NUM lines, instead of the last 10; or use -n +NUM to
output starting with line NUM")
  (-max-unchanged-stats :completions '("NUMBER") :help "\
with --follow=name, reopen a FILE which has not
changed size after N (default 5) iterations to see if it has been
unlinked or renamed (this is the usual case of rotated log files);
with inotify, this option is rarely useful")
  (-pid :completions (lambda ()
                       (if (file-directory-p "/proc")
                           (directory-files "/proc" nil "\\`[0-9]+\\'")
                         '("PID")))
        :help "with -f, terminate after process ID, PID dies")
  (s -sleep-interval :completions '("NUMBER") :help "\
with -f, sleep for approximately N seconds (default 1.0) between
iterations; with inotify and --pid=P, check process P at least once
every N seconds"))

(provide 'pcomplete-declare-tail)
;;; pcomplete-declare-tail.el ends here
