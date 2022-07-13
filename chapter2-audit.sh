#!/bin/bash

##2.1.1 Ensure time synchronization is in use##
if  rpm -q chrony &> /dev/null; then
	rpm -q chrony
	echo -e "CHRONY is already installed: \033[1;32mOK\033[0m"
    let COUNTER++
else
	echo -e "CHRONY needs to be installed: \033[1;31mERROR\033[0m"
    echo -e "CHRONY needs to be installed: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##2.1.2 Ensure chrony is configured##
if  grep -E "^(server|pool)" /etc/chrony.conf; then
	echo -e "Remote server is configured: \033[1;32mOK\033[0m"
    let COUNTER++
else
	echo -e "Remote server is not configured: \033[1;31mERROR\033[0m"
    echo -e "Remote server is not configured: \033[1;31mERROR\033[0m" >> audit-error.log
fi

if   grep ^OPTIONS /etc/sysconfig/chronyd; then
        echo -e "Command configured: \033[1;32mOK\033[0m"
        let COUNTER++
else
    	echo -e "OPTIONS="": \033[1;31mERROR\033[0m"
        echo -e "OPTIONS="": \033[1;31mERROR\033[0m" >> audit-error.log
fi

##2.2 Special Purpose Services##

##2.2.1 Ensure xinetd is not installed (Automated)##
if ! rpm -q xinetd &> /dev/null; then
	echo -e "xinetd not installed: \033[1;32mOK\033[0m"
    let COUNTER++
else
	echo -e "xinetd needs to be uninstalled: \033[1;31mREMOVE\033[0m"
    echo -e "xinetd needs to be uninstalled: \033[1;31mREMOVE\033[0m" >> audit-error.log
fi

##2.2.2 Ensure xorg-x11-server-common is not installed (Automated)##
if ! rpm -q xorg-x11-server-common &> /dev/null; then
	echo -e "xorg-x11-server-common not installed: \033[1;32mOK\033[0m"
    let COUNTER++
else
	echo -e "xorg-x11-server-common to be uninstalled: \033[1;31mREMOVE\033[0m"
    echo -e "xorg-x11-server-common to be uninstalled: \033[1;31mREMOVE\033[0m" >> audit-error.log
fi

##2.2.3 Ensure Avahi Server is not installed (Automated)##
if ! rpm -q avahi-autoipd avahi &> /dev/null; then
	echo -e "Avahi Server not installed: \033[1;32mOK\033[0m"
    let COUNTER++
else
	echo -e "Avahi Server to be uninstalled: \033[1;31mREMOVE\033[0m"
    echo -e "Avahi Server to be uninstalled: \033[1;31mREMOVE\033[0m" >> audit-error.log
fi

##2.2.4 Ensure CUPS is not installed (Automated)##
if ! rpm -q cups &> /dev/null; then
	echo -e "CUPS not installed: \033[1;32mOK\033[0m"
    let COUNTER++
else
	echo -e "CUPS to be uninstalled: \033[1;31mREMOVE\033[0m"
    echo -e "CUPS to be uninstalled: \033[1;31mREMOVE\033[0m" >> audit-error.log
fi

##2.2.5 Ensure DHCP Server is not installed (Automated)##
if ! rpm -q dhcp-server &> /dev/null; then
	echo -e "DHCP Server not installed: \033[1;32mOK\033[0m"
    let COUNTER++
else
	echo -e "DHCP Server to be uninstalled: \033[1;31mREMOVE\033[0m"
    echo -e "DHCP Server to be uninstalled: \033[1;31mREMOVE\033[0m" >> audit-error.log
fi

##2.2.6 Ensure DNS Server is not installed (Automated)##
if ! rpm -q bind &> /dev/null; then
	echo -e "DNS Server not installed: \033[1;32mOK\033[0m"
    let COUNTER++
else
	echo -e "DNS Server to be uninstalled: \033[1;31mREMOVE\033[0m"
    echo -e "DNS Server to be uninstalled: \033[1;31mREMOVE\033[0m" >> audit-error.log
fi

##2.2.7 Ensure FTP Server is not installed (Automated)##
if ! rpm -q ftp &> /dev/null; then
	echo -e "FTP Server not installed: \033[1;32mOK\033[0m"
    let COUNTER++
