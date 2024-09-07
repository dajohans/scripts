#!/bin/bash

gsettings set \
	org.gnome.Terminal.Legacy.Keybindings:/org/gnome/terminal/legacy/keybindings/ \
	prev-tab '<Alt>h'
gsettings set \
	org.gnome.Terminal.Legacy.Keybindings:/org/gnome/terminal/legacy/keybindings/ \
	close-tab '<Alt>j'
gsettings set \
	org.gnome.Terminal.Legacy.Keybindings:/org/gnome/terminal/legacy/keybindings/ \
	new-tab '<Alt>k'
gsettings set \
	org.gnome.Terminal.Legacy.Keybindings:/org/gnome/terminal/legacy/keybindings/ \
	next-tab '<Alt>l'
gsettings set \
	org.gnome.Terminal.Legacy.Keybindings:/org/gnome/terminal/legacy/keybindings/ \
	move-tab-left '<Alt><Shift>h'
gsettings set \
	org.gnome.Terminal.Legacy.Keybindings:/org/gnome/terminal/legacy/keybindings/ \
	move-tab-right '<Alt><Shift>l'

gsettings set \
	org.gnome.Terminal.Legacy.Settings \
	default-show-menubar false
