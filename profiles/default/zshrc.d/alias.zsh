alias psa="ps aux"

alias gbc="git checkout \$(git branch | fzf)"
alias gbd="git branch -D \$(git branch | fzf)"
alias gbn="git checkout -b"
alias gpoo="git push origin \$(git rev-parse --abbrev-ref HEAD)"

alias mci="mvn clean install"
alias mcist="mvn clean install -Dmaven.test.skip=true"
alias mc="mvn clean"
alias mcp="mvn clean package"
alias mcpst="mvn clean package -Dmaven.test.skip=true"

alias k="kubectl"

alias ytv="yt-dlp -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/mp4' -o '%(title)s.%(ext)s'"
alias ytvs="yt-dlp -f 'bestvideo[ext=mp4][height<=720]+bestaudio[ext=m4a]/mp4' -o '%(title)s.%(ext)s'"
alias yta="yt-dlp -x --audio-format mp3 --audio-quality 0 -o '%(title)s.%(ext)s'"
