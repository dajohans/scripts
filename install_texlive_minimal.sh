#!/bin/bash

sudo apt update

sudo apt install --yes texlive-latex-extra \
	texlive-bibtex-extra \
	texlive-fonts-extra \
	texlive-lang-european \
	rubber \
	latexmk
