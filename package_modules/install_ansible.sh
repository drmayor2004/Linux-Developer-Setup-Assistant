#!/bin/bash

install_ansible() {
  if [[ $distro == "Ubuntu/Debian" ]]; then
    $pkg_update
    $pkg_install ansible
  elif [[ $distro == "RedHat/CentOS" ]] || [[ $distro == "Amazon Linux" ]]; then
    $pkg_install epel-release
    $pkg_install ansible
  fi
}
