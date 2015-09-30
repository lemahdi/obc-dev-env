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


set -e
set -x

SRCROOT="/opt/go"
SRCPATH="/opt/gopath"

# Get the ARCH
#ARCH=`uname -m | sed 's|i686|386|' | sed 's|x86_64|amd64|'`
ARCH=amd64
## Install Go
#sudo apt-get update
#sudo apt-get install -y build-essential git-core

# Install Go
GO_VER=1.4.2

cd /tmp
rm -f go$GO_VER.linux-${ARCH}.tar.gz
wget --quiet --no-check-certificate https://storage.googleapis.com/golang/go$GO_VER.linux-${ARCH}.tar.gz
tar -xvf go$GO_VER.linux-${ARCH}.tar.gz
sudo mv go $SRCROOT
sudo chmod 775 $SRCROOT
sudo chown -R vagrant:vagrant $SRCROOT
rm go$GO_VER.linux-${ARCH}.tar.gz


# Setup the GOPATH; even though the shared folder spec gives the consul
# directory the right user/group, we need to set it properly on the
# parent path to allow subsequent "go get" commands to work. We can't do
# normal -R here because VMWare complains if we try to update the shared
# folder permissions, so we just update the folders that matter.
sudo mkdir -p $SRCPATH
sudo mkdir -p $SRCPATH/pkg
sudo mkdir -p $SRCPATH/bin
sudo chown -R vagrant:vagrant $SRCPATH
#find /opt/gopath -type d -maxdepth 3 | xargs sudo chown vagrant:vagrant
cat <<EOF >/tmp/gopath.sh
export GOPATH="$SRCPATH"
export GOROOT="$SRCROOT"
export PATH="$SRCROOT/bin:$SRCPATH/bin:\$PATH"
EOF
sudo mv /tmp/gopath.sh /etc/profile.d/gopath.sh
sudo chmod 0755 /etc/profile.d/gopath.sh
source /etc/profile.d/gopath.sh
# Install go tools
go get golang.org/x/tools/cmd/cover
