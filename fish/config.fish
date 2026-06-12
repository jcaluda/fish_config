alias l 'ls'
alias vi 'vim'
alias fconf 'cd ~/.config/fish'

set fish_greeting ""
set -U fish_prompt_pwd_dir_length 0

function reload
    if source ~/.config/fish/config.fish
        echo "config.fish reloaded"
    end
end

function start_tmux
    if type tmux > /dev/null
        #if not inside a tmux session, and if no session is started, start a new session
        if test -z "$TMUX" ; and test -z $TERMINAL_CONTEXT
            tmux -2 attach; or tmux -2 new-session
        end
    end
end

if test -f ~/.dircolors/dircolors.ansi-dark
    set -gx LS_COLORS (dircolors -c ~/.dircolors/dircolors.ansi-dark | string replace -r 'setenv LS_COLORS \'(.*)\'' '$1')
end

start_tmux