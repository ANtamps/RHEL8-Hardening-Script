#!/bin/bash
##2.1 Time Synchronization##
##2.1.1 Ensure time synchronization is in use##

if  rpm -qa | grep -q "chrony"; then
	echo "CHRONY already installed"
else
	echo "CHRONY not installed, installing.."
	dnf install chrony
fi

##2.1.2 Ensure chrony is configured##

if test -f /etc/chrony.conf; then

	if grep -q "server <remote-server>" /etc/chrony.conf; then
	echo "server <remote-server>"

	else
	echo "server <remote-server>" > /etc/chrony.conf
	fi
else

	touch /etc/chrony.conf
	echo  "server <remote-server>" > /etc/chrony.conf

dconf update

fi

if test -f  /etc/sysconfig/chronyd; then

	echo "OPTIONS=\"-u chrony\""

	else
	echo -e "Configuring.." 
	sed -i 's/OPTIONS=""/OPTIONS="-u chrony"/g' /etc/sysconfig/chronyd
fi
##2.2 Special Purpose Services##

##2.2.1 Ensure xinetd is not installed (Automated)##
if rpm -q xinetd &> /dev/null; then
	echo "xinetd exists, removing..."
	dnf remove -y xinetd &> /dev/null
else
	echo "xinted not installed, continuing..."
fi

##2.2.2 Ensure xorg-x11-server-common is not installed (Automated)##
if rpm -q xorg-x11-server-common &> /dev/null; then
	echo "xorg-x11-server-common exists, removing..."
	dnf remove xorg-x11-server-common &> /dev/null
else
	echo "xorg-x11-server-common not installed, continuing..."
fi

##2.2.3 Ensure Avahi Server is not installed (Automated)##
if rpm -q avahi-autoipd avahi &> /dev/null; then
	echo "Avahi Server exists, removing..."
	systemctl stop avahi-daemon.socket avahi-daemon.service &> /dev/null
	dnf remove -y avahi-autoipd avahi &> /dev/null
else
	echo "Avahi Server not installed, continuing..."
fi

##2.2.4 Ensure CUPS is not installed (Automated)##
if rpm -q cups &> /dev/null; then
	echo "CUPS exists, removing..."
	dnf remove -y cups &> /dev/null
else
	echo "CUPS not installed, continuing..."
fi

##2.2.5 Ensure DHCP Server is not installed (Automated)##
if rpm -q dhcp-server &> /dev/null; then
	echo "DHCP Server exists, removing..."
	dnf remove -y dhcp-server &> /dev/null
else
	echo "DHCP Server not installed, continuing..."
fi

##2.2.6 Ensure DNS Server is not installed (Automated)##
if rpm -q bind &> /dev/null; then
	echo "DNS Server exists, removing..."
	dnf remove -y bind &> /dev/null
else
	echo "DNS Server not installed, continuing..."
fi

##2.2.7 Ensure FTP Server is not installed (Automated)##
if rpm -q ftp &> /dev/null; then
	echo "FTP Server exists, removing..."
	dnf remove -y ftp &> /dev/null
else
	echo "FTP Server not installed, continuing..."
fi

##2.2.8 Ensure VSFTP Server is not installed (Automated)##
if rpm -q vsftpd &> /dev/null; then
	echo "VSFTP Server exists, removing..."
	dnf remove -y vsftpd &> /dev/null
else
	echo "VSFTP Server not installed, continuing..."
fi

##2.2.9 Ensure TFTP Server is not installed (Automated)##
if rpm -q tftp-server &> /dev/null; then
	echo "TFTP Server exists, removing..."
	dnf remove -y tftp-server &> /dev/null
else
	echo "TFTP Server not installed, continuing..."
fi

##2.2.10 Ensure a web server is not installed (Automated)##
if rpm -q httpd nginx &> /dev/null; then
	echo "Web Server exists, removing..."
	dnf remove -y httpd nginx &> /dev/null
else
	echo "Web Server not installed, continuing..."
fi

