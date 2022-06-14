#!/bin/bash

##1.3 Filesystem Integrity Checking##
##1.3.1 Ensure AIDE is installed##

if ! rpm -q aide &> /dev/null; then
	echo -e "AIDE is already installed"
else
	echo -e "AIDE needs to be installed"
fi
