##2.2 Special Purpose Services##

##2.2.1 Ensure xinetd is not installed (Automated)##
if ! rpm -q xinetd &> /dev/null; then
	echo -e "xinetd not installed: \033[1;32mOK\033[0m"
else
	echo -e "xinetd needs to be uninstalled: \033[1;31mREMOVE\033[0m"
fi

##2.2.2 Ensure xorg-x11-server-common is not installed (Automated)##
if ! rpm -q xorg-x11-server-common &> /dev/null; then
	echo -e "xorg-x11-server-common not installed: \033[1;32mOK\033[0m"
else
	echo -e "xorg-x11-server-common to be uninstalled: \033[1;31mREMOVE\033[0m"
fi

##2.2.3 Ensure Avahi Server is not installed (Automated)##
if ! rpm -q avahi-autoipd avahi &> /dev/null; then
	echo -e "Avahi Server not installed: \033[1;32mOK\033[0m"
else
	echo -e "Avahi Server to be uninstalled: \033[1;31mREMOVE\033[0m"
fi

##2.2.4 Ensure CUPS is not installed (Automated)##
if ! rpm -q cups &> /dev/null; then
	echo -e "CUPS not installed: \033[1;32mOK\033[0m"
else
	echo -e "CUPS to be uninstalled: \033[1;31mREMOVE\033[0m"
fi

##2.2.5 Ensure DHCP Server is not installed (Automated)##
if ! rpm -q dhcp-server &> /dev/null; then
	echo -e "DHCP Server not installed: \033[1;32mOK\033[0m"
else
	echo -e "DHCP Server to be uninstalled: \033[1;31mREMOVE\033[0m"
fi

##2.2.6 Ensure DNS Server is not installed (Automated)##
if ! rpm -q bind &> /dev/null; then
	echo -e "DNS Server not installed: \033[1;32mOK\033[0m"
else
	echo -e "DNS Server to be uninstalled: \033[1;31mREMOVE\033[0m"
fi

##2.2.7 Ensure FTP Server is not installed (Automated)##
if ! rpm -q ftp &> /dev/null; then
	echo -e "FTP Server not installed: \033[1;32mOK\033[0m"
else
	echo -e "FTP Server to be uninstalled: \033[1;31mREMOVE\033[0m"
fi


##2.2.8 Ensure VSFTP Server is not installed (Automated)##
if ! rpm -q vsftpd &> /dev/null; then
	echo -e "VSFTP Server not installed: \033[1;32mOK\033[0m"
else
	echo -e "VSFTP Server to be uninstalled: \033[1;31mREMOVE\033[0m"
fi

##2.2.9 Ensure TFTP Server is not installed (Automated)##
if ! rpm -q tftp-server &> /dev/null; then
	echo -e "TFTP Server not installed: \033[1;32mOK\033[0m"
else
	echo -e "TFTP Server to be uninstalled: \033[1;31mREMOVE\033[0m"
fi

##2.2.10 Ensure a web server is not installed (Automated)##
if ! rpm -q httpd nginx &> /dev/null; then
	echo -e "Web Server not installed: \033[1;32mOK\033[0m"
else
	echo -e "Web Server to be uninstalled: \033[1;31mREMOVE\033[0m"
fi

##2.2.11 Ensure IMAP and POP3 server is not installed (Automated)##
if ! rpm -q dovecot cyrus-imapd &> /dev/null; then
	echo -e "IMAP and POP3 server not installed: \033[1;32mOK\033[0m"
else
	echo -e "IMAP and POP3 server to be uninstalled: \033[1;31mREMOVE\033[0m"
fi

##2.2.12 Ensure Samba is not installed (Automated)##
if ! rpm -q samba &> /dev/null; then
	echo -e "Samba not installed: \033[1;32mOK\033[0m"
else
	echo -e "Samba to be uninstalled: \033[1;31mREMOVE\033[0m"
fi

##2.2.13 Ensure HTTP Proxy Server is not installed (Automated)##
if ! rpm -q squid &> /dev/null; then
	echo -e "HTTP Proxy Server not installed: \033[1;32mOK\033[0m"
else
	echo -e "HTTP Proxy Server to be uninstalled: \033[1;31mREMOVE\033[0m"
fi

##2.2.14 Ensure net-snmp is not installed (Automated)##
if ! rpm -q net-snmp &> /dev/null; then
	echo -e "net-snmp not installed: \033[1;32mOK\033[0m"
else
	echo -e "net-snmp to be uninstalled: \033[1;31mREMOVE\033[0m"
fi

##2.2.15 Ensure NIS server is not installed (Automated)##
if ! rpm -q ypserv &> /dev/null; then
	echo -e "NIS server not installed: \033[1;32mOK\033[0m"
else
	echo -e "NIS server to be uninstalled: \033[1;31mREMOVE\033[0m"
fi

##2.2.16 Ensure telnet-server is not installed (Automated)##
if ! rpm -q telnet-server &> /dev/null; then
	echo -e "telnet-server not installed: \033[1;32mOK\033[0m"
else
	echo -e "telnet-server to be uninstalled: \033[1;31mREMOVE\033[0m"
fi

##2.2.18 Ensure nfs-utils is not installed or the nfs-server service is masked(Automated)##
if ! systemctl is-enabled nfs-server &> /dev/null; then
	echo -e "nfs-server service is masked: \033[1;32mOK\033[0m"
else
	echo -e "nfs-server service is not masked: \033[1;31mREMOVE\033[0m"
fi

##2.2.19 Ensure rpcbind is not installed or the rpcbind services are masked(Automated)##
if ! systemctl is-enabled rpcbind &> /dev/null; then
	echo -e "rpcbind is masked: \033[1;32mOK\033[0m"
else
	echo -e "rpcbind is not masked: \033[1;31mREMOVE\033[0m"
fi

if ! systemctl is-enabled rpcbind.socket &> /dev/null; then
	echo -e "rpcbind services is masked: \033[1;32mOK\033[0m"
else
	echo -e "rpcbind services is not masked: \033[1;31mREMOVE\033[0m"
fi


##2.2.20 Ensure rsync is not installed or the rsyncd service is masked(Automated)##
if ! rpm -q rsync &> /dev/null; then
	echo -e "rsync not installed: \033[1;32mOK\033[0m"
else
	echo -e "rsync to be uninstalled: \033[1;31mREMOVE\033[0m"
fi
