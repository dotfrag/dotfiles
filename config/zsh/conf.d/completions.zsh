# autocomplete zsh functions
# custom complete function is not needed since zsh comes with a builtin
# _funcs() {
#   # compadd -- $(functions -) # executes functions command and completes its output
#   compadd -k functions # uses keys of the builtin functions associative array
# }
compdef _functions func edfunc

_upgrayedd() {
  _arguments \
    '1:step:(bob bun cargo code docker gh gup nala npm pnpm repos rust rustup snap system yay tldr uv yazi zsh)'
}
compdef _upgrayedd upgrayedd

_jqsort() {
  # _files -g '*.json' # find json files in cwd
  # _path_files -g '**/*.json' # find json files recursively
  # _arguments '1:json file:_files -g "*.json"'
  _arguments '1:json file:_path_files -g "**/*.json"'
}
compdef _jqsort jqsort
