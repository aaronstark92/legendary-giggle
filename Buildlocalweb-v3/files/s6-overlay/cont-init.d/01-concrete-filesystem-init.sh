#!/usr/bin/with-contenv bash

C5_HOME="${C5_HOME}"
CONCRETE_VERSION="${CONCRETE_VERSION}"
SRC=/tmp/concrete"${CONCRETE_VERSION}"

install_c5_src() {
   echo "Installing Concrete Filesystem"
   find "${C5_HOME}" -maxdepth 1 -mindepth 1 -exec rm -rf '{}' \;
   find "${SRC}" -maxdepth 1 -mindepth 1 -exec mv '{}' "${C5_HOME}/" \;
   rmdir "${SRC}"
   chown -R www-data:www-data "${C5_HOME}"
}

main() {
  if [ -d "${SRC}" ]
  then
    install_c5_src
  fi
}

main
