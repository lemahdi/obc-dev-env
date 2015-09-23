#!/bin/bash

helpme()
{
  cat <<HELPMEHELPME
Syntax: sudo $0

Installs the stuff needed to get the VirtualBox Ubuntu (or other similar Linux
host) into good shape to run our development environment.

This script needs to run as root.

The current directory must be the dev-env project directory.

HELPMEHELPME
}

if [[ "$1" == "-?" || "$1" == "-h" || "$1" == "--help" ]] ; then
  helpme
  exit 1
fi

# Installs the stuff needed to get the VirtualBox Ubuntu (or other similar Linux
# host) into good shape to run our development environment.

# ALERT: if you encounter an error like:
# error: [Errno 1] Operation not permitted: 'cf_update.egg-info/requires.txt'
# The proper fix is to remove any "root" owned directories under your update-cli directory
# as source mount-points only work for directories owned by the user running vagrant

# Stop on first error
set -e

# Install Python, pip, behave, nose
apt-get install --yes python-setuptools
apt-get install --yes python-pip
pip install behave
pip install nose

# updater-server, update-engine, and update-service-common dependencies (for running locally)
pip install -I flask==0.10.1 python-dateutil==2.2 pytz==2014.3 pyyaml==3.10 couchdb==1.0 flask-cors==2.0.1 requests==2.4.3

# install ruby and apiaryio
#apt-get install --yes ruby ruby-dev gcc
#gem install apiaryio

# install git
apt-get install --yes git

#install golang
#apt-get install --yes golang
./installGolang.sh

# Set Go environment variables needed by other scripts
export GOPATH="/opt/gopath"
export GOROOT="/opt/go/"
PATH=$GOROOT/bin:$GOPATH/bin:$PATH

# Setup golang cross compile
./golang_crossCompileSetup.sh

# Install NodeJS
./installNodejs.sh

# Install protobuf
./golang_grpcSetup.sh

# Install update CLI
#cd ../update-cli
#rm -f dist/*
#python setup.py install

# Install cf CLI
cd /tmp
wget 'https://cli.run.pivotal.io/stable?release=debian64&version=6.11.3&source=github-rel' -O cf.deb
dpkg -i cf.deb

# Install ice CLI
wget https://static-ice.ng.bluemix.net/icecli-3.0.zip
pip install icecli-3.0.zip

## ----- Install jq  ------------
## First install requirement
#cd /tmp
#wget http://www.geocities.jp/kosako3/oniguruma/archive/onig-5.9.6.tar.gz
#tar -xf onig-5.9.6.tar.gz
#rm onig-5.9.6.tar.gz
#cd onig-5.9.6
#./configure
#make
#sudo make install
#
## Now jq
#sudo apt-get install autoconf
#sudo apt-get install libtool
#sudo apt-get install bison
#cd /tmp
#git clone https://github.com/stedolan/jq.git
#cd jq
## Now build jq
#autoreconf -i
#./configure
#make LDFLAGS=-all-static
#sudo make install
