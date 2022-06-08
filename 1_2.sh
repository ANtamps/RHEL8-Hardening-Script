#!/bin/bash

##1.2.3 Ensure gpgcheck is globally activated (Automated)##
sed -i 's/^gpgcheck\s*=\s*.*/gpgcheck=1/' /etc/dnf/dnf.conf
