;;; pcomplete-declare-grep.el --- Completions for grep -*- lexical-binding: t; -*-

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

;;;###autoload (autoload 'pcomplete/grep "pcomplete-declare-grep")
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

(provide 'pcomplete-declare-grep)
;;; pcomplete-declare-grep.el ends here
