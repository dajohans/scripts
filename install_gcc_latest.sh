#!/bin/bash

current_dir=$(dirname $0)
source "$current_dir/utils.sh"

$(gcc_toolchain_setup)
sudo apt update
gcc_latest_install
