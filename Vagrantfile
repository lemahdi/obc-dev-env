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

cd #{SRCMOUNT}/obc-dev-env
./setup.sh

SCRIPT

Vagrant.configure('2') do |config|
  config.vm.box = "obc/dev-env"
  config.vm.box_version = "0.1.1"

  config.vm.network :forwarded_port, guest: 5000, host: 3000 # Openchain REST services

  config.vm.synced_folder "..", "#{SRCMOUNT}"
  config.vm.synced_folder "#{HOST_GOPATH}/src/github.com/openblockchain/obc-peer", "/opt/gopath/src/github.com/openblockchain/obc-peer"

  config.vm.provider :virtualbox do |vb|
    vb.name = "openchain"
    vb.customize ['modifyvm', :id, '--memory', '4096']
    vb.cpus = 2
  end

  config.vm.provision :shell, inline: $script
end
