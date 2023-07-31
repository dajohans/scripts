#!/bin/bash

current_dir=$(dirname $0)
source "$current_dir/utils.sh"

$(google_chrome_setup)
sudo apt update
sudo apt install --yes google-chrome-stable

