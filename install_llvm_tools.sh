#!/bin/bash

current_dir=$(dirname $0)
source "$current_dir/utils.sh"

$(llvm_setup)
sudo apt update
llvm_install
