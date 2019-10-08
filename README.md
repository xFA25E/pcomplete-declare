# pcomplete-declare
Define your shell completions in a declarative way

It provides a macro pcomplete-declare with uses internally the
pcomplete library. So, it should work with eshell and shell.

# Example usage
```emacs-lisp
(pcomplete-declare mycommand
  "This defines completion for mycommand" ; optional doc for a function

  ;; Omit first "-" for flags and options. They will be added
  ;; automatically. This ensures that all flags and options will start
  ;; with a dash.

  ;; You can optionally add :help property with a string to every
  ;; completion candidate. The message will be displayed by calling
  ;; (pcomplete-help)

  ;; Definitions should be in the following order:
  ;; flags, options, positional arguments, subcommands

  ;; We start with flags. They have no arguments.
  ;; The syntax is as follows:
  ;; (NAMES... [:help MESSAGE] [:multiple BOOL])

  ;; If you add :multiple property, the flag won't be removed
  ;; from completion list
  '((o -option-long :help "my flag help")
    (-boolean-flag :help "help message" :multiple t)
    ;; End of flag definitions

    ;; An option take an argument, so :completions property is mandatory
    ;; :completions can be:
    ;; - A function that returns completions
    ;; - A list with completions
    ;; - A keyword: :file, :directory or :executable
    ;;   :file - can complete everything on the file system
    ;;   :directory - will filter results for directories

    ;; Options can be multiple too
    &option
    (f :completions :file)
    (c -custom-option -alias-for-custom :completions '("bong" "wong"))
    (d -directory-long :multiple t :completions :directory)
    (w -why-not-function :multiple t :completions #'some-function)
    ;; End of option definitions

    ;; Positionals are arguments that don't have a flag or an option.
    ;; For example, you can have the following command syntax:
    ;; $ mycommand EXECUTABLE FILE...
    ;; This can be achieved with the following definitions
    &positional
    (:completions :executable :help "take an executable")
    (:completions :file :multiple t)
    ;; Only the last positional can be multiple
    ;; End of positional definitions

    ;; Also, you can define subcommands. Like "git add" etc. After
    ;; entering in the subcommand completions, previous completions
    ;; won't appear in the list of candidates
    &subcommand
    ;; Important: :help property should immediately after the subcommand name
    (subcommand1 :help "hello"
                 ;; The syntax is the same as with command
                 (t -tig-tog :multiple t)
                 &option
                 (e :completions :executable)
                 &positional
                 (:completions :executable)
                 (:completions :directory :multiple t))
    (subcommand2 (-my-flag))))
```
