;;; pcomplete-declare-base16_theme.el --- base16_theme completion  -*- lexical-binding: t; -*-

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

(defun pcomplete-declare-base16_theme-configs ()
  "Get list of available base16_theme themes."
  (split-string (pcomplete-process-result "base16_theme" "list_configs") "\n"))

(defun pcomplete-declare-base16_theme-themes ()
  "Get list of available base16_theme themes."
  (split-string (pcomplete-process-result "base16_theme" "list_themes") "\n"))

(defun pcomplete-declare-base16_theme-theme-files ()
  "Get list of available base16_theme themes."
  (split-string (pcomplete-process-result "base16_theme" "list_files" (pcomplete-arg 'first 2)) "\n"))

(defun pcomplete-declare-base16_theme-templates ()
  "Get list of available base16_theme themes."
  (split-string (pcomplete-process-result "base16_theme" "list_templates") "\n"))

;;;###autoload (autoload 'pcomplete/base16_theme "pcomplete-declare-base16_theme")
(pcomplete-declare base16_theme
  &subcommand
  (list_themes :help "List available themes")
  (list_templates :help "List available templates")
  (list_configs :help "List available configs")
  (list_files
   :help "List available theme files"
   &positional
   (:completions #'pcomplete-declare-base16_theme-themes
                 :help "base16_theme theme"))
  (create
   :help "Create theme files"
   &positional
   (:completions #'pcomplete-declare-base16_theme-configs
                 :help "base16_theme config")
   (:completions #'pcomplete-declare-base16_theme-templates
                 :multiple t
                 :help "base16_theme template"))
  (apply
   :help "Apply theme"
   &positional
   (:completions #'pcomplete-declare-base16_theme-themes
                 :help "base16_theme theme")
   (:completions #'pcomplete-declare-base16_theme-theme-files
                 :multiple t
                 :help "base16_theme template")))

(provide 'pcomplete-declare-base16_theme)
;;; pcomplete-declare-base16_theme.el ends here
