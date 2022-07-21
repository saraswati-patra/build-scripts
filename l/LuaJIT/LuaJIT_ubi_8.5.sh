#!/bin/bash -e
# ----------------------------------------------------------------------------
# Package          : LuaJIT
# Version          : Luajit-2.1.0-beta3
# Source repo      : https://github.com/PPC64/LuaJIT.git
# Tested on        : UBI 8.5
# Language         : C
# Travis-Check     : True
# Script License   : Apache License, Version 2 or later
# Maintainer       : Saraswati Patra <saraswati.patra@ibm.com>
#
# Disclaimer       : This script has been tested in root mode on given
# ==========         platform using the mentioned version of the package.
#                    It may not work as expected with newer versions of the
#                    package and/or distribution. In such case, please
#                    contact "Maintainer" of this script.
#   
# ----------------------------------------------------------------------------
# Variables
PACKAGE_NAME="LuaJIT"
#PACKAGE_VERSION=${1:-Luajit-2.1.0-beta3}
PACKAGE_URL="https://github.com/PPC64/LuaJIT.git"
yum update -y --allowerasing --nobest
yum install -y vim cmake make git gcc-c++ perl
OS_NAME=`cat /etc/os-release | grep PRETTY_NAME | cut -d '=' -f2 | tr -d '"'`
HOME_DIR=`pwd`

#Check if package exists
if [ -d "$PACKAGE_NAME" ] ; then
  rm -rf $PACKAGE_NAME
  echo "$PACKAGE_NAME  | $OS_NAME | GitHub | Removed existing package if any"
fi

if ! git clone $PACKAGE_URL $PACKAGE_NAME; then
    echo "------------------$PACKAGE_NAME:clone_fails---------------------------------------"
    echo "$PACKAGE_URL $PACKAGE_NAME"
    echo "$PACKAGE_NAME  |  $PACKAGE_URL | $OS_NAME | GitHub | Fail |  Clone_Fails"
    exit 1
fi

cd "$HOME_DIR"/$PACKAGE_NAME || exit 1
#git checkout "$PACKAGE_VERSION"

if ! make && make install ; then
    echo "------------------$PACKAGE_NAME:Build_fails-------------------------------------"
    echo "$PACKAGE_URL $PACKAGE_NAME"
    echo "$PACKAGE_NAME  |  $PACKAGE_URL | $OS_NAME | GitHub | Fail |  Install_Fails"
    exit 1
fi

#install_success_but_test not available .
#Not used PACKAGE_VERSION ,here url directly merged with luajit-2.1.0-beta3 after cloned we can build and install direct in side package directory
