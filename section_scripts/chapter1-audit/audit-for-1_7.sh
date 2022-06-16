##!/bin/bash
##AUDIT##

##1.7 Command Line Warning Banners##
##1.7.1 Ensure message of the day is configured properly##

if  cat /etc/motd &> /dev/null; then
	cat /etc/motd
	echo -e "MOTD needs to be removed: \033[1;31mERROR\033[0m"

else
	echo -e "MOTD removed:\033[1;32mOK\033[0m"
fi

if grep -E -i "(\\\v|\\\r|\\\m|\\\s|$(grep '^ID=' /etc/os-release | cut -d= -f2 | sed -e 's/"//g'))" /etc/motd &> /dev/null; then
	echo -e "Results found: \033[1;31mERROR\033[0m"
else
	echo -e "No results found: \033[1;32mOK\033[0m"
fi

if  cat /etc/issue &> /dev/null; then
        cat /etc/issue
        echo -e "Configured properly: \033[1;32mOK\033[0m"

else
    	echo -e "Configured properly: \033[1;31mERROR\033[0m"
fi

##1.7.2 Ensure local login warning banner is configured properly##

if  cat /etc/issue &> /dev/null; then
        cat /etc/issue
        echo -e "Configured properly: \033[1;32mOK\033[0m"

else
    	echo -e "Configured properly:\033[1;31mERROR\033[0m"
fi

if grep -E -i "(\\\v|\\\r|\\\m|\\\s|$(grep '^ID=' /etc/os-release | cut -d= -f2 | sed -e 's/"//g'))" /etc/issue; then
        echo -e "Results found: \033[1;31mERROR\033[0m"
else
    	echo -e "No results found: \033[1;32mOK\033[0m"
fi


##1.7.3 Ensure remote login warning banner is configured properly##

if  cat /etc/issue.net &> /dev/null; then
        cat /etc/issue.net
        echo -e "Configured properly: \033[1;32mOK\033[0m"

else
    	echo -e "Configured properly:\033[1;31mERROR\033[0m"
fi

if grep -E -i "(\\\v|\\\r|\\\m|\\\s|$(grep '^ID=' /etc/os-release | cut -d= -f2 | sed -e 's/"//g'))" /etc/issue.net; then
        echo -e "Results found: \033[1;31mERROR\033[0m"
else
    	echo -e "No results found: \033[1;32mOK\033[0m"
fi

##1.7.4 Ensure permissions on /etc/motd are configured##

##1.7.5Ensure permissions on /etc/issue are configured##

if  stat /etc/issue &> /dev/null; then
        stat /etc/issue
        echo -e "Uid, Gid, and Access: \033[1;32mOK\033[0m"

else
    	echo -e "Uid, Gid, and Access:\033[1;31mERROR\033[0m"
fi

##1.7.6 Ensure permissions on /etc/issue.net are configured##

if  stat /etc/issue.net &> /dev/null; then
       stat /etc/issue.net
        echo -e "Uid, Gid, and Access: \033[1;32mOK\033[0m"

else
    	echo -e "Uid, Gid, and Access:\033[1;31mERROR\033[0m"
fi
