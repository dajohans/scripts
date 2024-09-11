#!/bin/bash

# The current Cinnamon gui doesn't allow setting this variable. It's a
# particularly useful setting on the Thinkpad T420, on which is appear that the
# battery may randomly give a false report of critical batter level. Since this
# is a false report, I want to make sure the computer does nothing when it
# happens.
gsettings set \
	org.cinnamon.settings-daemon.plugins.power \
	critical-battery-action nothing
gsettings set \
	org.cinnamon.settings-daemon.plugins.power \
	percentage-action 0
gsettings set \
	org.cinnamon.settings-daemon.plugins.power \
	time-action 0
gsettings set \
	org.cinnamon.settings-daemon.plugins.power \
	sleep-inactive-ac-type nothing
gsettings set \
	org.cinnamon.settings-daemon.plugins.power \
	sleep-inactive-battery-type nothing
gsettings set \
	org.cinnamon.settings-daemon.plugins.power \
	sleep-inactive-ac-timeout 0
gsettings set \
	org.cinnamon.settings-daemon.plugins.power \
	sleep-inactive-battery-timeout 0
gsettings set \
	org.cinnamon.settings-daemon.plugins.power \
	sleep-display-ac 0
gsettings set \
	org.cinnamon.settings-daemon.plugins.power \
	sleep-display-battery 0
