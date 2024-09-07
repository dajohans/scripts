#!/bin/bash

current_dir=$(dirname $0)
source "$current_dir/utils.sh"

# Source: https://www.digitalocean.com/community/tutorials/install-chrome-on-linux-mint
# apt-key is deprecated. Use gpg instead.
# Source for apt-key replacement: https://askubuntu.com/questions/1441931/ubuntu-22-10-fix-missing-gpg-key
chrome_key_path="/etc/apt/trusted.gpg.d/google_chrome_key.gpg"
if [[ $(file_exists $chrome_key_path) = false ]]
then
	wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o $chrome_key_path
	# Digital Ocean doens't suggest adding [arch=amd64]. But if
	# you don't then you get a warning about missing i386
	# packages.
	echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee --append /etc/apt/sources.list.d/google-chrome.list
	# For some reason, add-apt-repository seems to add duplicate
	# repository entries. So now we do it manually and ensure it's
	# added only once.
	# sudo add-apt-repository --yes "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main"
fi

sudo apt update
sudo apt install --yes google-chrome-stable
