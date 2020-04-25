;;; pcomplete-declare-scrot.el --- scrot completions  -*- lexical-binding: t; -*-

;; Copyright (C) 2019

;; Author:  <>
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

;;;###autoload (autoload 'pcomplete/scrot "pcomplete-declare-scrot")
(pcomplete-declare scrot
  (-help :help "Display help output and exit.")

  (-version :help "Output version information and exit.")

  (-autoselect :help "Non-interactively choose a rectangle of x,y,w,h.")

  (--border :help "When selecting a window, grab wm border too.")

  (--count :help "Display a countdown when used with delay.")

  (--multidisp :help "\
For multiple heads, grab shot from each and join them together.")

  (--select :help "\
Interactively select a window or rectangle with the mouse.
See  -l and -f options.")

  (--line :help "\
Indicates  the  style  of the line when the -s option is used.
See SELECTION STYLE.")

  (--freeze :help "Freeze the screen when the -s option is used.")

  (--focused :help "Use the currently focused window.")

  (--silent :help "Prevent beeping.")

  (--pointer :help "Capture the mouse pointer.")

  (--overwrite :help "\
By default scrot does not overwrite the files, use this  option  to allow it.")

  (--note :help "Draw a text note. See NOTE FORMAT.")

  &option
  (--thumb :completions '("NUMorGEOM") :help "\
Generate thumbnail too. NUM is the percentage of the original size for the
thumbnail to be. Alternatively, a GEOMetry can be specified, example: 300x200")

  (--delay :completions '("NUM")
           :help "Wait NUM seconds before taking a shot.")

  (--exec :completions '("COMMAND") :help "\
Exec COMMAND on the saved image. See filename help for more details")

  (-quality :completions '("NUM") :help "\
Image quality (1-100) high value means high size, low compression. Default: 75.
(Effect differs depending on file format chosen).")

  &positional
  (:completions :file :help "\
Both  the  --exec  and filename parameters can take format specifiers that
are expanded by scrot when encountered. There  are  two  types  of  format
specifier.   Characters  preceded by a '%' are interpreted by strftime(2).
See man strftime for examples. These options may be used to refer  to  the
current  date and time. The second kind are internal to scrot and are pre‐
fixed by '$' The following specifiers are recognised:
    $a  hostname
    $f  image path/filename (ignored when used in the filename)
    $m  thumb image path/filename (ignored when used in the filename)
    $n  image name (ignored when used in the filename)
    $s  image size (bytes) (ignored when used in the filename)
    $p  image pixel size
    $w  image width
    $h  image height
    $t  image format (ignored when used in the filename)
    $$  print a literal '$'
    \n  print a newline (ignored when used in the filename)
Example:
    scrot '%Y-%m-%d_$wx$h.png' -e 'mv $f ~/shots/'
This would create a file called  something  like  2000-10-30_2560x1024.png
and move it to your shots directory."))


(provide 'pcomplete-declare-scrot)
;;; pcomplete-declare-scrot.el ends here
