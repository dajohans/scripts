#!/bin/bash

current_dir=$(dirname $0)
source "$current_dir/utils.sh"

# There are two ppa's with newer gcc versions. The ppa ubuntu-toolchain-r/ppa
# contain newer point releases of the gcc versions available in Ubuntu's
# default repositories. The ppa ubuntu-toolchain-r/test contain new gcc major
# versions, not just newer point releases.
codename=$(ubuntu_codename)
gcc_toolchain_key_path="/etc/apt/keyrings/ubuntu-toolchain-r-ppa-$codename.gpg"
# gcc_toolchain_key_path="/etc/apt/keyrings/ubuntu-toolchain-r-test-$codename.gpg"
if [[ $(file_exists $gcc_toolchain_key_path) = false ]]
then
	sudo add-apt-repository --yes ppa:ubuntu-toolchain-r/ppa
	# sudo add-apt-repository --yes ppa:ubuntu-toolchain-r/test
fi

sudo apt update

# Grep for lines beginning in gcc and ending in a at least two
# digits. We want there to be two digits, because otherwise the
# sorting might get strange, since it seems to prioritize sorting
# word length over the numeric value at the end of the word. Then
# use awk to pick the first word, which is the package name. Then
# sort the list and pick the last element.
gcc=$(apt-cache search gcc | grep '^gcc-[0-9][0-9][[:space:]]' | awk '{print $1;}' | sort | tail -1)
gplusplus=$(apt-cache search g++ | grep '^g++-[0-9][0-9][[:space:]]' | awk '{print $1;}' | sort | tail -1)
sudo apt install --yes $gcc $gplusplus
