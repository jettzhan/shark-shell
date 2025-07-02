#!/bin/bash

# open euler 安装docker

function download(){
  sudo curl -fsSL https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/centos/docker-ce.repo -o /etc/yum.repos.d/docker-ce.repo

  sudo sed -i 's#https://download.docker.com#https://mirrors.tuna.tsinghua.edu.cn/docker-ce#' /etc/yum.repos.d/docker-ce.repo

  sudo sed -i 's#$releasever#7#g' /etc/yum.repos.d/docker-ce.repo

  sudo yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

  sudo yum list docker-ce --showduplicates | sort -r

}

function config_docker() {
    sudo mkdir -p /etc/docker
    sudo tee /etc/docker/daemon.json <<EOF
    {
        "registry-mirrors": [
            "https://docker.xuanyuan.me"
        ]
    }
EOF
    sudo systemctl daemon-reload
    sudo systemctl restart docker
}

download
config_docker