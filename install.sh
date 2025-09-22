DESTINATION="$HOME/.local/share/sounds/"
mkdir -p "$DESTINATION"
echo "Copying sound files to $DESTINATION"
cp ./sounds/* "$DESTINATION"

case "$SHELL" in
*/bash)
  echo "Bash is not supported yet"
  ;;
*/zsh)
  echo "Zsh is not supported yet"
  ;;
*/fish)
  echo "This is Fish"
  cat ./script.fish >>~/.config/fish/config.fish
  ;;
*)
  echo "Unknown shell: $SHELL"
  ;;
esac
