fgb() {
  local branches branch
  branches=$(git --no-pager branch -vv) &&
  branch=$(echo "$branches" | fzf +m --tac --query="$@") &&
  git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
}

alias fcat="fzf --preview 'cat {}'"
