#!/bin/bash

# Date : 2018-02-15
# Name : create-release.sh
# Goal : Auto release the current repository : all elements CLI + Libs
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


#Just create a tag on master

TAG_NAME=$(curl -s https://api.github.com/repos/utelle/wxsqlite3/releases/latest | grep tag_name | cut -d '"' -f 4)
SQLITE_VERSION=$(grep "#define SQLITE_VERSION " src/sqlite3.h | xargs | cut -d ' ' -f 3)

echo "The tag name is '$TAG_NAME'"
echo "The Sqlite Version is '$SQLITE_VERSION'"

NEW_TAG=$(echo "wx-$TAG_NAME/sqlite3-$SQLITE_VERSION" | sed -re 's|[^a-zA-Z0-9.\/-]||g')
SQLITE_VERSION=$(echo $SQLITE_VERSION | sed -re 's|[^a-zA-Z0-9.\/-]||g')

echo "The new tag is '$NEW_TAG'"

git tag -f "$NEW_TAG"
git tag -f "$SQLITE_VERSION"
git push --force --tags --quiet "https://${GH_TOKEN}@github.com/Willena/libsqlite3-wx-see"
