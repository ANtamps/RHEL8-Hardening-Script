#!/bin/bash

## Check if NIS Service is installed and delete if it is

if rpm -q ypbind &> /dev/null; then
	echo "ypbind exists, removing..."
	dnf remove ypbind &> /dev/null
else
	echo "NIS Service not installed, continuing..."
fi

if rpm -q rsh &> /dev/null; then
	echo "rsh exists, removing..."
	dnf remove rsh &> /dev/null
else
	echo "RSH client not installed, continuing..."
fi

if rpm -q talk &> /dev/null; then
	echo "talk exists, removing..."
	dnf remove talk &> /dev/null
else
	echo "Talk not installed, continuing..."
fi

if rpm -q telnet &> /dev/null; then
	echo "telnet exists, removing..."
	dnf remove telnet &> /dev/null
else
	echo "Telnet not installed, continuing..."
fi

if rpm -q openldap-clients &> /dev/null; then
	echo "ldap client exists, removing..."
	dnf remove openldap-clients &> /dev/null
else
	echo "LDAP client not installed, continuing..."
fi

if rpm -q tftp &> /dev/null; then
	echo "tftp exists, removing..."
	dnf remove tftp &> /dev/null
else
	echo "TFTP not installed, continuing..."
fi
