#!/bin/bash

# Date : 2018-02-15
# Name : build-all*.sh
# Goal : Auto build the current repository : all elements CLI + Libs
# Deps :

_SCRIPT_DIR=$(dirname $(readlink -f $0))
_BASE_DIR=$_SCRIPT_DIR/../
_REPO_URL="https://github.com/Willena/libsqlite3-crypt-auth"

source $_SCRIPT_DIR/git-config.sh

#------------------------------------------------------------------------------
#
#  This script has been writen by Willena (Guillaume Villena), it's purpose is
#  to update/build the current repository using Travis-ci using latest releases
#  of the SQLite library with encryption extention maintained in the WX-SQLite
#  repo (https://github.com/utelle/wxsqlite3/).
#
#  It not my work. In case of issue using the lib, checkout the issue page of
#  the WX-SQLite repository.
#
#  If these scripts are faulty, then open an issue here. I'll be happy to help
#  you.
#
#


if [[ -z "$TYPE" ]]; then
  echo "No build type provided.. Exiting..."
fi

echo "Build for $TYPE"
echo "Downloading premake5 from website"
wget -O "$_BASE_DIR/premake.tar.gz" "https://github.com/premake/premake-core/releases/download/v5.0.0-alpha12/premake-5.0.0-alpha12-linux.tar.gz"
tar -xvzf "$_BASE_DIR/premake.tar.gz"

echo "Generate makefiles"

$_BASE_DIR/premake5 --file=premake5-lin.lua gmake
cd $_BASE_DIR/build/ && cat Makefile
cd $_BASE_DIR/build/ && make verbose=1
