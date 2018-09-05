# Powerlevel configuration:
# https://github.com/bhilburn/powerlevel9k

POWERLEVEL9K_RPROMPT_ON_NEWLINE=false
POWERLEVEL9K_PROMPT_ON_NEWLINE=true

if [[ -n $SSH_CONNECTION ]] || [[ $(uname -s) != 'Darwin' ]]; then
    POWERLEVEL9K_CONTEXT_TEMPLATE="%n@%m"
else
    POWERLEVEL9K_CONTEXT_TEMPLATE="%n"
fi

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir rbenv vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs time ssh)
