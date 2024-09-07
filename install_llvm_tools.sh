#!/bin/bash

current_dir=$(dirname $0)
source "$current_dir/utils.sh"

# There are 3 ppa's available: one unnumbered and two numbered.
# The unnumbered appear to be for devel and then the two numbered
# are qualification and stable. I'm not sure if there's a way to
# always choose stable.

# apt-key is deprecated. Use gpg instead.  Source for apt-key
# replacement:
# https://askubuntu.com/questions/1441931/ubuntu-22-10-fix-missing-gpg-key
llvm_key_path="/etc/apt/trusted.gpg.d/llvm_key.gpg"
if [[ $(file_exists $llvm_key_path) = false ]]
then
	version=-17 # This is the current stable version
	codename=$(ubuntu_codename)
	# Source for llvm apt repo: https://apt.llvm.org/
	wget -q -O - https://apt.llvm.org/llvm-snapshot.gpg.key | sudo gpg --dearmor -o $llvm_key_path
	sudo add-apt-repository --yes "deb [arch=amd64] http://apt.llvm.org/$codename/ llvm-toolchain-$codename$version main"
	sudo add-apt-repository --yes "deb-src [arch=amd64] http://apt.llvm.org/$codename/ llvm-toolchain-$codename$version main"
fi

sudo apt update

# Grep for lines beginning in clang- and ending in a at least two
# digits. We want there to be two digits, because otherwise the
# sorting might get strange, since it seems to prioritize sorting
# word length over the numeric value at the end of the word. Then
# use awk to pick the first word, which is the package name. Then
# sort the list and choose the latest version.
clang=$(apt-cache search clang | grep '^clang-[0-9][0-9][[:space:]]' | awk '{print $1;}' | sort | tail -1)
clangd=$(apt-cache search clangd | grep '^clangd-[0-9][0-9][[:space:]]' | awk '{print $1;}' | sort | tail -1)
sudo apt install --yes $clang $clangd
