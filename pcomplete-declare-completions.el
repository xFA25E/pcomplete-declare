;;; pcomplete-declare-completions.el --- Completions for various commands  -*- lexical-binding: t; -*-

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

;;;###autoload (autoload 'pcomplete/echo "pcomplete-declare-completions")
(pcomplete-declare echo
  (n :help "do not output the trailing newline")
  (e :help "enable interpretation of backslash escapes")
  (E :help "disable interpretation of backslash escapes (default)")
  (-help :help "display this help and exit")
  (-version :help "output version information and exit"))

;;;###autoload (autoload 'pcomplete/date "pcomplete-declare-completions")
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

;;;###autoload (autoload 'pcomplete/fd "pcomplete-declare-completions")
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

;;;###autoload (autoload 'pcomplete/head "pcomplete-declare-completions")
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

;;;###autoload (autoload 'pcomplete/nl "pcomplete-declare-completions")
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

;;;###autoload (autoload 'pcomplete/pwd "pcomplete-declare-completions")
(pcomplete-declare pwd
  (L -logical :help "\
use PWD from environment, even if it contains symlinks")
  (P -physical :help "avoid all symlinks")
  (-help :help "display this help and exit")
  (-version :help "output version information and exit"))

;;;###autoload (autoload 'pcomplete/pwgen "pcomplete-declare-completions")
(pcomplete-declare pwgen
  (\0 -no-numerals :help "\
Don't include numbers in the generated passwords.")
  (\1 :help "Print the generated passwords one per line.")
  (A -no-capitalize :help "\
Don't bother to include any capital letters in the generated
passwords.")
  (a -alt-phonics :help "\
This option doesn't do anything special;
it is present only for backwards compatibility.")
  (B -ambiguous :help "\
Don't use characters that could be confused by the user when
printed, such as 'l' and '1', or '0' or 'O'. This reduces the
number of possible passwords significantly, and as such reduces
the quality of the passwords. It may be useful for users who have
bad vision, but in general use of this option is not
recommended.")
  (c -capitalize :help "\
Include at least one capital letter in the password. This is the
default if the standard output is a tty device.")
  (C :help "\
Print the generated passwords in columns. This is the default if the
standard output is a tty device.")
  (n -numerals :help "\
Include at least one number in the password. This is the default if
the standard output is a tty device.")
  (h -help :help "Print a help message.")
  (s -secure :help "\
Generate completely random, hard-to-memorize passwords. These should
only be used for machine passwords, since otherwise it's almost
guaranteed that users will simply write the password on a piece of
paper taped to the monitor...")
  (v -no-vowels :help "\
Generate random passwords that do not contain vowels or numbers that
might be mistaken for vowels. It provides less secure passwords to
allow system administrators to not have to worry with random
passwords accidentally contain offensive substrings.")
  (y -symbols :help "\
Include at least one special character in the password.")

  &option
  (N -num-passwords :completions '("NUMBER") :help "\
Generate num passwords. This defaults to a screenful if passwords are
printed by columns, and one password otherwise.")
  (H -sha1 :completions :file :help "\
/path/to/file[#seed]
Will use the sha1's hash of given file and the optional seed to create
password. It will allow you to compute the same password later, if you
remember the file, seed, and pwgen's options used. ie: pwgen -H
~/your_favorite.mp3#your@email.com gives a list of possibles passwords
for your pop3 account, and you can ask this list again and again.

WARNING: The passwords generated using this option are not very
random. If you use this option, make sure the attacker can not obtain
a copy of the file. Also, note that the name of the file may be easily
available from the ~/.history or ~/.bash_history file.")
  (r -remove-chars :completions '("CHARS") :help "\
Don't use the specified characters in password. This option will
disable the phomeme-based generator and uses the random password
generator.")

  &positional
  (:completions '("PWLENGTH"))
  (:completions '("PWCOUNT")))

;;;###autoload (autoload 'pcomplete/tail "pcomplete-declare-completions")
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

;;;###autoload (autoload 'pcomplete/uniq "pcomplete-declare-completions")
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

;;;###autoload (autoload 'pcomplete/sxhkd "pcomplete-declare-completions")
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

;;;###autoload (autoload 'pcomplete/dash "pcomplete-declare-completions")
(pcomplete-declare dash
  (a :help "Export all variables assigned to.")
  (C :help "Don't overwrite existing files with “>”.")
  (e :help "\
If not interactive, exit immediately if any untested command fails. The exit
status of a command is considered to be explicitly tested if the command is used
to control an if, elif, while, or until; or if the command is the left hand
operand of an “&&” or “||” operator.")
  (f :help "Disable pathname expansion.")
  (n :help "
If not interactive, read commands but do not execute them. This is useful for
checking the syntax of shell scripts.")
  (u :help "\
Write a message to standard error when attempting to expand a variable that is
not set, and if the shell is not interactive, exit immediately.")
  (v :help "\
The shell writes its input to standard error as it is read. Use‐ ful for
debugging.")
  (x :help "\
Write each command to standard error (preceded by a ‘+ ’) before it is executed.
Useful for debugging.")
  (I :help "Ignore EOF's from input when interactive.")
  (i :help "Force the shell to behave interactively.")
  (m :help "Turn on job control (set automatically when interactive).")
  (q)
  (V :help "\
Enable the built-in vi(1) command line editor (disables -E if it has been set).")
  (E :help "\
Enable the built-in emacs(1) command line editor (disables -V if it has been
set).")
  (b :help "\
Enable asynchronous notification of background job completion. (UNIMPLEMENTED
for 4.4alpha)")
  (s :help "\
Read commands from standard input (set automatically if no file arguments are
present). This option has no effect when set after the shell has already started
running (i.e. with set).")

  &option
  (o :completions '("errexit" "noglob" "ignoreeof" "interactive"
                    "monitor" "noexec" "stdin" "xtrace" "verbose"
                    "vi" "emacs" "noclobber" "allexport" "notify"
                    "nounset" "nolog" "debug")
     :help "Dash options")
  (c :completions '("COMMANDSTRING") :help "\
Read commands from the command_string operand instead of from the standard
input. Special parameter 0 will be set from the command_name operand and the
positional parameters ($1, $2, etc.) set from the remaining argument operands."))

(provide 'pcomplete-declare-completions)
;;; pcomplete-declare-completions.el ends here
