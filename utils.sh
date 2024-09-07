ubuntu_codename () {
	# It seems that both Linux Mint and Ubuntu can use the method for
	# Linux Mint, but I'm not 100% sure. But this shows how one might
	# be able to generalize it beyond Linux Mint and Ubuntu.
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

texlab_install () {
	if [[ $(command_exists texlab) = false ]]
	then
		url="https://github.com/latex-lsp/texlab/releases/latest/download/texlab-x86_64-linux.tar.gz"
		wget -O ~/manual-installs/texlab.tar.gz $url
		mkdir -p ~/manual-installs/texlab
		tar -xf ~/manual-installs/texlab.tar.gz -C ~/manual-installs/texlab
		rm ~/manual-installs/texlab.tar.gz
	fi
}

jdtls_install () {
	if [[ $(command_exists jdtls) = false ]]
	then
		url="http://download.eclipse.org/jdtls/snapshots/jdt-language-server-latest.tar.gz"
		wget -O ~/manual-installs/eclipse-jdtls.tar.gz $url;
		mkdir -p ~/manual-installs/eclipse-jdtls;
		tar -xf ~/manual-installs/eclipse-jdtls.tar.gz -C ~/manual-installs/eclipse-jdtls;
		rm ~/manual-installs/eclipse-jdtls.tar.gz
	fi
}

rust_analyzer_install () {
	# Rustup appears to install the programs inside
	#     ~/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/bin/
	# but doesn't add this to PATH. Then it seems like it creates
	# inside
	#     ~/.cargo/bin/
	# and these wrappers are added to PATH. The strange thing is that
	# wrappers of the binaries in the above directory and put them
	# it creates wrappers for all components, even the ones that are
	# not installed. So there exists a binary rust-analyzer even if it
	# is not installed. Therefore, the below code checks for
	# rust-analyzer inside the directory where rustup appears to
	# install the actual binary of rust-analyzer.
	if [[ $(command_exists ~/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/bin/rust-analyzer) = false ]]
	then
		rustup component add rust-analyzer
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

num_cpu_cores () {
	num_cores=$(cat /proc/cpuinfo | grep ^processor | awk '{print $NF}' | tail -n1)+1
	echo $num_cores
}
