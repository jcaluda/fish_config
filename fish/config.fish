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

if test -f ~/.dircolors/dircolors.ansi-dark
    set -gx LS_COLORS (dircolors -c ~/.dircolors/dircolors.ansi-dark | string replace -r 'setenv LS_COLORS \'(.*)\'' '$1')
end

set -g theme_display_date no