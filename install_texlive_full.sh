#!/bin/bash

sudo apt update

# NOTE: Installation of texlive-full gets stuck at:
#     Pregenerating ConTeXt MarkIV format. This may take some time...
# Apparently it's waiting for input, but doesn't say anything about that.
# Pressing Enter a bunch(more than just once or twice) of times tend to make
# the installation continue
sudo apt install --yes texlive-full \
	rubber \
	latexmk
