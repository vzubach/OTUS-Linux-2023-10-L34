# -*- mode: ruby -*-
# vi: set ft=ruby : vsa

Vagrant.configure(2) do |config| 
 config.vm.box = "ubuntu/jammy64"
 config.vm.provider "virtualbox" do |v| 
  v.memory = 1024 
  v.cpus = 1 
 end 
 config.vm.define "server" do |server| 
  server.vm.network "private_network", ip: "192.168.56.10"
  server.vm.hostname = "server" 
  server.vm.provision "shell", path: "server.sh"
 end 
end
