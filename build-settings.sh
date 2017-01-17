#!/bin/bash

GIT_URL=http://github.com/TomDataworks
PUSH_PATH=/mnt/linux/srv/httpd/singularity/ia32
DEPS_PATH=http://dwaggy.tk/singularity/ia32
LIST_FILE=deps.txt
PLATFORM=linux

THIRDPARTY_PATH=$PWD/ThirdPartyFiles
VIEWER_PATH=$PWD/SingularityViewer

export AUTOBUILD_CONFIG_FILE=autobuild.xml.new
export AUTOBUILD_CONFIG_FILE_DEPS=autobuild.xml.deps
export AUTOBUILD_CONFIG_FILE_ORIG=autobuild.xml
