#!/bin/bash

# TODO
#	1. Setup apt mirrors here instead of in gui.
#	2. Compile and install vim and emacs.
#	3. Figure out how to do ssh-add without prompt for passphrase

current_dir=$(dirname $0)
source "$current_dir/utils.sh"

pre_setup_string="# My personal setup:"
post_setup_string="# My personal setup end"

# Apparently, $HOME/bin is not created by ubuntu.  But it might be
# nice to have this local bin directory for programs not handled by
# any package manager.
if [[ $(dir_exists "$HOME/bin") = false ]]
then
	mkdir -p $HOME/bin
fi

# Apparently, /usr/local/bin is not created by ubuntu.  But it might
# be nice to have this local bin directory for programs not handled by
# any package manager.
if [[ $(dir_exists "/usr/local/bin") = false ]]
then
	sudo mkdir -p /usr/local/bin
fi

# Similarly, just want to ensure ~/.local/bin exists.
if [[ $(dir_exists "$HOME/.local/bin") = false ]]
then
	mkdir -p $HOME/.local/bin
fi

# Similarly, just want to ensure ~/manual-installs exists.
if [[ $(dir_exists "$HOME/manual-installs") = false ]]
then
	mkdir -p $HOME/manual-installs
	echo "" >> $HOME/manual-installs/NOTES.txt
	echo "This directory is supposed to contain any program which is not installed using" >> $HOME/manual-installs/NOTES.txt
	echo "apt or other package managers. This could for example be:" >> $HOME/manual-installs/NOTES.txt
	echo "	1. programs built from source, like Emacs, Vim or Sioyek" >> $HOME/manual-installs/NOTES.txt
	echo "	2. programs that are already built but which provide scripts to setup" >> $HOME/manual-installs/NOTES.txt
	echo "	   things like symlinks, desktop icons and menu icons, like Arduino IDE." >> $HOME/manual-installs/NOTES.txt
	echo "" >> $HOME/manual-installs/NOTES.txt
	echo "Ideally, these programs should also have a script or makefile to uninstall the" >> $HOME/manual-installs/NOTES.txt
	echo "program. Therefore, these directories should be kept even after installation." >> $HOME/manual-installs/NOTES.txt
fi

source "$current_dir/gnome_terminal_settings.sh"
source "$current_dir/desktop_font_settings.sh"
source "$current_dir/install_llvm_tools.sh"
source "$current_dir/install_gcc_latest.sh"
source "$current_dir/install_chrome.sh"
# NOTE: Installation of texlive-full gets stuck at:
#     Pregenerating ConTeXt MarkIV format. This may take some time...
# Apparently it's waiting for input, but doesn't say anything about that.
# Pressing Enter a bunch(more than just once or twice) of times tend to make
# the installation continue
# source "$current_dir/install_texlive_full.sh"
source "$current_dir/install_texlive_minimal.sh"

sudo apt update

avr_install
# texlab_install
# jdtls_install
# rust_analyzer_install

# Some nice to have programs
sudo apt install --yes binutils git make cmake gcc g++ bear python3 python3-pip python-is-python3

git config --global user.name "David Johansson"
git config --global user.email "davidjohansson1994@gmail.com"
git config --global core.editor "vi"
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

if [[ $(file_contains_string "$HOME/.bashrc" "$pre_setup_string") = false ]]
then
	echo "" >> ~/.bashrc
	echo "$pre_setup_string" >> ~/.bashrc
	echo "if [[ -f \"\$HOME/.bashrc_customization\" ]]" >> ~/.bashrc
	echo "then" >> ~/.bashrc
	echo "	source \$HOME/.bashrc_customization" >> ~/.bashrc
	echo "fi" >> ~/.bashrc
	echo "$post_setup_string" >> ~/.bashrc
fi

if [[ $(file_contains_string "$HOME/.profile" "$pre_setup_string") = false ]]
then
	echo "" >> ~/.profile
	echo "$pre_setup_string" >> ~/.profile
	echo "if [[ -f \"\$HOME/.environment_variables\" ]]" >> ~/.profile
	echo "then" >> ~/.profile
	echo "	source \$HOME/.environment_variables" >> ~/.profile
	echo "fi" >> ~/.profile
	echo "$post_setup_string" >> ~/.profile
fi

if [[ $(file_exists "$HOME/.environment_variables") = false ]]
then
	echo "if [[ -d \"\$HOME/manual-installs/texlab\" ]]" >> $HOME/.environment_variables
	echo "then" >> $HOME/.environment_variables
	echo "	export PATH=\"\$PATH:\$HOME/manual-installs/texlab\"" >> $HOME/.environment_variables
	echo "fi" >> $HOME/.environment_variables
	echo "" >> $HOME/.environment_variables
	echo "if [[ -d \"\$HOME/manual-installs/eclipse-jdtls/bin\" ]]" >> $HOME/.environment_variables
	echo "then" >> $HOME/.environment_variables
	echo "	export PATH=\"\$PATH:\$HOME/manual-installs/eclipse-jdtls/bin\"" >> $HOME/.environment_variables
	echo "fi" >> $HOME/.environment_variables
	echo "" >> $HOME/.environment_variables
	echo "if [[ -d \"/opt/gradle/gradle-7.6/bin\" ]]" >> $HOME/.environment_variables
	echo "then" >> $HOME/.environment_variables
	echo "	export PATH=\"\$PATH:/opt/gradle/gradle-7.6/bin\"" >> $HOME/.environment_variables
	echo "fi" >> $HOME/.environment_variables
	echo "" >> $HOME/.environment_variables
	echo "if [[ -d \"/usr/lib/jvm/java-19-openjdk-amd64\" ]]" >> $HOME/.environment_variables
	echo "then" >> $HOME/.environment_variables
	echo "	export JAVA_HOME=\"/usr/lib/jvm/java-19-openjdk-amd64\"" >> $HOME/.environment_variables
	echo "fi" >> $HOME/.environment_variables
	echo "" >> $HOME/.environment_variables
	echo "if [[ -d \"\$HOME/gems\" ]]" >> $HOME/.environment_variables
	echo "then" >> $HOME/.environment_variables
	echo "	export GEM_HOME=\"\$HOME/gems\"" >> $HOME/.environment_variables
	echo "	export PATH=\"\$HOME/gems/bin\"" >> $HOME/.environment_variables
	echo "fi" >> $HOME/.environment_variables
fi

if [[ $(file_exists "$HOME/.local/bin/theme.sh") = false ]]
then
	cp theme.sh $HOME/.local/bin/theme.sh
fi

if [[ $(file_exists "$HOME/.bashrc_customization") = false ]]
then
	cp .bashrc_customization $HOME/.bashrc_customization
fi

if [[ $(command_exists nvim) = false ]]
then
	./install_neovim.sh
fi

if [[ $(command_exists emacs) = false ]]
then
	./install_emacs.sh
fi

if [[ $(command_exists vim) = false ]]
then
	# Default vim on Linux Mint appear to be vim-common & vim-tiny
	# sudo apt remove --yes vim-common vim-tiny vim vim-runtime vim-nox
	# Perhaps better to just remove anything Vim related
	sudo apt remove --yes vim*
	./install_vim.sh
fi

if [[ $(command_exists sioyek) = false ]]
then
	./install_sioyek.sh
fi

echo ""
echo ""
echo "*** Some things may not take effect until after a restart since some changes are made to ~/.profile"
