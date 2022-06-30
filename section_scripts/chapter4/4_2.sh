#!/bin/bash
##4.2.1.1 Ensure rsyslog is installed (Automated)##
if rpm -q rsyslog &> /dev/null; then
	echo "rsyslog is installed, continuing..."
else
	echo "rsyslog is not installed, installing..."
	dnf install -y rsyslog &> /dev/null
fi

##4.2.1.2 Ensure rsyslog service is enabled (Automated)##
if systemctl is-enabled rsyslog &> /dev/null; then
	echo "rsyslog is enabled, continuing..."
else
	echo "rsyslog is not enabled, enabling..."
	systemctl --now enable rsyslog
fi

##4.2.1.4 Ensure rsyslog default file permissions are configured(Automated)##

if test -f /etc/rsyslog.conf; then
	
	if grep ^\$FileCreateMode /etc/rsyslog.conf &> /dev/null; then
	echo "rsyslog default file permissions are configured, continuing..."

	else 
	echo '$FileCreateMode 0640' >> /etc/rsyslog.conf
	fi 

else
	touch /etc/rsyslog.conf
	echo '$FileCreateMode 0640' >> /etc/rsyslog.conf
fi

##4.2.1.7 Ensure rsyslog is not configured to recieve logs from a remote client(Automated)##

if test -f /etc/rsyslog.conf; then
	
	if grep -q 'module(load="imtcp")' /etc/rsyslog.conf  &&
	grep -q 'input(type="imtcp" port="514")' /etc/rsyslog.conf; then

	echo "rsyslog is not configured to recieve logs from a remote client, continuing..."

	else
	echo -e 'module(load="imtcp")\ninput(type="imtcp" port="514")' >> /etc/rsyslog.conf
	fi 

else
	touch /etc/rsyslog.conf
	echo -e 'module(load="imtcp")\ninput(type="imtcp" port="514")' >> /etc/rsyslog.conf
fi

systemctl restart rsyslog
