#!/bin/bash

current_dir=$(dirname $0)
source "$current_dir/utils.sh"

git config --global user.name "David Johansson"
git config --global user.email "davidjohansson1994@gmail.com"
git config --global core.editor "vim"
# Generate key for github
ssh_key_filename=$HOME/.ssh/id_ed25519
ssh_key_passphrase=KL098E10
if [[ $(file_exists "$ssh_key_filename") = false ]]
then
	hostname=$(uname -n)
	ssh-keygen -t ed25519 -C "$USER@$hostname" -f $ssh_key_filename -N "$ssh_key_passphrase"
	eval "$(ssh-agent -s)"
	ssh-add $ssh_key_filename
	# Add the key to github here: https://github.com/settings/keys
fi
