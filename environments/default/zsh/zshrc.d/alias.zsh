alias psa="ps aux"

alias cp="cp"
alias cdp="cd `pwd -P`"

alias gpom="git push origin master"
alias gpoo="git push origin \$(git rev-parse --abbrev-ref HEAD)"

alias mci="mvn clean install"
alias mcist="mvn clean install -Dmaven.test.skip=true"
alias mc="mvn clean"
alias mcp="mvn clean package"
alias mcpst="mvn clean package -Dmaven.test.skip=true"

alias nano="echo 'You want to use vim! So start using it! :-)'"

alias ls="ls -G"

alias k="kubectl"
alias km="kubectl --context minikube"
