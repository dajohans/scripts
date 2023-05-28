#!/bin/bash

sudo apt install --yes curl

curl \
	-L https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-linux-x64.gz \
	-o /tmp/tree-sitter.gz

gzip -d /tmp/tree-sitter.gz
sudo mv /tmp/tree-sitter /usr/local/bin/
chmod +x /usr/local/bin/tree-sitter
