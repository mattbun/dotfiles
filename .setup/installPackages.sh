# Set PLATFORM to either "arch" or "mac"
if [ -z "$PLATFORM" ]; then
  echo "\$PLATFORM is not set"
  exit 1
fi

PACKAGES=`yq r --collect ~/.setup/packages.yml "packages.(${PLATFORM}==*)"`
NUM_PACKAGES=`echo "$PACKAGES" | yq r --length -`

for ((i=0; i<$NUM_PACKAGES; i++))
do
    PACKAGE_NAME=`echo "$PACKAGES" | yq r - "[$i].name"`
    INSTALL_COMMAND=`echo "$PACKAGES" | yq r - "[$i].${PLATFORM}"`
    EXECUTABLE_NAME=`echo "$PACKAGES" | yq r - "[$i].executable"`

    # Check if it's already installed
    if ! [ -x "$(command -v $EXECUTABLE_NAME)" ]; then
      echo "Installing ${PACKAGE_NAME}"
      echo "$ $INSTALL_COMMAND"
      eval $INSTALL_COMMAND
      echo
    else
      echo "Skipping $PACKAGE_NAME"
    fi
done
