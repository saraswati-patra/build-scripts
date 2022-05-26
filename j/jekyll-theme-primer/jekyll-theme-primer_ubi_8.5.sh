#!/bin/bash -e
# -----------------------------------------------------------------------------
#
# Package	: jekyll-theme-primer
# Version	: v0.5.3
# Source repo	: https://github.com/pages-themes/primer
# Tested on	: UBI: 8.5
# Language      : Ruby
# Travis-Check  : False
# Script License: Apache License, Version 2 or later
# Maintainer	: Sunidhi Gaonkar<Sunidhi.Gaonkar@ibm.com>
#
# Disclaimer: This script has been tested in root mode on given
# ==========  platform using the mentioned version of the package.
#             It may not work as expected with newer versions of the
#             package and/or distribution. In such case, please
#             contact "Maintainer" of this script.
#
# ----------------------------------------------------------------------------

PACKAGE_NAME=primer
PACKAGE_VERSION=${1:-v0.5.3}
PACKAGE_URL=https://github.com/pages-themes/primer

yum -y update && yum install -y nodejs nodejs-devel nodejs-packaging npm python38 python38-devel ncurses git jq curl make gcc-c++ procps gnupg2 ruby libcurl-devel libffi-devel ruby-devel redhat-rpm-config sqlite sqlite-devel java-1.8.0-openjdk-devel rubygem-rake

gem install bundle
gem install bundler:1.17.3
gem install kramdown-parser-gfm

mkdir -p /home/tester/output
cd /home/tester

git clone $PACKAGE_URL
cd $PACKAGE_NAME
git checkout $PACKAGE_VERSION

sed -i '1i # frozen_string_literal: true\n' Gemfile
sed -i "$ a\gem 'kramdown-parser-gfm'" Gemfile
sed -i '1i # frozen_string_literal: true\n' jekyll-theme-primer.gemspec
sed -i "16i\  s.required_ruby_version = '>= 2.4.0'" jekyll-theme-primer.gemspec
sed -i '2i # frozen_string_literal: true' script/validate-html
sed -i '15s/     //' jekyll-theme-primer.gemspec
sed -i '17s/      //' jekyll-theme-primer.gemspec

if ! script/bootstrap; then
	echo "------------------Build_fails---------------------"
	exit 1
else
	echo "------------------Build_success-------------------------"
	
fi

chmod u+x script/cibuild

if ! script/cibuild; then
	echo "------------------Test_fails---------------------"
	exit 1
else
	echo "------------------Test_success-------------------------"
	
fi

# Tested on VM, everything worked.

# On Travis it's failing due to encoding. Hence, disabling the Travis check.

#   ******* VM test results *******

# 3 files inspected, no offenses detected
# Checking index.html...
# Valid!
#  Successfully built RubyGem
#  Name: jekyll-theme-primer
#  Version: 0.5.3
#  File: jekyll-theme-primer-0.5.3.gem
# ------------------Test_success-------------------------