# History command configuration (stored in cache directory per XDG Base Directory spec)
HISTFILE="$XDG_CACHE_HOME/zsh/history"
HISTSIZE=5000
SAVEHIST=$HISTSIZE

# Ensure history file directory exists (only run in zsh context)
if [[ -n "$ZSH_VERSION" ]]; then
    if [[ ! -d "$(dirname "$HISTFILE")" ]]; then
        mkdir -p "$(dirname "$HISTFILE")"
    fi
fi

# setopt extended_history       # record timestamp of command in HISTFILE
# setopt inc_append_history     # add commands to HISTFILE in order of execution (real-time)
# setopt share_history          # share command history data between sessions
# setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
# setopt hist_ignore_space      # ignore commands that start with space
# setopt hist_ignore_all_dups   # ignore duplicated commands history list (aggressive)
# setopt hist_save_no_dups      # don't save duplicate commands to history file
# setopt hist_find_no_dups      # skip duplicates when searching history
# setopt hist_verify            # show command with history expansion before running it
#
# Sun Jan 18 19:55:23 CST 2026
# Added from https://natelandau.com/my-mac-os-zsh-profile/
# Note there are duplicatios above/below
setopt always_to_end          # When completing a word, move the cursor to the end of the word
setopt append_history         # this is default, but set for share_history
setopt auto_cd                # cd by typing directory name if it's not a command
setopt auto_list              # automatically list choices on ambiguous completion
setopt auto_menu              # automatically use menu completion
setopt auto_pushd             # Make cd push each old directory onto the stack
setopt completeinword         # If unset, the cursor is set to the end of the word
# setopt correct_all            # autocorrect commands
setopt extended_glob          # treat #, ~, and ^ as part of patterns for filename generation
setopt extended_history       # save each command's beginning timestamp and duration to the history file
setopt glob_dots              # dot files included in regular globs
setopt hash_list_all          # when command completion is attempted, ensure the entire  path is hashed
setopt hist_expire_dups_first # # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_find_no_dups      # When searching history don't show results already cycled through twice
setopt hist_ignore_dups       # Do not write events to history that are duplicates of previous events
setopt hist_ignore_space      # remove command line from history list when first character is a space
setopt hist_reduce_blanks     # remove superfluous blanks from history items
setopt hist_verify            # show command with history expansion to user before running it
setopt histignorespace        # remove commands from the history when the first character is a space
setopt inc_append_history     # save history entries as soon as they are entered
setopt interactivecomments    # allow use of comments in interactive code (bash-style comments)
setopt longlistjobs           # display PID when suspending processes as well
setopt no_beep                # silence all bells and beeps
setopt nocaseglob             # global substitution is case insensitive
setopt nonomatch              ## try to avoid the 'zsh: no matches found...'
setopt noshwordsplit          # use zsh style word splitting
setopt notify                 # report the status of backgrounds jobs immediately
setopt numeric_glob_sort      # globs sorted numerically
setopt prompt_subst           # allow expansion in prompts
setopt pushd_ignore_dups      # Don't push duplicates onto the stack
setopt share_history          # share history between different instances of the shell
