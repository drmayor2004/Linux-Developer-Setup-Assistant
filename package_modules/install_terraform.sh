#!/bin/bash

install_terraform() {
  if [[ $distro == "Ubuntu/Debian" ]]; then
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
    sudo apt-add-repository \
      "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
    $pkg_update
    $pkg_install terraform
  elif [[ $distro == "RedHat/CentOS" ]] || [[ $distro == "Amazon Linux" ]]; then
    sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
    $pkg_install terraform
  fi
}
