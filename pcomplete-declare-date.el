;;; pcomplete-declare-date.el --- Completions for date -*- lexical-binding: t; -*-

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

;;;###autoload (autoload 'pcomplete/date "pcomplete-declare-date")
(pcomplete-declare date
  (-debug :help "\
annotate the parsed date, and warn about questionable usage to stderr")
  (R -rfc-email :help "\
output date and time in RFC 5322 format. Example: Mon, 14 Aug 2006
02:34:56-0600")
  (u -utc -universal :help "print or set Coordinated Universal Time (UTC)")
  (-help :help "display this help and exit")
  (-version :help "output version information and exit")

  &option
  (d -date :completions '("STRING")
     :help "display time described by STRING, not 'now'")
  (f -file :completions :file
     :help "like --date; once for each line of DATEFILE")
  (I -iso-8601 :completions '("date" "hours" "minutes" "seconds" "ns")
     :help "\
output date/time in ISO 8601 format. FMT='date' for date only (the
default), 'hours', 'minutes', 'seconds', or 'ns' for date and time to
the indicated precision. Example: 2006-08-14T02:34:56-06:00")
  (-rfc-3339 :completions '("date" "seconds" "ns") :help "\
output date/time in RFC 3339 format. FMT='date', 'seconds', or 'ns'
for date and time to the indicated precision. Example: 2006-08-14
02:34:56-06:00")
  (r -reference :completions :file
     :help "display the last modification time of FILE")
  (s -set :completions '("STRING")
     :help "set time described by STRING"))

(provide 'pcomplete-declare-date)
;;; pcomplete-declare-date.el ends here
