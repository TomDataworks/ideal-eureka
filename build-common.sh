#!/bin/bash

xmlstar_rewrite() {
  rm ${AUTOBUILD_CONFIG_FILE_DEPS} || true
  rm ${AUTOBUILD_CONFIG_FILE} || true
  xmlstarlet sel -t -v "//string[text()='PACKAGE_DEPS_MD5SUM']/../../../../key[text()='name']/../preceding-sibling::key" ${AUTOBUILD_CONFIG_FILE_ORIG} > ${AUTOBUILD_CONFIG_FILE_DEPS}
  while read line
  do
    PACKAGE_DEPS_NAME=`grep $line "${PUSH_PATH}/${LIST_FILE}" | awk '{ print $1 }'`
    PACKAGE_DEPS_MD5SUM=`grep $line "${PUSH_PATH}/${LIST_FILE}" | awk '{ print $2 }'`
    PACKAGE_DEPS_FILENAME=`grep $line "${PUSH_PATH}/${LIST_FILE}" | awk '{ print $3 }'`
    if [ ! -z "${PACKAGE_DEPS_NAME}" ]; then
      echo $PACKAGE_DEPS_NAME $PACKAGE_DEPS_MD5SUM $PACKAGE_DEPS_FILENAME
    fi
    if [ ! -f "${AUTOBUILD_CONFIG_FILE}" ]; then
      cp ${AUTOBUILD_CONFIG_FILE_ORIG} ${AUTOBUILD_CONFIG_FILE}
    fi
    xmlstarlet ed -u "//key[text() = '${PACKAGE_DEPS_NAME}']/following-sibling::map[1]//key[text() = '${PLATFORM}']/following-sibling::map[1]//string[text() = 'PACKAGE_DEPS_MD5SUM']" -v "${PACKAGE_DEPS_MD5SUM}" -u "//key[text() = '${PACKAGE_DEPS_NAME}']/following-sibling::map[1]//key[text() = '${PLATFORM}']/following-sibling::map[1]//string[text() = 'PACKAGE_DEPS_FILENAME']" -v "${DEPS_PATH}/${PACKAGE_DEPS_FILENAME}" $AUTOBUILD_CONFIG_FILE > /tmp/$AUTOBUILD_CONFIG_FILE
    cp /tmp/${AUTOBUILD_CONFIG_FILE} ${AUTOBUILD_CONFIG_FILE}
    # cat ${AUTOBUILD_CONFIG_FILE}
  done < ${AUTOBUILD_CONFIG_FILE_DEPS}
}
