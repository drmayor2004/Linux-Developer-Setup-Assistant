#!/bin/bash

# Function to select Linux distribution
select_distro() {
  # Supported Linux distributions
  distros=(
    "Ubuntu/Debian"
    "RedHat/CentOS"
    "Amazon Linux"
  )

  echo "Select your Linux distribution:"
  select distro in "${distros[@]}"; do
    case $distro in
      "Ubuntu/Debian")
        pkg_update="sudo apt-get update"
        pkg_install="sudo apt-get install -y"
        ;;
      "RedHat/CentOS")
        pkg_update="sudo yum update -y"
        pkg_install="sudo yum install -y"
        ;;
      "Amazon Linux")
        pkg_update="sudo yum update -y"
        pkg_install="sudo yum install -y"
        ;;
      *)
        echo "Invalid selection. Please try again."
        continue
        ;;
    esac
    break
  done
}
