#!/bin/bash

# Source the modules
source ./distro_selection.sh
source ./utils.sh

# Initialize error report
declare -A error_report

# Select Linux distribution
select_distro

# Check and install prerequisites
check_prerequisites

# List of available packages
available_packages=(
  "Docker"
  "Docker Compose"
  "Jenkins"
  "Git"
  "Kubernetes"
  "AWS CLI"
  "Ansible"
  "Terraform"
  "Terragrunt"
)

# Function to display available packages
display_packages() {
  echo "Available packages:"
  for pkg in "${available_packages[@]}"; do
    echo "- $pkg"
  done
}

# Convert available packages to lowercase for case-insensitive comparison
declare -A available_packages_lower
for pkg in "${available_packages[@]}"; do
  available_packages_lower["${pkg,,}"]="$pkg"
done

# Main menu
echo "Select an option:"
echo "1. Install all packages"
echo "2. Select packages to install"
echo "3. Install a specific package by name"

read -p "Enter your choice (1/2/3): " main_choice

case $main_choice in
  1)
    # Install all packages
    packages=("${available_packages[@]}")
    ;;
  2)
    # Install selected packages
    packages_to_install=()
    for package in "${available_packages[@]}"; do
      read -p "Do you want to install $package? (y/n): " choice
      if [[ $choice =~ ^[Yy]$ ]]; then
        packages_to_install+=("$package")
      else
        echo "Skipping $package."
      fi
    done
    packages=("${packages_to_install[@]}")
    ;;
  3)
    # Install a specific package by name
    display_packages
    read -p "Enter the name of the package you want to install (case-insensitive): " package_name
    package_name_lower=${package_name,,}
    # Search for the package
    if [[ -n "${available_packages_lower[$package_name_lower]}" ]]; then
      found_package="${available_packages_lower[$package_name_lower]}"
      read -p "Package '$found_package' found. Do you want to install it? (y/n): " confirm_install
      if [[ $confirm_install =~ ^[Yy]$ ]]; then
        packages=("$found_package")
      else
        echo "Installation of '$found_package' canceled."
        packages=()
      fi
    else
      echo "Package '$package_name' not found."
      exit 1
    fi
    ;;
  *)
    echo "Invalid choice. Exiting."
    exit 1
    ;;
esac

# Install selected packages
for package in "${packages[@]}"; do
  install_package "$package"
done

# Generate installation report
echo -e "\nInstallation Report:"

echo -e "\nPackages that installed successfully:"
if [ ${#successfully_installed_packages[@]} -gt 0 ]; then
  for pkg in "${successfully_installed_packages[@]}"; do
    echo "- $pkg"
  done
else
  echo "No packages were successfully installed."
fi

if [ ${#error_report[@]} -gt 0 ]; then
  echo -e "\nPackages that failed to install:"
  for pkg in "${!error_report[@]}"; do
    echo "- $pkg: ${error_report[$pkg]}"
  done
else
  echo -e "\nAll packages were installed successfully."
fi
