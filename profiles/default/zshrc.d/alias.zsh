alias psa="ps aux"

alias cdp="cd `pwd -P`"

alias gpoo="git push origin \$(git rev-parse --abbrev-ref HEAD)"

alias mci="mvn clean install"
alias mcist="mvn clean install -Dmaven.test.skip=true"
alias mc="mvn clean"
alias mcp="mvn clean package"
alias mcpst="mvn clean package -Dmaven.test.skip=true"

alias ls="ls -G"

alias k="kubectl"

alias ytv="yt-dlp -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/mp4' -o '%(title)s.%(ext)s'"
alias ytvs="yt-dlp -f 'bestvideo[ext=mp4][height<=720]+bestaudio[ext=m4a]/mp4' -o '%(title)s.%(ext)s'"
alias yta="yt-dlp -x --audio-format mp3 --audio-quality 0 -o '%(title)s.%(ext)s'"
