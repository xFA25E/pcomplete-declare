;;; pcomplete-declare-sxhkd.el --- Completions for sxhkd -*- lexical-binding: t; -*-

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

;;;###autoload (autoload 'pcomplete/sxhkd "pcomplete-declare-sxhkd")
(pcomplete-declare sxhkd
  (h :help "Print the synopsis to standard output and exit.")
  (v :help "Print the version information to standard output and exit.")

  &option
  (m :completions '("COUNT")
     :help "Handle the first COUNT mapping notify events.")
  (t :completions '("TIMEOUT")
     :help "Timeout in seconds for the recording of chord chains.")
  (c :completions :file
     :help "Read the main configuration from the given file.")
  (r :completions :file
     :help "Redirect the commands output to the given file.")
  (s :completions :file
     :help "Output status information to the given FIFO.")
  (a :completions '("ABORTKEYSYM")
     :help "Name of the keysym used for aborting chord chains."))

(provide 'pcomplete-declare-sxhkd)
;;; pcomplete-declare-sxhkd.el ends here
