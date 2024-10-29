#!/bin/bash

# Initialize success report
successfully_installed_packages=()

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Function to check and install prerequisites
check_prerequisites() {
  declare -A prerequisites

  if [[ $distro == "Ubuntu/Debian" ]]; then
    prerequisites=( ["curl"]="curl" ["unzip"]="unzip" ["gpg"]="gnupg" )
  elif [[ $distro == "RedHat/CentOS" ]] || [[ $distro == "Amazon Linux" ]]; then
    prerequisites=( ["curl"]="curl" ["unzip"]="unzip" ["gpg"]="gnupg2" )
  fi

  for cmd in "${!prerequisites[@]}"; do
    if ! command_exists "$cmd"; then
      echo "$cmd is not installed. Installing ${prerequisites[$cmd]}..."
      $pkg_install "${prerequisites[$cmd]}"
    else
      echo "$cmd is already installed."
    fi
  done
}

# Main installation function
install_package() {
  local package=$1
  local attempt=1
  local max_attempts=2
  local success=0

  while [ $attempt -le $max_attempts ]; do
    case $package in
      "Docker")
        source ./package_modules/install_docker.sh
        install_docker
        command_exists docker && success=1
        ;;
      "Docker Compose")
        source ./package_modules/install_docker_compose.sh
        install_docker_compose
        command_exists docker-compose && success=1
        ;;
      "Jenkins")
        source ./package_modules/install_jenkins.sh
        install_jenkins
        command_exists jenkins || systemctl status jenkins >/dev/null 2>&1 && success=1
        ;;
      "Git")
        source ./package_modules/install_git.sh
        install_git
        command_exists git && success=1
        ;;
      "Kubernetes")
        source ./package_modules/install_kubernetes.sh
        install_kubernetes
        command_exists kubectl && success=1
        ;;
      "AWS CLI")
        source ./package_modules/install_aws_cli.sh
        install_aws_cli
        command_exists aws && success=1
        ;;
      "Ansible")
        source ./package_modules/install_ansible.sh
        install_ansible
        command_exists ansible && success=1
        ;;
      "Terraform")
        source ./package_modules/install_terraform.sh
        install_terraform
        command_exists terraform && success=1
        ;;
      "Terragrunt")
        source ./package_modules/install_terragrunt.sh
        install_terragrunt
        command_exists terragrunt && success=1
        ;;
      *)
        echo "Unknown package: $package"
        error_report["$package"]="Package script not found."
        return
        ;;
    esac

    if [ $success -eq 1 ]; then
      echo "$package installed successfully."
      successfully_installed_packages+=("$package")
      break
    else
      if [ $attempt -lt $max_attempts ]; then
        echo "Failed to install $package. Retrying..."
      else
        echo "Failed to install $package after $max_attempts attempts."
        error_report["$package"]="Installation failed."
      fi
      attempt=$((attempt + 1))
    fi
  done
}
