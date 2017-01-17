#!/bin/bash

. ./build-settings.sh
. ./build-common.sh

INFO=fileinfo.txt
export DISABLE_UNIT_TESTS=1

pkg_get_value() {
  grep "$2" "$1" | awk '{ print $2 }'
}

build_pkg() {
  PKG_DIR=3p-"$1"
  if [ -d "${PKG_DIR}" ]; then
    # Control will enter here if $DIRECTORY exists.
    echo "Dependency ${PKG_DIR} appears to already exist."
    return
  fi
  git clone "${GIT_URL}/${PKG_DIR}"
  pushd "${PKG_DIR}"
    xmlstar_rewrite
    if [ ! -f "${AUTOBUILD_CONFIG_FILE}" ]; then
      echo "No dependencies!"
      cp "${AUTOBUILD_CONFIG_FILE_ORIG}" "${AUTOBUILD_CONFIG_FILE}"
    fi
    autobuild install
    autobuild build
    autobuild package > $INFO
    PKG_NAME=$(pkg_get_value $INFO packing)
    FILE_PATH=$(basename $(pkg_get_value $INFO wrote))
    MD5SUM=$(pkg_get_value $INFO md5)
    echo "Writing dependency info..."
    echo $PKG_NAME $MD5SUM $FILE_PATH >> "${PUSH_PATH}/${LIST_FILE}"
    echo "Writing dependency file..."
    cp "${FILE_PATH}" "${PUSH_PATH}"
    echo "Dependency written."
  popd
}

# Third party deps builds
build_pkg fmodstudio

# Non-deps builds
build_pkg zlib
build_pkg expat
build_pkg libidn
build_pkg sdl1
build_pkg uriparser
build_pkg ares
build_pkg glod
build_pkg dbus-glib
build_pkg libjpeg-turbo
build_pkg hunspell
build_pkg google-breakpad
build_pkg gperftools
build_pkg jsoncpp
build_pkg openal
build_pkg oggvorbis

build_pkg libndofdev-open
build_pkg xmlrpc-epi
build_pkg libpng
build_pkg libxml2
build_pkg apr
build_pkg freetype
build_pkg fontconfig
build_pkg openssl
build_pkg curl
build_pkg boost
build_pkg colladadom
build_pkg gtk-atk-pango-glib
build_pkg llceflib
