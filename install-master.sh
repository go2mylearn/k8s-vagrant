sudo systemctl start firewalld
sudo systemctl enable firewalld
sudo firewall-cmd --permanent --add-port={6443,2379,2380,10248,10250,10251,10252}/tcp
sudo firewall-cmd --permanent --add-port={179,5473,443,6443}/tcp
sudo firewall-cmd --reload

sudo cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF

# Set SELinux in permissive mode (effectively disabling it)
sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=disabled/' /etc/selinux/config

sudo yum install -y kubelet-1.20.1 kubeadm-1.20.1 kubectl-1.20.1  --disableexcludes=kubernetes

sudo systemctl enable --now kubelet

sudo cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system
sudo modprobe br_netfilter

sudo swapoff -a
sudo sed -e '/swap/s/^/#/g' -i /etc/fstab

sudo kubeadm config images pull


sudo kubeadm init    --apiserver-advertise-address=`ifconfig | grep 192.168.56. | awk  '{ print $2 }'`  --pod-network-cidr=192.168.0.0/16

sudo mkdir /home/vagrant/.kube
sudo cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
sudo chown -R vagrant:vagrant /home/vagrant/.kube

