;;; pcomplete-declare-uniq.el --- Completions for uniq -*- lexical-binding: t; -*-

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

;;;###autoload (autoload 'pcomplete/uniq "pcomplete-declare-uniq")
(pcomplete-declare uniq
  (c -count :help "prefix lines by the number of occurrences")
  (d -repeated :help "only print duplicate lines, one for each group")
  (D :help "print all duplicate lines")
  (i -ignore-case :help "ignore differences in case when comparing")
  (u -unique :help "only print unique lines")
  (z -zero-terminated :help "line delimiter is NUL, not newline")
  (-help :help "display this help and exit")
  (-version :help "output version information and exit")

  &option
  (-all-repeated :completions '("none" "prepend" "separate") :help "\
like -D, but allow separating groups with an empty line;
METHOD={none(default),prepend,separate}")
  (f -skip-fields :completions '("NUMBER")
     :help "avoid comparing the first N fields")
  (-group :completions '("separate" "prepend" "append" "both") :help "\
show all items, separating groups with an empty line;
METHOD={separate(default),prepend,append,both}")
  (s -skip-chars :completions '("NUMBER") :help "\
avoid comparing the first N characters")
  (w -check-chars :completions '("NUMBER") :help "\
compare no more than N characters in lines"))

(provide 'pcomplete-declare-uniq)
;;; pcomplete-declare-uniq.el ends here
