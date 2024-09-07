#!/bin/bash

# In comments are setting names used in the GUI#

# Dokumenttypsnitt:
gsettings set \
	org.gnome.desktop.interface \
	document-font-name 'Sans 13'
# Tpysnitt med fast breddsteg:
gsettings set \
	org.gnome.desktop.interface \
	monospace-font-name 'DejaVu Sans Mono 13'
# Fönstertiteltypsnitt:
gsettings set \
	org.cinnamon.desktop.wm.preferences \
	titlebar-font 'Ubuntu Medium 13'
# Standardtypsnitt:
gsettings set \
	org.cinnamon.desktop.interface \
	font-name 'Ubuntu 13'
# Skrivbordstypsnitt:
gsettings set \
	org.nemo.desktop \
	font 'Ubuntu 13'
