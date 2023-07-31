#!/bin/bash

current_dir=$(dirname $0)
source "$current_dir/utils.sh"

$(neovim_setup)
sudo apt update
sudo apt install --yes neovim

