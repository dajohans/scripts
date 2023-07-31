#!/bin/bash

current_dir=$(dirname $0)
source "$current_dir/utils.sh"

$(gcc_toolchain_setup)
sudo apt install --yes gcc-12 g++-12

