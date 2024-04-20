#!/bin/bash

# This script is based on:
# https://github.com/ycm-core/YouCompleteMe/wiki/Building-Vim-from-source

current_dir=$(dirname $0)
source "$current_dir/utils.sh"
num_compile_threads=$(($(num_cpu_cores)+1))

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

sudo rm -rf /opt/vim
sudo rm -rf /usr/local/share/vim/vim

# sudo git clone https://github.com/vim/vim /opt/vim
sudo git clone --depth 1 https://github.com/vim/vim /opt/vim

cd /opt/vim
# Reset to the commit for the 9.1 release:
#     https://github.com/vim/vim/commit/b4ddc6c11e95cef4b372e239871fae1c8d4f72b6
# git reset --hard b4ddc6c11e95cef4b372e239871fae1c8d4f72b6
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
	--enable-autoservername \
	--prefix=/usr/local

sudo make -j$(num_compile_threads) VIMRUNTIMEDIR=/usr/local/share/vim/vim
sudo make install