##2.2.11 Ensure IMAP and POP3 server is not installed (Automated)##
if rpm -q dovecot cyrus-imapd &> /dev/null; then
	echo "IMAP and POP3 server exists, removing..."
	dnf remove -y dovecot cyrus-imapd &> /dev/null
else
	echo "IMAP and POP3 server not installed, continuing..."
fi

##2.2.12 Ensure Samba is not installed (Automated)##
if rpm -q samba &> /dev/null; then
	echo "Samba exists, removing..."
	dnf remove -y samba &> /dev/null
else
	echo "Samba not installed, continuing..."
fi

##2.2.13 Ensure HTTP Proxy Server is not installed (Automated)##
if rpm -q squid &> /dev/null; then
	echo "HTTP Proxy Server exists, removing..."
	dnf remove -y squid &> /dev/null
else
	echo "HTTP Proxy Server not installed, continuing..."
fi

##2.2.14 Ensure net-snmp is not installed (Automated)##
if rpm -q net-snmp &> /dev/null; then
	echo "Net-snmp exists, removing..."
	dnf remove -y net-snmp &> /dev/null
else
	echo "Net-snmp not installed, continuing..."
fi

##2.2.15 Ensure NIS server is not installed (Automated)##
if rpm -q ypserv &> /dev/null; then
	echo "NIS Server exists, removing..."
	dnf remove -y ypserv &> /dev/null
else
	echo "NIS Server not installed, continuing..."
fi

##2.2.16 Ensure telnet-server is not installed (Automated)##
if rpm -q telnet-server &> /dev/null; then
	echo "Telnet Server exists, removing..."
	dnf remove -y telnet-server &> /dev/null
else
	echo "Telnet Server not installed, continuing..."
fi

##2.2.18 Ensure nfs-utils is not installed or the nfs-server service is masked(Automated)##
if systemctl is-enabled nfs-server &> /dev/null; then
	echo "nfs-server service is not masked, masking..."
	systemctl --now mask nfs-server &> /dev/null
else
	echo "nfs-server service is masked, continuing..."
fi

##2.2.19 Ensure rpcbind is not installed or the rpcbind services are masked(Automated)##
if systemctl is-enabled rpcbind &> /dev/null; then
	echo "rcpbind is not masked, masking..."
	systemctl --now mask rpcbind &> /dev/null
else
	echo "rcpbind is masked, continuing..."
fi

if systemctl is-enabled rpcbind.socket &> /dev/null; then
	echo "rcpbind services is not masked, masking..."
	systemctl --now mask rpcbind.socket &> /dev/null
else
	echo "rcpbind services is masked, continuing..."
fi

##2.2.20 Ensure rsync is not installed or the rsyncd service is masked(Automated)##
if rpm -q rsync &> /dev/null; then
	echo "rsync exists, removing..."
	dnf remove -y rsync &> /dev/null
else
	echo "rsync not installed, continuing..."
fi

## Check if NIS Service is installed and delete if it is

if rpm -q ypbind &> /dev/null; then
	echo "ypbind exists, removing..."
	dnf -y remove ypbind &> /dev/null
else
	echo "NIS Service not installed, continuing..."
fi

if rpm -q rsh &> /dev/null; then
	echo "rsh exists, removing..."
	dnf -y remove rsh &> /dev/null
else
	echo "RSH client not installed, continuing..."
fi

if rpm -q talk &> /dev/null; then
	echo "talk exists, removing..."
	dnf -y remove talk &> /dev/null
else
	echo "Talk not installed, continuing..."
fi

if rpm -q telnet &> /dev/null; then
	echo "telnet exists, removing..."
	dnf -y remove telnet &> /dev/null
else
	echo "Telnet not installed, continuing..."
fi

if rpm -q openldap-clients &> /dev/null; then
	echo "ldap client exists, removing..."
	dnf -y remove openldap-clients &> /dev/null
else
	echo "LDAP client not installed, continuing..."
fi

if rpm -q tftp &> /dev/null; then
	echo "tftp exists, removing..."
	dnf -y remove tftp &> /dev/null
else
	echo "TFTP not installed, continuing..."
fi
