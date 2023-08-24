#!/usr/bin/env bash

# Note: Sioyek may compile on old hardware but might get runtime errors due to
#       the GPU not supporting OpenGL 3.3. This happened on my Lenovo T 410
#       with i5 M 560 CPU which apparently only supports OpenGL 2.1.

# Install dependencies. The dependencies are installed in the same order as the
# errors occur. So it is possible that an error that would occur is prevented
# because the required package was installed as a dependency to a package that
# was needed for a previous error. Hence this is not guaranteed to be a
# complete list of dependencies.
sudo apt install --yes \
	libharfbuzz-dev \
	build-essential \
	qt3d5-dev \
	libxi-dev \
	libxrandr-dev
# This page has a list of dependencies for compiling Sioyek.
# https://codeberg.org/ansible/sioyek-pdf/src/branch/main/vars/Ubuntu-22.04.yml
# The following packages are listed, but I did not need them:
#	freeglut3-dev \
#	qtdeclarative5-dev \
#	qtchooser

# Remove current installation
sudo rm -rf /opt/sioyek
sudo rm -f /usr/local/bin/sioyek

sudo apt install --yes git

# install latest sioyek from git and add to PATH by using symlink
sudo git clone --recursive https://github.com/ahrm/sioyek.git \
	/opt/sioyek

cd /opt/sioyek
sudo ./build_linux.sh
sudo ln -s /opt/sioyek/build/sioyek /usr/local/bin/sioyek

# create main menu entry, based on the default xreader entry
sudo cp /usr/share/applications/xreader.desktop \
	/usr/share/applications/sioyek.desktop
sudo sed -i 's/TryExec=xreader/TryExec=sioyek/g' \
	/usr/share/applications/sioyek.desktop 
sudo sed -i 's/Exec=xreader %U/Exec=sioyek %U/g' \
	/usr/share/applications/sioyek.desktop 
