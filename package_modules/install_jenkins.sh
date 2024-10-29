#!/bin/bash

install_jenkins() {
  if [[ $distro == "Ubuntu/Debian" ]]; then
    $pkg_update
    $pkg_install openjdk-11-jdk
    curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee \
      /usr/share/keyrings/jenkins-keyring.asc >/dev/null
    echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
      https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
      /etc/apt/sources.list.d/jenkins.list >/dev/null
    $pkg_update
    $pkg_install jenkins
  elif [[ $distro == "RedHat/CentOS" ]] || [[ $distro == "Amazon Linux" ]]; then
    $pkg_install java-11-openjdk-devel
    sudo wget -O /etc/yum.repos.d/jenkins.repo \
      https://pkg.jenkins.io/redhat-stable/jenkins.repo
    sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
    $pkg_update
    $pkg_install jenkins
    sudo systemctl start jenkins
    sudo systemctl enable jenkins
  fi
}
