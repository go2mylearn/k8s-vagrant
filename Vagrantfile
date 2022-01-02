Vagrant.configure("2") do |config|
  # master
  config.vm.define "master" do |master|
    master.vm.box = "centos/7"
    master.vm.hostname = "master"
    master.vm.network "private_network", ip: "192.168.56.100"
    master.vm.provider "vmware_desktop" do |vm|
      vm.vmx["memsize"] = "4096"
      vm.vmx["numvcpus"] = "2"
      vm.gui = true
    end
    master.vm.provision "shell", path: "install-docker.sh"
    master.vm.provision "shell", path: "install-master.sh"
    master.vm.provision "ansible" do |ansible|
      ansible.playbook = "install-master.yml"
    end
  end

  # Kubernetes Worker Nodes
  NodeCount = 2
  (1..NodeCount).each do |i|
    config.vm.define "worker#{i}" do |worker|
      worker.vm.box = "centos/7"
      worker.vm.hostname = "worker#{i}"
      worker.vm.network "private_network", ip: "192.168.56.10#{i}"
      worker.vm.provider "vmware_desktop" do |vm|
        vm.vmx["name"] = "kworker#{i}"
        vm.vmx["memsize"] = "4096"
        vm.vmx["numvcpus"] = "2"
        vm.gui = true
      end
      worker.vm.provision "shell", path: "install-docker.sh"
      worker.vm.provision "shell", path: "install-worker.sh"
      worker.vm.provision "ansible" do |ansible|
        ansible.playbook = "install-worker.yml"
      end
    end
  end
end