else
	echo -e "FTP Server to be uninstalled: \033[1;31mREMOVE\033[0m"
    echo -e "FTP Server to be uninstalled: \033[1;31mREMOVE\033[0m" >> audit-error.log
fi


##2.2.8 Ensure VSFTP Server is not installed (Automated)##
if ! rpm -q vsftpd &> /dev/null; then
	echo -e "VSFTP Server not installed: \033[1;32mOK\033[0m"
    let COUNTER++
else
	echo -e "VSFTP Server to be uninstalled: \033[1;31mREMOVE\033[0m"
    echo -e "VSFTP Server to be uninstalled: \033[1;31mREMOVE\033[0m" >> audit-error.log
fi

##2.2.9 Ensure TFTP Server is not installed (Automated)##
if ! rpm -q tftp-server &> /dev/null; then
	echo -e "TFTP Server not installed: \033[1;32mOK\033[0m"
    let COUNTER++
else
	echo -e "TFTP Server to be uninstalled: \033[1;31mREMOVE\033[0m"
    echo -e "TFTP Server to be uninstalled: \033[1;31mREMOVE\033[0m" >> audit-error.log
fi

##2.2.10 Ensure a web server is not installed (Automated)##
if ! rpm -q httpd nginx &> /dev/null; then
	echo -e "Web Server not installed: \033[1;32mOK\033[0m"
    let COUNTER++
else
	echo -e "Web Server to be uninstalled: \033[1;31mREMOVE\033[0m"
    echo -e "Web Server to be uninstalled: \033[1;31mREMOVE\033[0m" >> audit-error.log
fi

##2.2.11 Ensure IMAP and POP3 server is not installed (Automated)##
if ! rpm -q dovecot cyrus-imapd &> /dev/null; then
	echo -e "IMAP and POP3 server not installed: \033[1;32mOK\033[0m"
    let COUNTER++
else
	echo -e "IMAP and POP3 server to be uninstalled: \033[1;31mREMOVE\033[0m"
	echo -e "IMAP and POP3 server to be uninstalled: \033[1;31mREMOVE\033[0m" >> audit-error.log
fi

##2.2.12 Ensure Samba is not installed (Automated)##
if ! rpm -q samba &> /dev/null; then
	echo -e "Samba not installed: \033[1;32mOK\033[0m"
    let COUNTER++
else
	echo -e "Samba to be uninstalled: \033[1;31mREMOVE\033[0m"
	echo -e "Samba to be uninstalled: \033[1;31mREMOVE\033[0m" >> audit-error.log
fi

##2.2.13 Ensure HTTP Proxy Server is not installed (Automated)##
if ! rpm -q squid &> /dev/null; then
	echo -e "HTTP Proxy Server not installed: \033[1;32mOK\033[0m"
    let COUNTER++
else
	echo -e "HTTP Proxy Server to be uninstalled: \033[1;31mREMOVE\033[0m"
	echo -e "HTTP Proxy Server to be uninstalled: \033[1;31mREMOVE\033[0m" >> audit-error.log
fi
fi

##2.2.14 Ensure net-snmp is not installed (Automated)##
if ! rpm -q net-snmp &> /dev/null; then
	echo -e "net-snmp not installed: \033[1;32mOK\033[0m"
    let COUNTER++
else
	echo -e "net-snmp to be uninstalled: \033[1;31mREMOVE\033[0m"
	echo -e "net-snmp to be uninstalled: \033[1;31mREMOVE\033[0m" >> audit-error.log
fi

##2.2.15 Ensure NIS server is not installed (Automated)##
if ! rpm -q ypserv &> /dev/null; then
	echo -e "NIS server not installed: \033[1;32mOK\033[0m"
    let COUNTER++
else
	echo -e "NIS server to be uninstalled: \033[1;31mREMOVE\033[0m"
	echo -e "NIS server to be uninstalled: \033[1;31mREMOVE\033[0m" >> audit-error.log
fi

##2.2.16 Ensure telnet-server is not installed (Automated)##
if ! rpm -q telnet-server &> /dev/null; then
	echo -e "telnet-server not installed: \033[1;32mOK\033[0m"
    let COUNTER++
else
	echo -e "telnet-server to be uninstalled: \033[1;31mREMOVE\033[0m"
	echo -e "telnet-server to be uninstalled: \033[1;31mREMOVE\033[0m" >> audit-error.log
