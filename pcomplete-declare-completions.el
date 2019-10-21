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

;;;###autoload (autoload 'pcomplete/grep "pcomplete-declare-completions")
(pcomplete-declare grep
  (-help :help "Output a usage message and exit.")
  (V -version :help "Output the version number of grep and exit.")
  (E -extended-regexp :help "\
Interpret PATTERNS as extended regular expressions.")
  (F -fixed-strings :help "\
Interpret PATTERNS as fixed strings, not regular expressions.")
  (G -basic-regexp :help "\
Interpret PATTERNS as basic regular expressions. This is the default.")
  (P -perl-regexp :help "\
Interpret PATTERNS as Perl-compatible regular expressions (PCREs). This option
is experimental when combined with the -z (--null-data) option, and grep -P may
warn of unimplemented features.")
  (i -ignore-case :help "\
Ignore case distinctions, so that characters that differ only in case match each
other.")
  (v -invert-match :help "\
 Invert the sense of matching, to select non-matching lines.")
  (w -word-regexp :help "\
Select only those lines containing matches that form whole words. The test is
that the matching substring must either be at the beginning of the line, or
preceded by a non-word constituent character. Similarly, it must be either at
the end of the line or followed by a non-word constituent character.
Wordconstituent characters are letters, digits, and the underscore. This option
has no effect if -x is also specified.")
  (x -line-regexp :help "\
Select only those matches that exactly match the whole line. For a regular
expression pattern, this is like parenthesizing the pattern and then surrounding
it with ^ and $.")
  (y :help "Obsolete synonym for -i.")
  (c -count :help "\
Suppress normal output; instead print a count of matching lines for each input
file. With the -v, --invert-match option (see below), count non-matching lines.")
  (L -files-without-match :help "\
Suppress normal output; instead print the name of each input file from which no
output would normally have been printed. The scanning will stop on the first
match.")
  (l -files-with-matches :help "\
Suppress normal output; instead print the name of each input file from which
output would normally have been printed. The scanning will stop on the first
match.")
  (o -only-matching :help "\
Print only the matched (non-empty) parts of a matching line, with each such part
on a separate output line.")
  (q -quiet -silent :help "\
Quiet; do not write anything to standard output. Exit immediately with zero
status if any match is found, even if an error was detected. Also see the -s or
--no-messages option.")
  (s -no-messages :help "\
Suppress error messages about nonexistent or unreadable files.")
  (b -byte-offset :help "\
Print the 0-based byte offset within the input file before each line of output.
If -o (--only-matching) is specified, print the offset of the matching part
itself.")
  (H -with-filename :help "\
Print the file name for each match. This is the default when there is more than
one file to search.")
  (h -no-filename :help "\
Suppress the prefixing of file names on output. This is the default when there
is only one file (or only standard input) to search.")
  (n -line-number :help "\
Prefix each line of output with the 1-based line number within its input file.")
  (T -initial-tab :help "\
Make sure that the first character of actual line content lies on a tab stop, so
that the alignment of tabs looks normal. This is useful with options that prefix
their output to the actual content: -H,-n, and -b. In order to improve the
probability that lines from a single file will all start at the same column,
this also causes the line number and byte offset (if present) to be printed in a
minimum size field width.")
  (u -unix-byte-offsets :help "\
Report Unix-style byte offsets. This switch causes grep to report byte offsets
as if the file were a Unix-style text file, i.e., with CR characters stripped
off. This will produce results identical to running grep on a Unix machine. This
option has no effect unless -b option is also used; it has no effect on
platforms other than MS-DOS and MS-Windows.")
  (Z -null :help "\
Output a zero byte (the ASCII NUL character) instead of the character that
normally follows a file name. For example, grep -lZ outputs a zero byte after
each file name instead of the usual newline. This option makes the output
unambiguous, even in the presence of file names containing unusual characters
like newlines. This option can be used with commands like find -print0, perl -0,
sort -z, and xargs -0 to process arbitrary file names, even those that contain
newline characters.")
  (a -text :help "\
Process a binary file as if it were text; this is equivalent to the
--binary-files=text option.")
  (I :help "\
Process a binary file as if it did not contain matching data; this is equivalent
to the --binary-files=without-match option.")
  (r -recursive :help "\
Read all files under each directory, recursively, following symbolic links only
if they are on the command line. Note that if no file operand is given, grep
searches the working directory. This is equivalent to the -d recurse option.")
  (R -dereference-recursive :help "\
Read all files under each directory, recursively. Follow all symbolic links,
unlike -r.")
  (-line-buffered :help "\
Use line buffering on output. This can cause a performance penalty.")
  (U -binary :help "\
Treat the file(s) as binary. By default, under MS-DOS and MS-Windows, grep
guesses whether a file is text or binary as described for the --binary-files
option. If grep decides the file is a text file, it strips the CR characters
from the original file contents (to make regular expressions with ^ and $ work
correctly). Specifying -U overrules this guesswork, causing all files to be read
and passed to the matching mechanism verbatim; if the file is a text file with
CR/LF pairs at the end of each line, this will cause some regular expressions to
fail. This option has no effect on platforms other than MS-DOS and MS-Windows.")
  (z -null-data :help "\
Treat input and output data as sequences of lines, each terminated by a zero
byte (the ASCII NUL character) instead of a newline. Like the -Z or --null
option, this option can be used with commands like sort -z to process arbitrary
file names.")

  &option
  (e -regexp :completions '("PATTERN") :multiple t :help "\
Use PATTERN as the pattern. If this option is used multiple times or is combined
with the -f (--file) option, search for all patterns given. This option can be
used to protect a pattern beginning with “-”.")
  (f -file :completions :file :multiple t :help "\
Obtain patterns from FILE, one per line. If this option is used multiple times
or is combined with the -e (--regexp) option, search for all patterns given. The
empty file contains zero patterns, and therefore matches nothing.")
  (-color -colour :completions '("never" "always" "auto") :help "\
Surround the matched (non-empty) strings, matching lines, context lines, file
names, line numbers, byte offsets, and separators (for fields and groups of
context lines) with escape sequences to display them in color on the terminal.
The colors are defined by the environment variable GREP_COLORS. The deprecated
environment variable GREP_COLOR is still supported, but its setting does not
have priority. WHEN is never, always, or auto.")
  (-m -max-count :completions '("NUM") :help "\
Stop reading a file after NUM matching lines. If the input is standard input
from a regular file, and NUM matching lines are output, grep ensures that the
standard input is positioned to just after the last matching line before
exiting, regardless of the presence of trailing context lines. This enables a
calling process to resume a search. When grep stops after NUM matching lines, it
outputs any trailing context lines. When the -c or --count option is also used,
grep does not output a count greater than NUM. When the -v or --invert-match
option is also used, grep stops after outputting NUM non-matching lines.")
  (-label :completions '("LABEL") :help "\
Display input actually coming from standard input as input coming from file
LABEL. This is especially useful when implementing tools like zgrep, e.g., gzip
-cd foo.gz | grep --label=foo -H something. See also the -H option.")
  (A -after-context :completions '("NUM") :help "\
Print NUM lines of trailing context after matching lines. Places a line
containing a group separator (--) between contiguous groups of matches. With the
-o or --only-matching option, this has no effect and a warning is given.")
  (B -before-context :completions '("NUM") :help "\
Print NUM lines of leading context before matching lines. Places a line
containing a group separator (--) between contiguous groups of matches. With the
-o or --only-matching option, this has no effect and a warning is given.")
  (C -context :completions '("NUM") :help "\
Print NUM lines of output context. Places a line containing a group separator
(--) between contiguous groups of matches. With the -o or --only-matching
option, this has no effect and a warning is given.")
  (-binary-files :completions '("binary" "without-match" "text") :help "\
If a file's data or metadata indicate that the file contains binary data, assume
that the file is of type TYPE. Non-text bytes indicate binary data; these are
either output bytes that are improperly encoded for the current locale, or null
input bytes when the -z option is not given.

By default, TYPE is binary, and when grep discovers that a file is binary it
suppresses any further output, and instead outputs either a one-line message
saying that a binary file matches, or no message if there is no match.

If TYPE is without-match, when grep discovers that a file is binary it assumes
that the rest of the file does not match; this is equivalent to the -I option.

If TYPE is text, grep processes a binary file as if it were text; this is
equivalent to the -a option.

When type is binary, grep may treat non-text bytes as line terminators even
without the -z option. This means choosing binary versus text can affect whether
a pattern matches a file. For example, when type is binary the pattern q$ might
match q immediately followed by a null byte, even though this is not matched
when type is text. Conversely, when type is binary the pattern . (period) might
not match a null byte.

Warning: The -a option might output binary garbage, which can have nasty side
effects if the output is a terminal and if the terminal driver interprets some
of it as commands. On the other hand, when reading files whose text encodings
are unknown, it can be helpful to use -a or to set LC_ALL='C' in the
environment, in order to find more matches even if the matches are unsafe for
direct display.")
  (D -devices :completions '("read" "skip") :help "\
If an input file is a device, FIFO or socket, use ACTION to process it. By
default, ACTION is read, which means that devices are read just as if they were
ordinary files. If ACTION is skip, devices are silently skipped.")
  (d -directories :completions '("read" "skip" "recurse") :help "\
If an input file is a directory, use ACTION to process it. By default, ACTION is
read, i.e., read directories just as if they were ordinary files. If ACTION is
skip, silently skip directories. If ACTION is recurse, read all files under each
directory, recursively, following symbolic links only if they are on the command
line. This is equivalent to the -r option.")
  (-exclude :completions '("GLOBPATTERN") :multiple t :help "\
Skip any command-line file with a name suffix that matches the pattern GLOB,
using wildcard matching; a name suffix is either the whole name, or any suffix
starting after a / and before a non-/. When searching recursively, skip any
subfile whose base name matches GLOB; the base name is the part after the last
/. A pattern can use *, ?, and [...] as wildcards, and \ to quote a wildcard or
backslash character literally.")
  (-exclude-from :completions :file :multiple t :help "\
Skip files whose base name matches any of the file-name globs read from FILE
(using wildcard matching as described under --exclude).")
  (-exclude-dir :completions '("GLOBPATTERN") :multiple t :help "\
Skip any command-line directory with a name suffix that matches the pattern
GLOB. When searching recursively, skip any subdirectory whose base name matches
GLOB. Ignore any redundant trailing slashes in GLOB.")
  (-include :completions '("GLOBPATTERN") :multiple t :help "\
Search only files whose base name matches GLOB (using wildcard matching as
described under --exclude).")

  &positional
  (:completions :file :multiple t :help "\
grep searches for PATTERNS in each FILE. A FILE of “-” stands for standard
input. If no FILE is given, recursive searches examine the working directory,
and nonrecursive searches read standard input."))

(provide 'pcomplete-declare-completions)
;;; pcomplete-declare-completions.el ends here
