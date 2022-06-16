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

##2.1.2 Ensure chrony is configured##
if  grep -E "^(server|pool)" /etc/chrony.conf; then
	echo -e "Remote server is configured: \033[1;32mOK\033[0m"
else
	echo -e "Remote server is not configured: \033[1;31mERROR\033[0m"
fi

if   grep ^OPTIONS /etc/sysconfig/chronyd; then
        echo -e "Command configured: \033[1;32mOK\033[0m"
else
    	echo -e "OPTIONS="": \033[1;31mERROR\033[0m"
fi
