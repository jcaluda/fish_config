#set -g theme_color_normal normal

# Git Prompt Configuration
set -g __fish_git_prompt_color_branch --bold green
set -g __fish_git_prompt_show_informative_status yes
set -g __fish_git_prompt_showcolorhints yes
set -g __fish_git_prompt_showupstream none
set -g __fish_git_prompt_color_cleanstate green

# Change default characters
set -g __fish_git_prompt_char_dirtystate '*'
set -g __fish_git_prompt_char_stagedstate '+'
set -g __fish_git_prompt_char_stateseparator ' '

# Hide file counts
set -g __fish_git_prompt_hide_dirtystate 1
set -g __fish_git_prompt_hide_stagedstate 1
set -g __fish_git_prompt_hide_untrackedfiles 1

# Unofficial fish_git_prompt settings
set -g __fish_git_prompt_char_branch_begin         '─['
set -g __fish_git_prompt_char_branch_end           ']'
set -g __fish_git_prompt_color_branch_begin        blue
set -g __fish_git_prompt_color_branch_end          blue

# Unofficial fish_venv_prompt settings
set -g theme_venv_prompt_color              brblue
set -g theme_venv_prompt_char_begin         '─['
set -g theme_venv_prompt_char_end           ']'
set -g theme_venv_prompt_color_begin        blue
set -g theme_venv_prompt_color_end          blue


function __user_host
  set -l content
  if [ (id -u) = "0" ];
    echo -n (set_color red)
  else
    echo -n (set_color --bold white)
  end
  echo -n $USER@(hostname|cut -d . -f 1)(set_color normal)
end

function __current_path
  echo -n (set_color normal)(set_color blue)"]─["
  echo -n (set_color --bold yellow)(pwd)(set_color normal)
  echo -n (set_color blue)"]"(set_color normal)
end

function __theme_print_git_status
    [ "$theme_display_git" = 'no' ]; and return
    set -l git_prompt (__fish_git_prompt | command sed -e 's/^ (//' -e 's/)$//')

    [ "$git_prompt" = "" ]; and return

    print_colored $__fish_git_prompt_char_branch_begin $__fish_git_prompt_color_branch_begin
    printf '%s' $git_prompt
    print_colored $__fish_git_prompt_char_branch_end $__fish_git_prompt_color_branch_end
end

function __theme_reset_color
    set_color $theme_color_normal
end

function print_colored
    set -l bgcolor normal
    set -l fgcolor normal
    set -l text

    if contains -- -b in $argv[1]
        set bgcolor $argv[2]
        set fgcolor $argv[-1]
        set text $argv[3..-2]
    else
        set fgcolor $argv[-1]
        set text $argv[1..-2]
    end

    printf '%s%s%s' (set_color -b $bgcolor $fgcolor) (string join " " $text) (__theme_reset_color)
end

function fish_prompt

  echo -n (set_color blue)"╭─["(set_color normal)
  __user_host
  __current_path
  __theme_print_git_status
  echo -e ''
  echo (set_color blue)"╰─["(set_color white)"\$"(set_color normal)(set_color blue)"]› "(set_color normal)
end