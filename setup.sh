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
export GO15VENDOREXPERIMENT=1
PATH=$GOROOT/bin:$GOPATH/bin:$PATH

# Setup golang cross compile
#./golang_crossCompileSetup.sh

# Install NodeJS
./installNodejs.sh

# Install protobuf and compile protos
./golang_grpcSetup.sh

# Install RocksDB
./installRocksDB.sh

# Run go install - CGO flags for RocksDB
cd $GOPATH/src/github.com/openblockchain/obc-peer
CGO_CFLAGS="-I/opt/rocksdb/include" CGO_LDFLAGS="-L/opt/rocksdb -lrocksdb -lstdc++ -lm -lz -lbz2 -lsnappy" go install

# Compile proto files
/openchain/obc-dev-env/compile_protos.sh

# Create directory for the DB
sudo mkdir -p /var/openchain
sudo chown -R vagrant:vagrant /var/openchain

# Ensure permissions are set for GOPATH
sudo chown -R vagrant:vagrant $GOPATH
