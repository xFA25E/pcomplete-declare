;;; pcomplete-declare-mpop.el --- Completion for mpop  -*- lexical-binding: t; -*-

;; Copyright (C) 2020  Valeriy Litkovskyy

;; Author: Valeriy Litkovskyy <valeriy.litkovskyy@mail.polimi.it>
;; Keywords: convenience

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

;; Completion for mpop

;;; Code:

(require 'pcomplete-declare)

(eval-and-compile
  (defun pcomplete-declare-mpop-accounts ()
    "Get mpop accounts."
    (let ((result (pcomplete-process-result "mpop" "--pretend" "--all-accounts")))
      (if (string-empty-p result)
          '("ACCOUNT")
        (cl-loop for line in (split-string result "\n")
                 if (string-match (rx string-start "using account "
                                      (group (one-or-more alnum)))
                                  line)
                 collect (match-string 1 line))))))

;;;###autoload (autoload 'pcomplete/rimer "pcomplete-declare-mpop")
(pcomplete-declare mpop
  (-version :help "\
Print version information, including information about the libraries used.")
  (-help :help "Print help")
  (-pretend :help "\
Print the configuration settings that would be used, but do not take further
action. An asterisk (`*') will be printed instead of your password")
  (-debug :help "\
Print lots of debugging information, including the whole conversation with the
server. Be careful with this option: the (potentially dangerous) output will not
be sanitized, and your password may get printed in an easily decodable format!

This option implies --half-quiet, because the progress output would interfere
with the debugging output")

  &option
  (-host :completions '("HOST") :help "\
Use this server with settings from the command line; do not use any
configuration file data. This option disables loading of the configuration file.
You cannot use both this option and account names on the command line")

  &subcommand
  (-- :help "Mail retrieval mode"

      (-quiet :help "Do not print status or progress information.")

      (-half-quiet :help "Print status but not progress information.")

      (-all-accounts :help "Query all accounts in the configuration file.")

      (-auth-only :help "\
Authenticate only; do not retrieve mail. Useful for SMTP-after-POP.")

      (-status-only :help "\
Print number and size of mails in each account only; do not retrieve mail.")

      &option
      (-only-new :completions '("on" "off")
                 :help "Process only new messages. See the only_new command.")

      (-keep :completions '("on" "off")
             :help "\
Do not delete mails from POP3 servers, regardless of other options or settings.
See the keep command.")

      (-killsize :completions '("off" "size")
                 :help "Set or unset kill size. See the killsize command.")

      (--skipsize :completions '("off" "size")
                  :help "Set or unset skip size. See the skipsize command.")

      (-delivery :completions '("mda,COMMAND" "maildir,DIRECTORY"
                                "mbox,MBOXFILE" "exchange,DIRECTORY")
                 :help "\
How to deliver messages received from this account. See the delivery command.
Note that a comma is used instead of a blank to separate the method from its
arguments.")

      (-filter :completions :executable
               :help "\
Set a filter which will decide whether to retrieve, skip, or delete each mail by
investigating the mail's headers. See the filter command.")

      (-uidls-file :completions :file
                   :help "File to store UIDLs in. See the uidls_file command.")

      &positional
      (:completions #'pcomplete-declare-mpop-accounts
                    :help "Account name"))

  (--serverinfo :help "\
Print information about the POP3 server(s) and exit. This includes information
about supported features (pipelining, authentication methods, TOP command, ...),
about parameters (time for which mails will not be deleted, minimum time between
logins, ...), and about the TLS certificate (if TLS is active)."
                &positional
                (:completions #'pcomplete-declare-mpop-accounts
                              :help "Account name"))

  (--configure
   :help "Configuration mode"

   &option

   (-file :completions :file
          :help "\
Use the given file instead of ~/.mpoprc or $XDG_CONFIG_HOME/mpop/config as the
user configuration file.")

   (-port :completions '("PORT")
          :help "Set the port number to connect to. See the port command.")

   (-source-ip :completions '("IP")
               :help "\
Set or unset an IP address to bind the socket to. See the source_ip command.")

   (-proxy-host :completions '("IP" "HOSTNAME")
                :help "\
Set or unset a SOCKS proxy to use. See the proxy_host command.")

   (-proxy-port :completions '("NUMBER")
                :help "\
Set or unset a port number for the proxy host. See the proxy_port command.")

   (-timeout :completions '("off" "SECONDS")
             :help "Set a network timeout. See the timeout command.")

   (-pipelining :completions '("auto" "on" "off")
                :help "\
Enable  or  disable POP3 pipelining. See the pipelining command.")

   (-received-header :completions '("on" "off")
                     :help "\
Enable  or  disable  the  Received  header.  See   the   received_header command.")

   (-auth :completions '("on" "METHOD")
          :help "\
Set the authentication method to automatic (with \"on\") or manually choose an
authentication method. See the auth command.")

   (-user :completions '("USERNAME")
          :help "\
Set  or unset the user name for authentication. See the user command.")

   (-passwordeval :completions '("EVAL")
                  :help "\
Evaluate password for authentication. See  the  passwordeval command.")

   (-tls :completions '("on" "off")
         :help "Enable or disable TLS/SSL. See the tls command.")

   (-tls-starttls :completions '("on" "off")
                  :help "\
Enable  or  disable  STARTTLS  for TLS. See the tls_starttls command.")

   (-tls-trust-file :completions :file
                    :help "\
Set or unset a trust file for TLS. See the tls_trust_file command.")

   (-tls-crl-file :completions :file
                  :help "\
Set or unset a certificate revocation list (CRL) file for TLS. See the
tls_crl_file command.")

   (-tls-fingerprint :completions '("FINGERPRINT")
                     :help "\
Set or unset the fingerprint of a trusted TLS certificate. See the
tls_fingerprint command.")

   (-tls-key-file :completions :file
                  :help "\
Set  or  unset a key file for TLS. See the tls_key_file command.")

   (-tls-cert-file :completions :file
                   :help "\
Set or unset a cert file for TLS. See the tls_cert_file command.")

   (-tls-certcheck :completions '("on" "off")
                   :help "\
Enable or disable server certificate checks for TLS. See the tls_certcheck
command.")

   (-tls-min-dh-prime-bits :completions '("BITS")
                           :help "\
Set or unset minimum bit size of the Diffie-Hellmann (DH) prime. See the
tls_min_dh_prime_bits command.")

   (-tls-priorities :completions '("PRIORITIES")
                    :help "\
Set or unset TLS priorities. See the tls_priorities command.")

   &positional
   (:completions '("EMAIL") :help "\
Generate a configuration for the given mail address and print it. This can be
modified or copied unchanged to the configuration file. Note that this only
works for mail domains that publish appropriate SRV records; see RFC 8314.")))

(provide 'pcomplete-declare-mpop)
;;; pcomplete-declare-mpop.el ends here
