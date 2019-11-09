;;; pcomplete-declare-echo.el --- Completions for echo -*- lexical-binding: t; -*-

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

;;;###autoload (autoload 'pcomplete/echo "pcomplete-declare-echo")
(pcomplete-declare echo
  (n :help "do not output the trailing newline")
  (e :help "enable interpretation of backslash escapes")
  (E :help "disable interpretation of backslash escapes (default)")
  (-help :help "display this help and exit")
  (-version :help "output version information and exit"))

(provide 'pcomplete-declare-echo)
;;; pcomplete-declare-echo.el ends here
