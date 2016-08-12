Vagrant.configure(2) do |config|
  config.vm.define "swift" do |node|
    node.vm.box = "bento/ubuntu-14.04"
  end

  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--memory", "2048"]
  end

  config.vm.network "forwarded_port", guest: 7777, host: 7777
  config.vm.provision "shell", path: "setup_swift.sh"
end
