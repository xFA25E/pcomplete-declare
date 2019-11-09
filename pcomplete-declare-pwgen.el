;;; pcomplete-declare-pwgen.el --- Completions for pwgen -*- lexical-binding: t; -*-

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

;;;###autoload (autoload 'pcomplete/pwgen "pcomplete-declare-pwgen")
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

(provide 'pcomplete-declare-pwgen)
;;; pcomplete-declare-pwgen.el ends here
