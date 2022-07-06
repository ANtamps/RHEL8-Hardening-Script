#!/bin/bash

##5.3

##5.3.1 Ensure sudo is installed
if rpm -q sudo &> /dev/null; then
    dnf list sudo
    echo "sudo installed, continuing..."
else   
    echo "sudo not found, installing..."
     dnf -y install sudo &> /dev/null
     dnf list sudo
fi

##5.3.2 Ensure sudo commands use pty
sed -i 's;/etc/sudoers;/etc/sudoers:Defaults use_pty;g' /etc/sudoers
grep /etc/sudoers /etc/sudoers
