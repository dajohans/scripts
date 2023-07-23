#!/bin/bash

sudo apt install --yes git 

sudo rm -rf /opt/emacs29

sudo git clone --depth 1 --branch emacs-29 https://github.com/emacs-mirror/emacs /opt/emacs29

cd /opt/emacs29/

# Since gcc is used below, also needed for building Emacs
sudo apt install --yes build-essential

gcc_version=$(gcc --version | grep gcc | awk 'NF>1{print $NF}' | awk -F\. '{print $1}')
gccjit_dev_package=libgccjit-$gcc_version-dev

# Remove any one of the following packages and ./configure fails
sudo apt install --yes \
	autoconf \
	texinfo \
	libgtk-3-dev \
	$gccjit_dev_package \
	libgccjit0 \
	libtree-sitter-dev \
	libtree-sitter0 \
	libjansson-dev \
	libjansson4 \
 	libgnutls28-dev \
 	libgif-dev \
 	libxpm-dev \
	libncurses-dev \
	librsvg2-dev \
	libsqlite3-dev
# Installing libgtk-3-dev results in installing several other Emacs dependencis.
# A probably nonexhaustive list:
#	libcairo2-dev
#	libfreetype-dev
#	libharfbuzz-dev
#	libjpeg-dev
#	libpng-dev
#	libtiff-dev

# The && will cause the script to stop prematurely if a command fails
sudo ./autogen.sh && \
sudo ./configure \
--with-native-compilation \
--with-tree-sitter \
--with-json \
--with-rsvg \
--with-sqlite3 \
--with-mailutils && \
sudo make -j16 && \
sudo make install
# I don't use mailutils but ./configure complains unless
# --with-mailutils is used.  Also, --with-tree-sitter and --with-json
# appear not to be necessary since they are on by default, but I
# include them just to be on the safe side.

