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

texlive_install () {
	sudo apt install --yes texlive-full \
		rubber \
		latexmk
}

texlive_minimal_install () {
	sudo apt install --yes texlive-latex-extra \
		texlive-bibtex-extra \
		texlive-fonts-extra \
		texlive-lang-european \
		rubber \
		latexmk
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

rust_install () {
	if [[ $(command_exists rustup) = false ]]
	then
		curl --proto '=https' --tlsv1.3 https://sh.rustup.rs -sSf | bash -s -- -y
		source $HOME/.cargo/env
	fi
}

rust_analyzer_install () {
	# Rustup appears to install the programs inside
	#     ~/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/bin/
	# but doesn't add this to PATH. Then it seems like it creates
	# wrappers of the binaries in the above directory and put them
	# inside
	#     ~/.cargo/bin/
	# and these wrappers are added to PATH. The strange thing is that
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

avr_install () {
	# Programs for Arduino programming, or avr programming in general.
	# screen is for viewing serial port output continuously
	sudo apt install --yes binutils-avr gcc-avr avr-libc gdb-avr avrdude screen
}

gcc_toolchain_setup () {
	codename=$(ubuntu_codename)
	gcc_toolchain_key_path="/etc/apt/keyrings/ubuntu-toolchain-r-ppa-$codename.gpg"
	if [[ $(file_exists $gcc_toolchain_key_path) = false ]]
	then
		sudo add-apt-repository --yes ppa:ubuntu-toolchain-r/ppa
	fi
}

gcc_latest_install () {
	# Grep for lines beginning in gcc and ending in a at least two
	# digits. We want there to be two digits, because otherwise the
	# sorting might get strange, since it seems to prioritize sorting word
	# length over the numeric value at the end of the word. Then use awk
	# to pick the first word, which is the package name. Then sort the
	# list and pick the last element.
	gcc=$(apt-cache search gcc | grep '^gcc-[0-9][0-9][[:space:]]' | awk '{print $1;}' | sort | tail -1)
	gplusplus=$(apt-cache search g++ | grep '^g++-[0-9][0-9][[:space:]]' | awk '{print $1;}' | sort | tail -1)
	sudo apt install --yes $gcc $gplusplus
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

llvm_install () {
	# Grep for lines beginning in clang- and ending in a at least two
	# digits. We want there to be two digits, because otherwise the
	# sorting might get strange, since it seems to prioritize sorting word
	# length over the numeric value at the end of the word. Then use awk
	# to pick the first word, which is the package name. Then sort the
	# list and pick the second to last element, which should be the last
	# package from a non-development branch.
	clang=$(apt-cache search clang | grep '^clang-[0-9][0-9][[:space:]]' | awk '{print $1;}' | sort | tail -2 | head -1)
	clangd=$(apt-cache search clangd | grep '^clangd-[0-9][0-9][[:space:]]' | awk '{print $1;}' | sort | tail -2 | head -1)
	sudo apt install --yes $clang $clangd
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
