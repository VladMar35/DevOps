Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-20.04"
  config.vm.define "router" do |router|
    router.vm.provider "virtualbox" do |vb_router|
    end
    router.vm.hostname = "router"
    router.vm.network "private_network", ip: "172.16.0.1"
    end 
  config.vm.define "vmA" do |vmA| 

    vmA.vm.hostname = "vmA"
    vmA.vm.network "private_network", ip: "172.16.0.2"
    vmA.vm.network "private_network", ip: "192.168.100.1"
    end
  config.vm.define "vmB" do |vmB|
    
    vmB.vm.hostname = "vmB"
    vmB.vm.network "private_network", ip: "192.168.100.2"
    vmB.vm.network "private_network", ip: "192.168.101.1"
    end
  config.vm.define "vmC" do |vmC|
    
    vmC.vm.hostname = "vmC"
    vmC.vm.network "private_network", ip: "192.168.100.3"
    vmC.vm.network "private_network", ip: "192.168.102.1"
    end
  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "playbook.yaml"
    ansible.groups = {
      "group1" => ["router"],
      "group2" => ["vmA"], 
      "group3" => ["vmB"],
      "group4" => ["vmC"],
    }
  end
end
