# Symlinking the `~/Library/KeyBindings/DefaultKeyBinding.dict` file doesn't work 🤬
# Took me hours to find out why this wasn't working but here we are.
#
# So to make sure the `DefaultKeyBinding.dict` can still be versionable we check each
# and every time whether the current version is identical to the version in the
# repository.

DEFAULT_KEY_BINDING_FILE="$HOME/Library/KeyBindings/DefaultKeyBinding.dict"
DEFAULT_KEY_BINDING_FILE_CONTENT=$(cat <<EOF
{
  "\\\\UF729"   = "moveToBeginningOfLine:"; // home
  "\\\\UF72B"   = "moveToEndOfLine:"; // end
  "$\\\\UF729"  = "moveToBeginningOfLineAndModifySelection:"; // shift-home
  "$\\\\UF72B"  = "moveToEndOfLineAndModifySelection:"; // shift-end
  "^\\\\UF729"  = "moveToBeginningOfDocument:"; // ctrl-home
  "^\\\\UF72B"  = "moveToEndOfDocument:"; // ctrl-end
  "^$\\\\UF729" = "moveToBeginningOfDocumentAndModifySelection:"; // ctrl-shift-home
  "^$\\\\UF72B" = "moveToEndOfDocumentAndModifySelection:"; // ctrl-shift-end
}
EOF
)

if [[ -L $DEFAULT_KEY_BINDING_FILE ]]; then
  echo "DefaultKeyBinding.dict file is a symlink, which does NOT work. This script will remove the symlink and create a file instead."
  rm -f $DEFAULT_KEY_BINDING_FILE
fi
if [[ ! -f $DEFAULT_KEY_BINDING_FILE || "$(echo $DEFAULT_KEY_BINDING_FILE_CONTENT | md5 -q)" != "$(md5 -q $DEFAULT_KEY_BINDING_FILE)" ]]; then
  echo $DEFAULT_KEY_BINDING_FILE_CONTENT > $DEFAULT_KEY_BINDING_FILE
fi

unset DEFAULT_KEY_BINDING_FILE
unset DEFAULT_KEY_BINDING_FILE_CONTENT
