#!/bin/bash

install_terragrunt() {
  curl -LO https://github.com/gruntwork-io/terragrunt/releases/download/$(curl -s \
    https://api.github.com/repos/gruntwork-io/terragrunt/releases/latest | \
    grep tag_name | cut -d '"' -f 4)/terragrunt_linux_amd64
  sudo install -o root -g root -m 0755 terragrunt_linux_amd64 /usr/local/bin/terragrunt
  rm terragrunt_linux_amd64
}
