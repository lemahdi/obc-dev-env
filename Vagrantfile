# -*- mode: ruby -*-
# vi: set ft=ruby :

# This vagrantfile creates a VM with the development environment
# configured and ready to go.
#
# The setup script (env var $script) in this file installs docker.
# This is not in the setup.sh file because the docker install needs
# to be secure when running on a real linux machine.
# The docker environment that is installed by this script is not secure,
# it depends on the host being secure.
#
# At the end of the setup script in this file, a call is made
# to run setup.sh to create the developer environment.

# This is the mount point for the sync_folders of the source
SRCMOUNT = "/openchain"
HOST_GOPATH = ENV['GOPATH']

$script = <<SCRIPT
set -x

wget -q -O - https://get.docker.io/gpg | apt-key add -
echo deb http://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list
apt-get update -qq
apt-get install -q -y --force-yes linux-image-extra-$(uname -r) lxc-docker curl
usermod -a -G docker vagrant # Add vagrant user to the docker group

echo 'DOCKER_OPTS="-s=aufs -r=true --api-enable-cors=true -H tcp://0.0.0.0:4243 -H unix:///var/run/docker.sock --insecure-registry leanjazz.rtp.raleigh.ibm.com:5000 ${DOCKER_OPTS}"' > /etc/default/docker
service docker restart



cd #{SRCMOUNT}/obc-dev-env
./setup.sh

SCRIPT

Vagrant.configure('2') do |config|
  config.vm.box = "ubuntu/trusty64"

  config.vm.network :forwarded_port, guest: 5000, host: 3000 # Openchain REST services

  config.vm.synced_folder "..", "#{SRCMOUNT}"
  config.vm.synced_folder "#{HOST_GOPATH}/src", "/opt/gopath/src"

  config.vm.provider :virtualbox do |vb|
    vb.name = "openchain"
    vb.customize ['modifyvm', :id, '--memory', '4096']
    vb.cpus = 2
  end

  config.vm.provision :shell, inline: $script
end
