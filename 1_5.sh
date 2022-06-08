#!/bin/bash

# Edits the coredump.conf to none to ensure core dumps is disabled

sed -i 's/#Storage=external/Storage=none/g' /etc/systemd/coredump.conf

# Edits the coredump.conf ProcessSize to 0 to ensure backtraces are disabled

sed -i 's/#ProcessSizeMax=2G/ProcessSizeMax=0/g' /etc/systemd/coredump.conf

# Sets kernel.randomize_va_space to 2

sysctl -w kernel.randomize_va_space=2 
