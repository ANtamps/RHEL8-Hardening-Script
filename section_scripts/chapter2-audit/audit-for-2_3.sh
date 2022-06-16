#!/bin/bash

## Section 2.3 audit check

if ! rpm -q ypbind &> /dev/null; then
	echo -e "NIS not installed: \033[1;32mOK\033[0m"
else
	echo -e "NIS needs to be uninstalled: \033[1;31mREMOVE\033[0m"
fi

if ! rpm -q rsh &> /dev/null; then
	echo -e "RSH not installed: \033[1;32mOK\033[0m"
else
	echo -e "RSH needs to be uninstalled: \033[1;31mREMOVE\033[0m" 
fi

if ! rpm -q talk &> /dev/null; then
	echo -e "Talk not installed: \033[1;32mOK\033[0m"
else 
	echo -e "Talk needs to be uninstalled: \033[1;31mREMOVE\033[0m"
fi

if ! rpm -q telnet &> /dev/null; then
	echo -e "Telnet not installed: \033[1;32mOK\033[0m"
else
	echo -e "Telnet needs to be uninstalled: \033[1;31mREMOVE\033[0m"
fi

if ! rpm -q openldap-clients &> /dev/null; then
	echo -e "LDAP client not installed: \033[1;32mOK\033[0m"
else
	echo -e "LDAP client needs to be uninstalled: \033[1;31mREMOVE\033[0m"
fi

if ! rpm -q tftp &> /dev/null; then
	echo -e "TFTP not installed: \033[1;32mOK\033[0m"
else
	echo -e "TFTP needs to be uninstalled: \033[1;31mREMOVE\033[0m"
fi
