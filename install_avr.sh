#!/bin/bash

current_dir=$(dirname $0)
source "$current_dir/utils.sh"

sudo apt update

# Programs for Arduino programming, or avr programming in general.
# screen is for viewing serial port output continuously
sudo apt install --yes binutils-avr gcc-avr avr-libc gdb-avr avrdude screen
