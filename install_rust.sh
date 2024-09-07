#!/bin/bash

current_dir=$(dirname $0)
source "$current_dir/utils.sh"

if [[ $(command_exists rustup) = false ]]
then
	curl --proto '=https' --tlsv1.3 https://sh.rustup.rs -sSf | bash -s -- -y
	source $HOME/.cargo/env
fi
