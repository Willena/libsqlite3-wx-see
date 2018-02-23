#!/bin/bash

# Date : 2018-02-15
# Name : update-repo.sh
# Goal : Auto update the current repository
# Deps : curl bash git wget


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


#Firt get the latest tag of WX-SQLite3
TAG_NAME=$(curl -s https://api.github.com/repos/utelle/wxsqlite3/releases/latest | grep tag_name | cut -d '"' -f 4)
LATEST_RELEASED_SOURCES_URL=$(curl -s https://api.github.com/repos/utelle/wxsqlite3/releases/latest | grep zipball_url | cut -d '"' -f 4)

#Clear the repo from old files
rm -rf $_BASE_DIR/src/
rm -rf $_BASE_DIR/tmp/
rm -f $_BASE_DIR/Readme.txt
rm -f $_BASE_DIR/premake5.lua

#Download latest LATEST_RELEASED_SOURCES
mkdir $_BASE_DIR/tmp/
cd $_BASE_DIR/tmp/
wget -O "${TAG_NAME}.zip" "$LATEST_RELEASED_SOURCES_URL"
unzip "${TAG_NAME}.zip"

#Moving things.
cd $_BASE_DIR/tmp/utelle-wxsqlite3-*
cp -R ./sqlite3/secure/* $_BASE_DIR/

cd $_BASE_DIR
rm -rf $_BASE_DIR/tmp/

#Getting sqlite version from header files.
SQLITE_VERSION=$(grep "#define SQLITE_VERSION " src/sqlite3.h | xargs | cut -d ' ' -f 3)

#Using encrypted key
git add .
git commit -m "from wxsqlite3-$TAG_NAME : Updated to SQLite3-$SQLITE_VERSION"
git push --force --quiet "https://${GH_TOKEN}@github.com/Willena/libsqlite3-wx-see"
