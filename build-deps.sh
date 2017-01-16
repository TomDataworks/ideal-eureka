#!/bin/bash

GIT_URL=http://github.com/TomDataworks
PUSH_PATH=/mnt/linux/srv/httpd/singularity/ia32
DEPS_PATH=http://dwaggy.tk/singularity/ia32
LIST_FILE=deps.txt
INFO=fileinfo.txt
export AUTOBUILD_CONFIG_FILE=autobuild.xml.new
export DISABLE_UNIT_TESTS=1

pkg_get_value() {
  grep "$2" "$1" | awk '{ print $2 }'
}

xmlstar_rewrite() {
  xmlstarlet sel -t -v "//string[text()='PACKAGE_DEPS_MD5SUM']/../../../../key[text()='name']/../preceding-sibling::key" autobuild.xml > autobuild.xml.deps
  while read line
  do
    PACKAGE_DEPS_NAME=`grep $line "${PUSH_PATH}/${LIST_FILE}" | awk '{ print $1 }'`
    PACKAGE_DEPS_MD5SUM=`grep $line "${PUSH_PATH}/${LIST_FILE}" | awk '{ print $2 }'`
    PACKAGE_DEPS_FILENAME=`grep $line "${PUSH_PATH}/${LIST_FILE}" | awk '{ print $3 }'`
    echo $PACKAGE_DEPS_NAME $PACKAGE_DEPS_MD5SUM $PACKAGE_DEPS_FILENAME
    xmlstarlet ed -u "//key[text() = '${PACKAGE_DEPS_NAME}']/following-sibling::map//key[text() = 'linux']/following-sibling::map[1]//string[text() = 'PACKAGE_DEPS_MD5SUM']" -v "${PACKAGE_DEPS_MD5SUM}" -u "//key[text() = '${PACKAGE_DEPS_NAME}']/following-sibling::map//key[text() = 'linux']/following-sibling::map[1]//string[text() = 'PACKAGE_DEPS_FILENAME']" -v "${DEPS_PATH}/${PACKAGE_DEPS_FILENAME}" autobuild.xml > $AUTOBUILD_CONFIG_FILE
  done < autobuild.xml.deps
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
      cp autobuild.xml "${AUTOBUILD_CONFIG_FILE}"
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
