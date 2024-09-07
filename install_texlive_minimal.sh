#!/bin/bash

current_dir=$(dirname $0)
source "$current_dir/utils.sh"

sudo apt update

sudo apt install --yes texlive-latex-extra \
	texlive-bibtex-extra \
	texlive-fonts-extra \
	texlive-lang-european \
	rubber \
	latexmk
