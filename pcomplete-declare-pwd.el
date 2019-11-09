;;; pcomplete-declare-pwd.el --- Completions for pwd -*- lexical-binding: t; -*-

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

;;;###autoload (autoload 'pcomplete/pwd "pcomplete-declare-pwd")
(pcomplete-declare pwd
  (L -logical :help "\
use PWD from environment, even if it contains symlinks")
  (P -physical :help "avoid all symlinks")
  (-help :help "display this help and exit")
  (-version :help "output version information and exit"))

(provide 'pcomplete-declare-pwd)
;;; pcomplete-declare-pwd.el ends here
