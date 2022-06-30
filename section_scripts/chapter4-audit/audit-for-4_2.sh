#!/bin/bash

##4.2.1.1 Ensure rsyslog is installed (Automated)##
if rpm -q rsyslog &> /dev/null; then
	echo -e "rsyslog is installed: \033[1;32mOK\033[0m"
else
	echo -e "rsyslog is not installed: \033[1;31mERROR\033[0m"
fi

##4.2.1.2 Ensure rsyslog service is enabled (Automated)##
if systemctl is-enabled rsyslog &> /dev/null; then
	echo -e "rsyslog service is enabled: \033[1;32mOK\033[0m"
else
	echo -e "rsyslog service is not enabled: \033[1;31mERROR\033[0m"
fi

##4.2.1.4 Ensure rsyslog default file permissions are configured(Automated)##

if test -f /etc/rsyslog.conf; then
	
	if grep ^\$FileCreateMode /etc/rsyslog.conf &> /dev/null; then
	echo -e "rsyslog default file permissions are configured: \033[1;32mOK\033[0m"

	else 
	echo -e "rsyslog default file permissions are not configured: \033[1;31mERROR\033[0m"
	fi 

else
	echo -e "rsyslog default file permissions are not configured: \033[1;31mERROR\033[0m"
fi

##4.2.1.7 Ensure rsyslog is not configured to recieve logs from a remote client(Automated)##

if test -f /etc/rsyslog.conf; then
	
	if grep -q 'module(load="imtcp")' /etc/rsyslog.conf  &&
	grep -q 'input(type="imtcp" port="514")' /etc/rsyslog.conf; then

	echo -e "rsyslog is not configured to recieve logs from a remote client: \033[1;32mOK\033[0m"

	else
	echo -e "rsyslog is configured to recieve logs from a remote client: \033[1;31mERROR\033[0m"
	fi 

else
	echo -e "rsyslog is configured to recieve logs from a remote client: \033[1;31mERROR\033[0m"
fi

