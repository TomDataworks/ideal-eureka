#!/bin/bash

. ./build-settings.sh
. ./build-common.sh

pushd ${VIEWER_PATH}
  xmlstar_rewrite
  autobuild install
  pushd build-linux-i686
    autobuild configure -cRelease -plinux -- -DFMODSTUDIO:BOOL=ON -DPACKAGE:BOOL=ON
    ionice -c 3 make -j4
  popd
popd
