alias psa="ps aux"

alias cdp="cd `pwd -P`"

alias gpom="git push origin master"
alias gpoo="git push origin \$(git rev-parse --abbrev-ref HEAD)"

alias mci="mvn clean install"
alias mcist="mvn clean install -Dmaven.test.skip=true"
alias mc="mvn clean"
alias mcp="mvn clean package"
alias mcpst="mvn clean package -Dmaven.test.skip=true"

alias ls="ls -G"

alias k="kubectl"

alias ytv="youtube-dl -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best'"
