#!/bin/bash

##Audit##
##2.1 Time Synchronization##
##2.1.1 Ensure time synchronization is in use##

if  rpm -q chrony &> /dev/null; then
	rpm -q chrony
	echo -e "CHRONY is already installed: \033[1;32mOK\033[0m"

else
	echo -e "CHRONY needs to be installed: \033[1;31mERROR\033[0m"
fi