fi

##2.2.18 Ensure nfs-utils is not installed or the nfs-server service is masked(Automated)##
if ! systemctl is-enabled nfs-server &> /dev/null; then
	echo -e "nfs-server service is masked: \033[1;32mOK\033[0m"
    let COUNTER++
else
	echo -e "nfs-server service is not masked: \033[1;31mREMOVE\033[0m"
	echo -e "nfs-server service is not masked: \033[1;31mREMOVE\033[0m" >> audit-error.log
fi

##2.2.19 Ensure rpcbind is not installed or the rpcbind services are masked(Automated)##
if ! systemctl is-enabled rpcbind &> /dev/null; then
	echo -e "rpcbind is masked: \033[1;32mOK\033[0m"
    let COUNTER++
else
	echo -e "rpcbind is not masked: \033[1;31mREMOVE\033[0m"
	echo -e "rpcbind is not masked: \033[1;31mREMOVE\033[0m" >> audit-error.log
fi

if ! systemctl is-enabled rpcbind.socket &> /dev/null; then
	echo -e "rpcbind services is masked: \033[1;32mOK\033[0m"
    let COUNTER++
else
	echo -e "rpcbind services is not masked: \033[1;31mREMOVE\033[0m"
	echo -e "rpcbind services is not masked: \033[1;31mREMOVE\033[0m" >> audit-error.log
fi


##2.2.20 Ensure rsync is not installed or the rsyncd service is masked(Automated)##
if ! rpm -q rsync &> /dev/null; then
	echo -e "rsync not installed: \033[1;32mOK\033[0m"
    let COUNTER++
else
	echo -e "rsync to be uninstalled: \033[1;31mREMOVE\033[0m"
	echo -e "rsync to be uninstalled: \033[1;31mREMOVE\033[0m" >> audit-error.log
fi

## Section 2.3 audit check

if ! rpm -q ypbind &> /dev/null; then
	echo -e "NIS not installed: \033[1;32mOK\033[0m"
    let COUNTER++
else
	echo -e "NIS needs to be uninstalled: \033[1;31mREMOVE\033[0m"
	echo -e "NIS needs to be uninstalled: \033[1;31mREMOVE\033[0m" >> audit-error.log
fi

if ! rpm -q rsh &> /dev/null; then
	echo -e "RSH not installed: \033[1;32mOK\033[0m"
    let COUNTER++
else
	echo -e "RSH needs to be uninstalled: \033[1;31mREMOVE\033[0m" 
	echo -e "RSH needs to be uninstalled: \033[1;31mREMOVE\033[0m" >> audit-error.log
fi

if ! rpm -q talk &> /dev/null; then
	echo -e "Talk not installed: \033[1;32mOK\033[0m"
    let COUNTER++
else 
	echo -e "Talk needs to be uninstalled: \033[1;31mREMOVE\033[0m"
	echo -e "Talk needs to be uninstalled: \033[1;31mREMOVE\033[0m" >> audit-error.log
fi

if ! rpm -q telnet &> /dev/null; then
	echo -e "Telnet not installed: \033[1;32mOK\033[0m"
    let COUNTER++
else
	echo -e "Telnet needs to be uninstalled: \033[1;31mREMOVE\033[0m"
	echo -e "Telnet needs to be uninstalled: \033[1;31mREMOVE\033[0m" >> audit-error.log
fi

if ! rpm -q openldap-clients &> /dev/null; then
	echo -e "LDAP client not installed: \033[1;32mOK\033[0m"
    let COUNTER++
else
	echo -e "LDAP client needs to be uninstalled: \033[1;31mREMOVE\033[0m"
	echo -e "LDAP client needs to be uninstalled: \033[1;31mREMOVE\033[0m" >> audit-error.log
fi

if ! rpm -q tftp &> /dev/null; then
	echo -e "TFTP not installed: \033[1;32mOK\033[0m"
    let COUNTER++
else
	echo -e "TFTP needs to be uninstalled: \033[1;31mREMOVE\033[0m"
	echo -e "TFTP needs to be uninstalled: \033[1;31mREMOVE\033[0m" >> audit-error.log
fi

printf "Finished auditing with score: $COUNTER/29 \n"
