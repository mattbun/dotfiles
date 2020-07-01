# Some functions to use in all scripts

# Install something only if the command isn't found
#
# "But Matt, is this function really necessary? Wouldn't the package manager just skip over it if it's not installed?"
# Yeah, true... I'm keeping it around for a few reasons:
#   * It makes the console output cleaner
#   * It's helpful for things that aren't actually in the package manager
#   * It won't reinstall something that I might have installed a different version of (like node in debian)
installMaybe () {
  if ! [ -x "$(command -v $1)" ]; then
    echo "Installing $1"
    eval $2
  else
    echo "Skipping $1"
  fi
}
