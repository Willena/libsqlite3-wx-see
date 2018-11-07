#!/bin/bash


_SCRIPT_DIR=$(dirname $(readlink -f $0))
_BASE_DIR="$_SCRIPT_DIR/../"
_REPO_URL="https://github.com/Willena/libsqlite3-crypt-auth"

cd $_BASE_DIR
git config --local user.name "Villena Guillaume"
git config --local user.email "guiguivil@gmail.com"

echo "Build on the $BRANCH branch !"
#git checkout -qf master
