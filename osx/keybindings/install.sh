SOURCE_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

mkdir -p ~/Library/KeyBindings
cp $SOURCE_DIRECTORY/DefaultKeyBinding.dict ~/Library/KeyBindings/
