if [[ -n $SSH_CONNECTION ]] || [[ $(uname -s) != 'Darwin' ]]; then
    local user_info="%n@%m"
else
    local user_info="%n"
fi

local ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ %s)%{$fg_bold[green]%}"
local directory_status="%{$fg[cyan]%}%d"
local end_status="%{$fg_bold[blue]%}%#"

PROMPT='${user_info} ${ret_status} ${directory_status} %{$fg_bold[blue]%}$(git_prompt_info) ${end_status} %{$reset_color%}'
