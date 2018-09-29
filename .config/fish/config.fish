# TODO add user@hostname for ssh sessions

set normal (set_color normal)
set magenta (set_color magenta)
set yellow (set_color yellow)
set green (set_color green)
set red (set_color red)
set gray (set_color -o black)

set fish_color_cwd brcyan

# Fish git prompt
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate 'no'
set __fish_git_prompt_showuntrackedfiles 'no'
set __fish_git_prompt_showupstream 'yes'
set __fish_git_prompt_color_upstream_ahead blue
set __fish_git_prompt_color_upstream_behind blue

# Status Chars
set __fish_git_prompt_char_dirtystate '*'
#set __fish_git_prompt_char_stagedstate '→'
#set __fish_git_prompt_char_untrackedfiles '+'
#set __fish_git_prompt_char_stashstate '↩'
#set __fish_git_prompt_char_upstream_ahead '+'
#set __fish_git_prompt_char_cleanstate ''

set __fish_git_prompt_showupstream 'informative'
set __fish_git_prompt_char_stateseparator ''

set __fish_git_prompt_char_upstream_ahead '⇡'
set __fish_git_prompt_char_upstream_behind '⇣'
set __fish_git_prompt_showcolorhints 'true'
set __fish_git_prompt_color_branch brblack

function fish_prompt
  # Save the return value from the last command
  set last_status $status

  set_color $fish_color_cwd
  printf '%s' (prompt_pwd)

  set_color -o black
  __fish_git_prompt " %s "

  # Show duration of last command if it takes longer than a given threshold
  if test $CMD_DURATION; and test $CMD_DURATION -gt 2000
    # Based on how pure does it 
    # https://github.com/sindresorhus/pure/blob/master/pure.zsh
    set total_seconds (math $CMD_DURATION / 1000)
    set days (math $total_seconds / 60 / 60 / 24)
    set hours (math $total_seconds / 60 / 60 "%" 24)
    set minutes (math $total_seconds / 60 "%" 60)
    set seconds (math $total_seconds "%" 60)
    
    if test $days -gt 0
      set duration $duration $days "d "
    end

    if test $hours -gt 0
      set duration $duration $hours "h "
    end

    if test $minutes -gt 0
      set duration $duration $minutes "m "
    end

    set duration $duration $seconds "s"

    set_color -o black
    printf "["
    printf "%s" $duration
    printf "] "
  end

  if test $last_status -ne 0
    set_color red
  else
    set_color normal
  end

  printf '$ '
  
  set_color normal
end
