# pcomplete-declare
Define your shell completions in declarative way using the pcomplete libarary

# Example usage
```
(pcomplete-declare mycommand
  "This defines completion for mycommand"
  ;; HELP_DEFS:

  ;; Omit first "-" for flags and options.
  ;; It will add it automatically

  ;; You can optionally add :help property that will be displayed
  ;; after calling (pcomplete-help)

  ;; Definitions should follow the following order:
  ;; flags, options, positional arguments, subcommands

  ;; We start with flags, they don't have an argument
  ;; You can define as many names as you'd need
  '((o -option-long :help "my flag help")
    ;; You can specify a flag multiple times
    (-boolean-flag :help "help message" :multiple t)
    ;; Flags definition ends here

    ;; Options take an argument, so :completions property is mandatory
    &option
    ;; :completions can be:
    ;; - A function that returns completions
    ;; - A list with completions
    ;; - A keyword: :file, :directory or :executable
    ;; :file can complete everything
    ;; :directory will filter results for directories
    (f :completions :file)
    (c -custom-option -alias-for-custom :completions '("bong" "wong"))
    ;; Options can be multiple too
    (d -directory-long :multiple t :completions :directory)
    (w -why-not-function :multiple t :completions #'some-function)
    ;; Options definition ends here

    ;; Positionals are any other arguments that don't have a flag or
    ;; option
    ;; For example files for grep at the end
    &positional
    (:completions :executable :help "take an executable")
    ;; Positional can be multiple, but only if it is the last positional
    ;; Sorry :C
    (:completions :directory :multiple t)

    ;; Here you can define a subcommands
    ;; After entering in the subcommand completions previous
    ;; completions won't appear in the candidates list
    &subcommand
    ;; Important: :help property should be an the boginning
    (subcommand1 :help "hello"
                 ;; GOTO HELP_DEFS;
                 (t -tig-tog :multiple t)
                 &option
                 (e :completions :executable)
                 &positional
                 (:completions :executable)
                 (:completions :directory :multiple t))
    (subcommand2 (-my-flag))))
```
