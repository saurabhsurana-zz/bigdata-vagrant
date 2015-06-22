# -*- mode: ruby -*-
# vi: set ft=ruby :

RAM = 4096
CPU = 4

BIGDATA_SOURCE_DIR = ENV['BIGDATA_SOURCE_DIR'] || raise('Please set env variable "BIGDATA_SOURCE_DIR')
BIGDATA_SYNC_DIR = ENV['BIGDATA_SYNC_DIR'] || "/home/vagrant/bigdata"

# ########################################
# other variables

# ########################################

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "juice/box-apple-trusty-xl"

  if BIGDATA_SOURCE_DIR
	config.vm.synced_folder BIGDATA_SOURCE_DIR, BIGDATA_SYNC_DIR, create: true, type: "rsync",
		rsync__auto: true,
		rsync__args: ["--verbose", "--archive", "-z", "--copy-links"]

    config.vm.provision "check_git_patch", type: "shell", run: "always" do |s|
        s.path = "check_git_patch.bash"
        s.args = [BIGDATA_SOURCE_DIR, BIGDATA_SYNC_DIR]
    end
    config.vm.provision "dev-bootstrap", type: "shell", run: "always" do |s|
        s.path = "dev-bootstrap.bash"
    end
    config.vm.provision "build_and_deploy_ambari", type: "shell", run: "always" do |s|
        s.path = "build_and_deploy_ambari.bash"
        s.args = [BIGDATA_SOURCE_DIR, BIGDATA_SYNC_DIR]
    end
  end

  # ########################################
  # other sync directories/provisioning scripts
  
  # ########################################

  config.vm.network "forwarded_port", guest: 3380, host: 18085, protocol: 'tcp'
  config.vm.network "forwarded_port", guest: 5005, host: 15005, protocol: 'tcp'
  config.vm.network "forwarded_port", guest: 8080, host: 18086, protocol: 'tcp'
  config.vm.network "forwarded_port", guest: 2222, host: 12222, protocol: 'tcp'

  # ########################################
  # add other ports

  # ########################################

  config.vm.provider "vmware_fusion" do |v|
    v.vmx["memsize"] = RAM
    v.vmx["numvcpus"] = CPU
  end

  config.vm.define :"bigdata-dev" do |v|
  end
   
end
