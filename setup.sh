#!/bin/bash

# TODO
#	1. Setup apt mirrors here instead of in gui.
#	2. Compile and install vim and emacs.
#	3. Figure out how to do ssh-add without prompt for passphrase

current_dir=$(dirname $0)
source "$current_dir/utils.sh"

pre_setup_string="# My personal setup:"
post_setup_string="# My personal setup end"

# Apparently, /usr/local/bin is not created by ubuntu.
# But it might be nice to have this local bin directory for programs not handled by any package manager.
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

google_chrome_setup

sudo apt update

# Some nice to have programs
sudo apt install --yes binutils git make gcc g++ bear python3 python3-pip

# Programs for Arduino programming, or avr programming in general
# screen is for viewing serial port output continuously
sudo apt install --yes binutils-avr gcc-avr avr-libc gdb-avr avrdude screen

sudo apt install --yes google-chrome-stable

git config --global user.name "David Johansson"
git config --global user.email "davidjohansson1994@gmail.com"
git config --global core.editor "vi"
# Generate key for github
ssh_key_filename=$HOME/.ssh/id_ed25519
ssh_key_passphrase=KL098E10
if [[ $(file_exists "$ssh_key_filename") = false ]]
then
	ssh-keygen -t ed25519 -C "djohansson@L5P" -f $ssh_key_filename -N "$ssh_key_passphrase"
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
	echo "if [[ -d \"\$HOME/manual-installs/eclipse-jdtls/bin\" ]]" >> $HOME/.environment_variables
	echo "then" >> $HOME/.environment_variables
	echo "	PATH=\"\$PATH:\$HOME/manual-installs/eclipse-jdtls/bin\"" >> $HOME/.environment_variables
	echo "fi" >> $HOME/.environment_variables
	echo "" >> $HOME/.environment_variables
	echo "if [[ -d \"/opt/gradle/gradle-7.6/bin\" ]]" >> $HOME/.environment_variables
	echo "then" >> $HOME/.environment_variables
	echo "	PATH=\"\$PATH:/opt/gradle/gradle-7.6/bin\"" >> $HOME/.environment_variables
	echo "fi" >> $HOME/.environment_variables
	echo "" >> $HOME/.environment_variables
	echo "if [[ -d \"/usr/lib/jvm/java-19-openjdk-amd64\" ]]" >> $HOME/.environment_variables
	echo "then" >> $HOME/.environment_variables
	echo "	JAVA_HOME=\"/usr/lib/jvm/java-19-openjdk-amd64\"" >> $HOME/.environment_variables
	echo "fi" >> $HOME/.environment_variables
fi

if [[ $(file_exists "$HOME/.local/bin/theme.sh") = false ]]
then
	cp theme.sh $HOME/.local/bin/theme.sh
	chmod +x $HOME/.local/bin/theme.sh
fi

if [[ $(file_exists "$HOME/.bashrc_customization") = false ]]
then
	cp .bashrc_customization $HOME/.bashrc_customization
fi

if [[ $(dir_exists "/tmp/scripts") = false ]]
then
	git clone https://github.com/dajohans/scripts.git /tmp/scripts
fi

if [[ $(command_exists emacs) = false ]]
then
	/tmp/scripts/install_emacs.sh
fi

#if [[ $(command_exists vim) = false ]]
#then
#	/tmp/scripts/install_vim.sh
#fi

echo ""
echo ""
echo "*** Some things may not take effect until after a restart since some changes are made to ~/.profile"