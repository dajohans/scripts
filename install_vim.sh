#!/bin/bash

# This script is based on:
# https://github.com/ycm-core/YouCompleteMe/wiki/Building-Vim-from-source

sudo apt install --yes git 

sudo apt install --yes \
	libncurses5-dev \
	libgtk2.0-dev \
	libatk1.0-dev \
	libcairo2-dev \
	libx11-dev \
	libxpm-dev \
	libxt-dev \
	python3 \
	python3-dev \
	ruby-dev \
	lua5.2 \
	liblua5.2-dev \
	libperl-dev

# Vim's ./configure searches for lua include and library files in the wrong place.
# Source for fix:
#     https://gist.github.com/tehmachine/962639982bed614f1965d0fe405ae5f5
sudo mkdir /usr/include/lua5.2/include
sudo cp -r /usr/include/lua5.2/*.h /usr/include/lua5.2/include/
sudo ln -s /usr/lib/x86_64-linux-gnu/liblua5.2.so /usr/local/lib/liblua.so

# Default vim on Linux Mint appear to be vim-common & vim-tiny
# sudo apt remove --yes vim-common vim-tiny vim vim-runtime gvim vim-nox
sudo rm -rf /opt/vim

sudo git clone --depth 1 https://github.com/vim/vim /opt/vim

cd /opt/vim
sudo ./configure \
	--with-features=huge \
	--enable-multibyte \
	--enable-rubyinterp=yes \
	--enable-python3interp=yes \
	--with-python3-config-dir=$(python3-config --configdir) \
	--enable-perlinterp=yes \
	--enable-luainterp=yes \
	--with-lua-prefix=/usr/include/lua5.2 \
	--enable-gui=gtk2 \
	--enable-cscope \
	--prefix=/usr/local

sudo make -j16 VIMRUNTIMEDIR=/usr/local/share/vim/vim90
sudo make install

