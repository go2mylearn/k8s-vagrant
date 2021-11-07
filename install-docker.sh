#!/bin/sh
sudo yum install -y yum-utils
sudo yum-config-manager  --add-repo   https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install docker-ce-19.03.9 docker-ce-cli-19.03.9 containerd.io -y
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker vagrant
