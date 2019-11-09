;;; pcomplete-declare-head.el --- Completions for head -*- lexical-binding: t; -*-

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

;;;###autoload (autoload 'pcomplete/head "pcomplete-declare-head")
(pcomplete-declare head
  (q -quiet -silent :help "\
never print headers giving file names")
  (v -verbose :help "\
always print headers giving file names")
  (z -zero-terminated :help "\
line delimiter is NUL, not newline")
  (-help :help "display this help and exit")
  (-version :help "output version information and exit")

  &option
  (c -bytes :completions '("NUMBER") :help "\
print the first NUM bytes of each file;
with the leading '-', print all but the last NUM bytes of each file")
  (n -lines :completions '("NUMBER") :help "\
print the first NUM lines instead of the first 10;
with the leading '-', print all but the last NUM lines of each file"))

(provide 'pcomplete-declare-head)
;;; pcomplete-declare-head.el ends here
