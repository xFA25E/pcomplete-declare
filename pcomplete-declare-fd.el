;;; pcomplete-declare-fd.el --- Completions for fd -*- lexical-binding: t; -*-

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

;;;###autoload (autoload 'pcomplete/fd "pcomplete-declare-fd")
(pcomplete-declare fd
  (H -hidden :help "\
Include hidden files and directories in the search results (default:
hidden files and directories are skipped).")
  (I -no-ignore :help "\
Show search results from files and directories that would otherwise be
ignored by .gitignore, .ignore or .fdignore files.")
  (-no-ignore-vcs :help "\
Show search results from files and directories that would otherwise be
ignored by .gitignore files.")
  (s -case-sensitive :help "\
Perform a case-sensitive search. By default, fd uses case-insensitive
searches, unless the pattern contains an uppercase character (smart
case).")
  (i -ignore-case :help "\
Perform a case-insensitive search. By default, fd uses
case-insensitive searches, unless the pattern contains an uppercase
character (smart case).")
  (F -fixed-strings :help "\
Treat the pattern as a literal string instead of a regular expression.")
  (a -absolute-path :help "\
Shows the full path starting from the root as opposed to relative
paths.")
  (L -follow :help "\
By default, fd does not descend into symlinked directories. Using this
flag, symbolic links are also traversed.")
  (p -full-path :help "\
By default, the search pattern is only matched against the filename
(or directory name). Using this flag, the pattern is matched against
the full path.")
  (\0 -print0 :help "\
Separate search results by the null character (instead of newlines).
Useful for piping results to xargs.")
  (-show-errors :help "\
Enable the display of filesystem errors for  situations  such  as  insufficient
permissions or dead symlinks.")
  (h -help :help "Print help information.")

  &option
  (d -max-depth :completions '("NUMBER") :help "\
Limit directory traversal to at most d levels of depth. By default,
there is no limit on the search depth.")
  (t --type
     :completions '("file" "directories" "symlink" "executable" "empty")
     :multiple t :help "\
Filter search by type:
f, file - regular files
d, directories - directories
l, symlink - symbolic links
x, executable - executable (files)
e, empty - empty files or directories
This option can be used repeatedly to allow for multiple file types.")
  (e -extension :completions '("EXTENSION") :multiple t :help "\
Filter search results by file extension ext. This option can be used
repeatedly to allow for multiple possible file extensions.")
  (E -exclude :completions '("GLOBPATTERN") :multiple t :help "\
Exclude files/directories that match the given glob pattern. This
overrides any other ignore logic. Multiple exclude patterns can be
specified.")
  (-ignore-file :completions :file :help "\
Add a custom ignore-file in '.gitignore' format. These files have a
low precedence.")
  (c -color :completions '("auto" "never" "always") :help "\
Declare when to colorize search results:
auto - Colorize output when standard output is connected to terminal (default).
never - Do not colorize output.
always - Always colorize output.")
  (j -threads :completions '("NUMBER") :help "\
Number of threads to use for searching (default: number of available CPUs).")
  (S -size :completions '("<+-><NUM><UNIT>") :help "\
Limit results based on the size of files using the format <+-><NUM><UNIT>
'+' - file size must be greater than or equal to this
'-' - file size must be less than or equal to this
'NUM' - The numeric size (e.g. 500)
'UNIT' - The units for NUM. They are not case-sensitive.
Allowed unit values:
'b' - bytes
'k' - kilobytes
'm' - megabytes
'g' - gigabytes
't' - terabytes
'ki' - kibibytes
'mi' - mebibytes
'gi' - gibibytes
'ti' - tebibytes")
  (-changed-within -change-newer-than :completions '("DATE|DURATION") :help "\
Filter results based on the file modification time. The argument
can be provided as a specific point in time (YYYY-MM-DD HH:MM:SS)
or as a duration (10h, 1d, 35min).
Examples:
--changed-within 2weeks
--change-newer-than \"2018-10-27 10:00:00\"")
  (-changed-before -change-older-than :completions '("DATE|DURATION") :help "\
Filter results based on the file modification time. The argument
can be provided as a specific point in time (YYYY-MM-DD HH:MM:SS)
or as a duration (10h, 1d, 35min).
Examples:
--changed-before \"2018-10-27 10:00:00\"
--change-older-than 2weeks")
  (x -exec :completions '("COMMAND") :help "\
Execute command for each search result. The following
placeholders are substituted by a path derived from the current
search result:
{} - path
{/} - basename
{//} - parent directory
{.} - path without file extension
{/.} - basename without file extension")
  (X -exec-batch :completions '("COMMAND") :help "\
Execute command with all search results at once. A single
occurence of the following placeholders is authorized and
substituted by the paths derived from the search results before
the command is executed:
{} - path
{/} - basename
{//} - parent directory
{.} - path without file extension
{/.} - basename without file extension")

  &positional
  (:completions '("REGEXPATTERN")))

(provide 'pcomplete-declare-fd)
;;; pcomplete-declare-fd.el ends here
