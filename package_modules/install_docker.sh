#!/bin/bash

install_docker() {
  if [[ $distro == "Ubuntu/Debian" ]]; then
    $pkg_update
    $pkg_install \
      ca-certificates \
      curl \
      gnupg \
      lsb-release
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg |
      sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
      https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" |
      sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
    $pkg_update
    $pkg_install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  elif [[ $distro == "RedHat/CentOS" ]] || [[ $distro == "Amazon Linux" ]]; then
    $pkg_update
    $pkg_install yum-utils
    sudo yum-config-manager \
      --add-repo \
      https://download.docker.com/linux/centos/docker-ce.repo
    $pkg_install docker-ce docker-ce-cli containerd.io docker-compose-plugin
    sudo systemctl start docker
    sudo systemctl enable docker
  fi
}
