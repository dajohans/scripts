ubuntu_codename () {
	# It seems that both Linux Mint and Ubuntu can use the method
	# for Linux Mint, but I'm not 100% sure. But this shows how
	# one might be able to generalize it beyond Linux Mint and
	# Ubuntu.
	distro=$(cat /etc/os-release | grep ^NAME | sed s/NAME=//g | sed s/\"//g);
	if [[ $distro == "Linux Mint" ]]
	then
		codename=$(cat /etc/os-release | grep ^UBUNTU_CODENAME | sed s/UBUNTU_CODENAME=//g);
	elif [[ $distro == "Ubuntu" ]]
	then
		codename=$(cat /etc/os-release | grep ^VERSION_CODENAME | sed s/VERSION_CODENAME=//g);
	fi
	echo $codename
}

file_contains_string () {
	if grep -q "$2" "$1"
	then
		echo true
		return
	fi
	echo false
}

gcc_toolchain_setup () {
	codename=$(ubuntu_codename)
	gcc_toolchain_key_path="/etc/apt/keyrings/ubuntu-toolchain-r-ppa-$codename.gpg"
	if [[ $(file_exists $gcc_toolchain_key_path) = false ]]
	then
		sudo add-apt-repository --yes ppa:ubuntu-toolchain-r/ppa
	fi
}

neovim_setup () {
	codename=$(ubuntu_codename)
	neovim_key_path="/etc/apt/keyrings/neovim-ppa-unstable-$codename.gpg"
	if [[ $(file_exists $neovim_key_path) = false ]]
	then
		sudo add-apt-repository --yes ppa:neovim-ppa/unstable
	fi
}

llvm_setup () {
	# This adds ppa for both stable and development branch. The
	# highest version number is likely the development branch and
	# not very stable.
	# Source: https://www.digitalocean.com/community/tutorials/install-chrome-on-linux-mint
	# apt-key is deprecated. Use gpg instead.
	# Source for apt-key replacement: https://askubuntu.com/questions/1441931/ubuntu-22-10-fix-missing-gpg-key
	llvm_key_path="/etc/apt/trusted.gpg.d/llvm_key.gpg"
	if [[ $(file_exists $llvm_key_path) = false ]]
	then
		codename=$(ubuntu_codename)
		# Source for llvm apt repo: https://apt.llvm.org/
		wget -q -O - https://apt.llvm.org/llvm-snapshot.gpg.key | sudo gpg --dearmor -o $llvm_key_path
		sudo add-apt-repository --yes "deb [arch=amd64] http://apt.llvm.org/$codename/ llvm-toolchain-$codename main"
		# sudo add-apt-repository --yes "deb-src [arch=amd64] http://apt.llvm.org/$codename/ llvm-toolchain-$codename main"
	fi
}

google_chrome_setup () {
	# Source: https://www.digitalocean.com/community/tutorials/install-chrome-on-linux-mint
	# apt-key is deprecated. Use gpg instead.
	# Source for apt-key replacement: https://askubuntu.com/questions/1441931/ubuntu-22-10-fix-missing-gpg-key
	chrome_key_path="/etc/apt/trusted.gpg.d/google_chrome_key.gpg"
	if [[ $(file_exists $chrome_key_path) = false ]]
	then
		wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o $chrome_key_path
		# Digital Ocean doens't suggest adding [arch=amd64]. But if you don't then you get a warning about missing i386 packages.
		sudo add-apt-repository --yes "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main"
	fi
}

command_exists () {
	if command -v $1 &> /dev/null
	then
		echo true
		return
	fi
	echo false
}

arg_exists () {
	if [[ $# -eq 0 ]]
	then
		echo false
		return
	fi
	echo true
}

source_if_exists () {
	if [[ $(file_exists $1) = true ]]
	then
		source $1
	fi
}

file_exists () {
	for file in $@
	do
		if [[ ! -f $file ]]
		then
			echo false
			return
		fi
	done
	echo true
}

dir_exists () {
	for dir in $@
	do
		if [[ ! -d $dir ]]
		then
			echo false
			return
		fi
	done
	echo true
}