;;; pcomplete-declare-nl.el --- Completions for nl -*- lexical-binding: t; -*-

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

;;;###autoload (autoload 'pcomplete/nl "pcomplete-declare-nl")
(pcomplete-declare nl
  (p -no-renumber :help "do not reset line numbers for each section")
  (-help :help "display this help and exit")
  (-version :help "output version information and exit")

  &option
  (b -body-numbering :completions '("a" "t" "n" "pBRE") :help "\
use STYLE for numbering body lines
a - number all lines
t - number only nonempty lines
n - number no lines
pBRE - number only lines that contain a match for the basic regular expression, \
BRE")
  (d -section-delimiter :completions '("CC") :help "\
use CC for logical page delimiters
CC are two delimiter characters used to construct logical page delimiters;
a missing second character implies ':'.")
  (f -footer-numbering :completions '("a" "t" "n" "pBRE") :help "\
use STYLE for numbering footer lines
a - number all lines
t - number only nonempty lines
n - number no lines
pBRE - number only lines that contain a match for the basic regular expression, \
BRE")
  (h -header-numbering :completions '("a" "t" "n" "pBRE") :help "\
use STYLE for numbering header lines
a - number all lines
t - number only nonempty lines
n - number no lines
pBRE - number only lines that contain a match for the basic regular expression, \
BRE")
  (i -line-increment :completions '("NUMBER") :help "\
line number increment at each line")
  (l -join-blank-lines :completions '("NUMBER") :help "\
group of NUMBER empty lines counted as one")
  (n -number-format :completions '("ln" "rn" "rz") :help "\
insert line numbers according to FORMAT
ln - left justified, no leading zeros
rn - right justified, no leading zeros
rz - right justified, leading zeros")
  (s -number-separator :completions '("STRING") :help "\
add STRING after (possible) line number")
  (v -starting-line-number :completions '("NUMBER") :help "\
first line number for each section")
  (w -number-width :completions '("NUMBER") :help "\
use NUMBER columns for line numbers"))

(provide 'pcomplete-declare-nl)
;;; pcomplete-declare-nl.el ends here
