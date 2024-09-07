#!/bin/bash

current_dir=$(dirname $0)
source "$current_dir/utils.sh"

codename=$(ubuntu_codename)
neovim_key_path="/etc/apt/keyrings/neovim-ppa-unstable-$codename.gpg"
if [[ $(file_exists $neovim_key_path) = false ]]
then
	sudo add-apt-repository --yes ppa:neovim-ppa/unstable
fi

sudo apt update
sudo apt install --yes neovim

