
#!/bin/bash

##Auditing##

let COUNTER=0
touch audit-error.log

##1.2.3 Ensure gpgcheck is globally activated (Automated)##
if grep ^gpgcheck /etc/dnf/dnf.conf &> /dev/null; then
	echo -e "gpgcheck=1: \033[1;32mOK\033[0m"
	let COUNTER++
else
	echo -e "gpgcheck!=1: \033[1;31mERROR\033[0m"
	echo -e "gpgcheck!=1: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##For 1.8##

#To check if there's a GUI in Linux
if ls /usr/bin/*session | grep -q "/usr/bin/gnome-session" ; then

##1.8.2 Ensure GDM login banner is configured (Automated)##
if test -f /etc/dconf/profile/gdm; then

	if grep -q "user-db:user" /etc/dconf/profile/gdm &&
	grep -q "system-db:gdm" /etc/dconf/profile/gdm &&
	grep -q "file-db:/usr/share/gdm/greeter-dconf-defaults" /etc/dconf/profile/gdm; then 

	echo -e "GDM Profile is set: \033[1;32mOK\033[0m"
	let COUNTER++

	else
	echo -e "GDM Profile needs to be configured: \033[1;31mERROR\033[0m"
	echo -e "GDM Profile needs to be configured: \033[1;31mERROR\033[0m" >> audit-error.log
	fi
else 

echo -e "GDM Profile needs to be configured: \033[1;31mERROR\033[0m"
echo -e "GDM Profile needs to be configured: \033[1;31mERROR\033[0m" >> audit-error.log

fi

if test -f /etc/dconf/db/gdm.d/01-banner-message; then

	if grep -q "[org/gnome/login-screen]" /etc/dconf/db/gdm.d/01-banner-message &&
	grep -q "banner-message-enable=true" /etc/dconf/db/gdm.d/01-banner-message &&
	grep -q "banner-message-text='<banner message>" /etc/dconf/db/gdm.d/01-banner-message; then

	echo -e "Banner message is set: \033[1;32mOK\033[0m"

	let COUNTER++
	else
	echo -e "Banner message needs to be configured: \033[1;31mERROR\033[0m"
	echo -e "Banner message needs to be configured: \033[1;31mERROR\033[0m" >> audit-error.log
	fi
else 

echo -e "Banner message needs to be configured: \033[1;31mERROR\033[0m"
echo -e "Banner message needs to be configured: \033[1;31mERROR\033[0m" >> audit-error.log

fi 

##1.8.3 Ensure last logged in user display is disabled (Automated)##
if test -f /etc/dconf/db/gdm.d/00-login-screen; then

	if grep -q "[org/gnome/login-screen]" /etc/dconf/db/gdm.d/00-login-screen &&
	grep -q "disable-user-list=true" /etc/dconf/db/gdm.d/00-login-screen; then

	echo -e "Last Logged Display is set: \033[1;32mOK\033[0m"

	let COUNTER++
	else
	echo -e "Last Logged Display needs to be configured: \033[1;31mERROR\033[0m"
	echo -e "Last Logged Display needs to be configured: \033[1;31mERROR\033[0m" >> audit-error.log
	fi
else

echo -e "Last Logged Display needs to be configured: \033[1;31mERROR\033[0m"
echo -e "Last Logged Display needs to be configured: \033[1;31mERROR\033[0m" >> audit-error.log
fi
fi

##1.10 Ensure system-wide crypto policy is not legacy (Automated)##
if ! grep -E -i '^\s*LEGACY\s*(\s+#.*)?$' /etc/crypto-policies/config &> /dev/null; then
	echo -e "System-wide crypto policy: \033[1;32mOK\033[0m"
	let COUNTER++
else
	echo -e "System-wide crypto policy not set to default: \033[1;31mERROR\033[0m"
	echo -e "System-wide crypto policy not set to default: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##AUDIT##

##1.3 Filesystem Integrity Checking##
##1.3.1 Ensure AIDE is installed##

if  rpm -q aide &> /dev/null; then
	rpm -q aide
	echo -e "AIDE is already installed: \033[1;32mOK\033[0m"
	let COUNTER++
else
	echo -e "AIDE needs to be installed: \033[1;31mERROR\033[0m"
	echo -e "AIDE needs to be installed: \033[1;31mERROR\033[0m" >> audit-error.log
fi


##1.3.2 Ensure filesystem integrity is regularly checked##

if  grep -Ers '^([^#]+\s+)?(\/usr\/s?bin\/|^\s*)aide(\.wrapper)?\s(--?\S+\s)*(--(check|update)|\$AIDEARGS)\b' /etc/cron.* /etc/crontab /var/spool/cron/ &> /dev/null; then
	echo -e "Check: \033[1;32mOK\033[0m"
	let COUNTER++
else
	echo -e "Check: \033[1;31mERROR\033[0m"
	echo -e "Check: \033[1;31mERROR\033[0m" >> audit-error.log
fi

if grep "set superusers" /boot/grub2/grub.cfg &> /dev/null; then
    echo -e "Superuser is set: \033[1;32mOK\033[0m"
	let COUNTER++
else
    echo -e "Superuser is not set: \033[1;31mERROR\033[0m"
	echo -e "Superuser is not set: \033[1;31mERROR\033[0m" >> audit-error.log
fi

if grep "password" /boot/grub2/grub.cfg &> /dev/null; then 
    echo -e "Grub2 password is set: \033[1;32mOK\033[0m"
	let COUNTER++
else
    echo -e "Grub2 password not set: \033[1;31mERROR\033[0m"
	echo -e "Grub2 password not set: \033[1;31mERROR\033[0m" >> audit-error.log
fi

if grep -r /systemd-sulogin-shell &> /dev/null || grep -r /usr/lib/systemd/system/rescue.service &> /dev/null || grep -r /etc/systemd/system/rescue.service.d &> /dev/null; then
    echo -e "Authentication in rescue mode set: \033[1;32mOK\033[0m"
	let COUNTER++
else
	echo -e "Authentication in rescue mode not set! \033[1;31mERROR\033[0m"
    echo -e "Authentication in rescue mode not set! \033[1;31mERROR\033[0m" >> audit-error.log
fi

if grep -i '^\s*storage\s*=\s*none' /etc/systemd/coredump.conf &> /dev/null; then
    echo -e "Coredump storage equal to none: \033[1;32mOK\033[0m"
	let COUNTER++
else
	echo -e "Coredump not set to none: \033[1;31mERROR\033[0m"
    echo -e "Coredump not set to none: \033[1;31mERROR\033[0m" >> audit-error.log
fi

if grep -i '^\s*ProcessSizeMax\s*=\s*0' /etc/systemd/coredump.conf &> /dev/null; then
    echo -e "Coredump ProcessSizeMax equal to 0: \033[1;32mOK\033[0m"
	let COUNTER++
else
	echo -e "Coredump ProcessSizeMax not equal to 0: \033[1;31mERROR\033[0m"
    echo -e "Coredump ProcessSizeMax not equal to 0: \033[1;31mERROR\033[0m"  >> audit-error.log
fi

if sysctl kernel.randomize_va_space -eq 2 &> /dev/null; then
    echo -e "Kernerl randomize va space set to 2: \033[1;32mOK\033[0m"
	let COUNTER++
else
    echo -e "Kernel randomize va space not set to 2: \033[1;31mERROR\033[0m"
	echo -e "Kernel randomize va space not set to 2: \033[1;31mERROR\033[0m" >> audit-error.log
fi

if rpm -q libselinux &> /dev/null; then
    echo -e "Libselinux is installed: \033[1;32mOK\033[0m"
	let COUNTER++
else
    echo -e "Libselinux not installed: \033[1;31mERROR\033[0m"
	echo -e "Libselinux not installed: \033[1;31mERROR\033[0m" >> audit-error.log
fi

if ! grep "^\s*linux" /boot/grub2/grub.cfg &> /dev/null; then
    echo -e "SELinux is enabled at boot time: \033[1;32mOK\033[0m"
	let COUNTER++
else   
    echo -e "SELinux not enabled at boot time: \033[1;31mERROR\033[0m"
	echo -e "SELinux not enabled at boot time: \033[1;31mERROR\033[0m" >> audit-error.log
fi

if grep SELINUXTYPE=targeted /etc/selinux/config &> /dev/null; then
    echo -e "SELINUXTYPE set to targeted: \033[1;32mOK\033[0m"
	let COUNTER++
else
    echo -e "SELINUXTYPE not set to targeted: \033[1;31mERROR\033[0m"
	echo -e "SELINUXTYPE not set to targeted: \033[1;31mERROR\033[0m" >> audit-error.log
fi

if grep SELINUX=enforcing /etc/selinux/config &> /dev/null; then
    echo -e "SELINUX set to enforcing: \033[1;32mOK\033[0m"
	let COUNTER++
else   
    echo -e "SELINUX not set to enforcing: \033[1;31mERROR\033[0m"
	echo -e "SELINUX not set to enforcing: \033[1;31mERROR\033[0m" >> audit-error.log
fi

if ! ps -eZ | grep unconfined_service_t &> /dev/null; then
    echo -e "unconfined_service_t not running: \033[1;32mOK\033[0m"
	let COUNTER++
else
    echo -e "unconfined_service_t is running: \033[1;31mERROR\033[0m"
	echo -e "unconfined_service_t is running: \033[1;31mERROR\033[0m" >> audit-error.log
fi

if ! rpm -q setroubleshoot &> /dev/null; then
    echo -e "setroubleshoot not installed: \033[1;32mOK\033[0m"
	let COUNTER++
else
    echo -e "setroubleshoot is installed: \033[1;31mERROR\033[0m"
	echo -e "setroubleshoot is installed: \033[1;31mERROR\033[0m" >> audit-error.log
fi

if ! rpm -q mcstrans &> /dev/null; then
    echo -e "mcstrans not installed: \033[1;32mOK\033[0m"
	let COUNTER++
else
    echo -e "mcstrans is installed: \033[1;31mERROR\033[0m"
	echo -e "mcstrans is installed: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##AUDIT##

##1.7 Command Line Warning Banners##
##1.7.1 Ensure message of the day is configured properly##

if  cat /etc/motd &> /dev/null; then
	cat /etc/motd
	echo -e "MOTD removed: \033[1;32mOK\033[0m"
	let COUNTER++

else
	echo -e "MOTD needs to be removed:\033[1;31mERROR\033[0m"
	echo -e "MOTD needs to be removed:\033[1;31mERROR\033[0m" >> audit-error.log
fi

if grep -E -i "(\\\v|\\\r|\\\m|\\\s|$(grep '^ID=' /etc/os-release | cut -d= -f2 | sed -e 's/"//g'))" /etc/motd &> /dev/null; then
	echo -e "Results found: \033[1;31mERROR\033[0m"
	echo -e "Results found: \033[1;31mERROR\033[0m" >> audit-error.log
else
	echo -e "No results found: \033[1;32mOK\033[0m"
	let COUNTER++
fi

if  cat /etc/issue &> /dev/null; then
        cat /etc/issue
        echo -e "Configured properly: \033[1;32mOK\033[0m"
		let COUNTER++

else
    	echo -e "Configured properly: \033[1;31mERROR\033[0m"
		echo -e "Configured properly: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##1.7.2 Ensure local login warning banner is configured properly##

if  cat /etc/issue &> /dev/null; then
        cat /etc/issue
        echo -e "Configured properly: \033[1;32mOK\033[0m"
		let COUNTER++

else
    	echo -e "Configured properly:\033[1;31mERROR\033[0m"
		echo -e "Configured properly:\033[1;31mERROR\033[0m" >> audit-error.log
fi

if grep -E -i "(\\\v|\\\r|\\\m|\\\s|$(grep '^ID=' /etc/os-release | cut -d= -f2 | sed -e 's/"//g'))" /etc/issue; then
        echo -e "Results found: \033[1;31mERROR\033[0m"
		echo -e "Results found: \033[1;31mERROR\033[0m" >> audit-error.log
else
    	echo -e "No results found: \033[1;32mOK\033[0m"
		let COUNTER++
fi


##1.7.3 Ensure remote login warning banner is configured properly##

if  cat /etc/issue.net &> /dev/null; then
        cat /etc/issue.net
        echo -e "Configured properly: \033[1;32mOK\033[0m"
		let COUNTER++

else
    	echo -e "Configured properly:\033[1;31mERROR\033[0m"
		echo -e "Configured properly:\033[1;31mERROR\033[0m" >> audit-error.log 
fi

if grep -E -i "(\\\v|\\\r|\\\m|\\\s|$(grep '^ID=' /etc/os-release | cut -d= -f2 | sed -e 's/"//g'))" /etc/issue.net; then
        echo -e "Results found: \033[1;31mERROR\033[0m"
		echo -e "Results found: \033[1;31mERROR\033[0m" >> audit-error.log 
else
    	echo -e "No results found: \033[1;32mOK\033[0m"
		let COUNTER++
fi

##1.7.4 Ensure permissions on /etc/motd are configured##

##1.7.5 Ensure permissions on /etc/issue are configured##

if  stat /etc/issue &> /dev/null; then
        stat /etc/issue
        echo -e "Uid, Gid, and Access: \033[1;32mOK\033[0m"
		let COUNTER++

else
    	echo -e "Uid, Gid, and Access:\033[1;31mERROR\033[0m"
		echo -e "Uid, Gid, and Access:\033[1;31mERROR\033[0m" >> audit-error.log 
fi

##1.7.6 Ensure permissions on /etc/issue.net are configured##

if  stat /etc/issue.net &> /dev/null; then
       stat /etc/issue.net
        echo -e "Uid, Gid, and Access: \033[1;32mOK\033[0m"
		let COUNTER++

else
    	echo -e "Uid, Gid, and Access:\033[1;31mERROR\033[0m"
		echo -e "Uid, Gid, and Access:\033[1;31mERROR\033[0m" >> audit-error.log
fi

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

##3.1
if modprobe -n -v sctp &> /dev/null; then
	echo -e "SCTP is disabled: \033[1;32mOK\033[0m"
	 let COUNTER++
else
	echo -e "SCTP is not disabled: \033[1;31mERROR\033[0m"
	echo -e "SCTP is not disabled: \033[1;31mERROR\033[0m" >> audit-error.log
fi
lsmod | grep sctp

if modprobe -n -v dccp &> /dev/null; then
	echo -e "DCCP is disabled: \033[1;32mOK\033[0m"
	let COUNTER++	
else
	echo -e "DCCP is not disabled: \033[1;31mERROR\033[0m"
        echo -e "DCCP is not disabled: \033[1;31mERROR\033[0m" >> audit-error.log

fi
lsmod | grep sctp

{
 if command -v nmcli >/dev/null 2>&1 ; then
 if nmcli radio all | grep -Eq '\s*\S+\s+disabled\s+\S+\s+disabled\b';then
 echo -e "Wireless is not enabled: \033[1;32mOK\033[0m" 
else
 nmcli radio all
 fi
 elif [ -n "$(find /sys/class/net/*/ -type d -name wireless)" ]; then
 t=0
 mname=$(for driverdir in $(find /sys/class/net/*/ -type d -name
wireless | xargs -0 dirname); do basename "$(readlink -f
"$driverdir"/device/driver/module)";done | sort -u)
 for dm in $mname; do
 if grep -Eq "^\s*install\s+$dm\s+/bin/(true|false)"
/etc/modprobe.d/*.conf; then
 /bin/true
 else
 echo -e "$dm is not disabled: \033[1;32mOK\033[0m"
 t=1
 fi
 done
 [ "$t" -eq 0 ] && echo -e "Wireless is not enabled: \033[1;32mOK\033[0m"
 else
 echo -e "Wireless is not enabled: \033[1;32mOK\033[0m"
 fi
}

##3.2
if cat /etc/sysctl.d/60-netipv4_sysctl.conf | grep "net.ipv4.ip_forward = 0" &> /dev/null; then
    echo -e "IPv4 forwarding is disabled: \033[1;32mOK\033[0m"
    let COUNTER++
    if sysctl net.ipv4.ip_forward | grep "net.ipv4.ip_forward = 0" &> /dev/null; then
        echo -e "Kernel parameter for ip forwarding set to 0: \033[1;32mOK\033[0m"
         let COUNTER++
	else
        echo -e "Kernel parameter for ip forwarding not set to 0: \033[1;31mERROR\033[0m"
        echo -e "Kernel parameter for ip forwarding not set to 0: \033[1;31mERROR\033[0m" >> audit-error.log
    fi

     if sysctl net.ipv4.route.flush | grep "net.ipv4.route.flush = 1" &> /dev/null; then
        echo -e "Kernel parameter for route flush set to 1: \033[1;32mOK\033[0m"
	 let COUNTER++
    else
        echo -e "Kernel parameter for route flush not set to 1: \033[1;31mERROR\033[0m"
        echo -e "Kernel parameter for route flush not set to 1: \033[1;31mERROR\033[0m" >> audit-error.log
    fi
else
    echo -e "IPv4 forwarding might be enabled: \033[1;31mERROR\033[0m"
    echo -e "IPv4 forwarding might be enabled: \033[1;31mERROR\033[0m" >> audit-error.log

fi

echo "test"

# If IPv6 is enabled, uncomment this

# if cat /etc/sysctl.d/60-netipv6_sysctl.conf | grep "net.ipv6.conf.all.forwarding = 0" &> /dev/null; then
#     echo "IPv6 forwarding is disabled: \033[1;32mOK\033[0m"

#     if sysctl net.ipv6.conf.all.forwarding | grep "net.ipv6.conf.all.forwarding = 0" &> /dev/null; then
#         echo "Kernel parameter for ipv6 forwarding set to 0: \033[1;32mOK\033[0m"
#     else
#        echo "Kernel parameter for ip forwarding not set to 0: \033[1;31mERROR\033[0m"
#     fi

#      if sysctl net.ipv6.route.flush | grep "net.ipv6.route.flush = 1" &> /dev/null; then
#         echo "Kernel parameter for route flush set to 1: \033[1;32mOK\033[0m"
#     else
#         echo "Kernel parameter for route flush not set to 1: \033[1;31mERROR\033[0m"
#     fi
# else
#     echo "IPv6 forwarding might be enabled: \033[1;31mERROR\033[0m"
# fi

echo "test2"

if cat /etc/sysctl.d/60-netipv4_syctl.conf | grep "net.ipv4.conf.all.send_redirects = 0" &> /dev/null; then
    echo -e "Packet redirecting all set to 0: \033[1;32mOK\033[0m"
    let COUNTER++
    if sysctl net.ipv4.conf.all.send_redirects | grep "net.ipv4.conf.all.send_redirects = 0" &> /dev/null; then
        echo "Packet redirecting all set to 0 in kernel parameters: \033[1;32mOK\033[0m"
 	let COUNTER++    	
    else
        echo -e "Kernel parameter not set for packet redirecting: \033[1;31mERROR\033[0m"
        echo -e "Kernel parameter not set for packet redirecting: \033[1;31mERROR\033[0m"  >> audit-error.log
    fi
else
    echo -e "Packet redirecting might not be set to 0: \033[1;31mERROR\033[0m"
    echo -e "Packet redirecting might not be set to 0: \033[1;31mERROR\033[0m" >> audit-error.log
fi
if cat /etc/sysctl.d/60-netipv4_syctl.conf | grep "net.ipv4.conf.default.send_redirects = 0" &> /dev/null; then
    echo -e "Packet redirecting default set to 0: \033[1;32mOK\033[0m"
     let COUNTER++
    if sysctl net.ipv4.conf.default.send_redirects | grep "net.ipv4.conf.default.send_redirects = 0" &> /dev/null; then
        echo -e "Packet redirecting default set to 0 in kernel parameters: \033[1;32mOK\033[0m"
    	 let COUNTER++
	else
        echo -e "Kernel parameter not set for packet redirecting: \033[1;31mERROR\033[0m"
        echo -e "Kernel parameter not set for packet redirecting: \033[1;31mERROR\033[0m" >> audit-error.log
    fi
else
    echo -e "Default redirect might not be set to 0: \033[1;31mERROR\033[0m" 
    echo -e "Default redirect might not be set to 0: \033[1;31mERROR\033[0m" >> audit-error.log

fi

echo "test3"
##3.3##
##3.3.1 Ensure source routed packets are not accepted (Automated)##
if test -f /etc/sysctl.d/60-netipv4_sysctl.conf; then

	if grep -q "net.ipv4.conf.all.accept_source_route = 0" /etc/sysctl.d/60-netipv4_sysctl.conf &&
		 grep -q "net.ipv4.conf.default.accept_source_route = 0" /etc/sysctl.d/60-netipv4_sysctl.conf; then

		 echo -e "Source routed packets are not accepted: \033[1;32mOK\033[0m"
		 let COUNTER++
	else
		echo -e "Source routed packets are accepted: \033[1;31mERROR\033[0m" 
          echo -e "Source routed packets are accepted: \033[1;31mERROR\033[0m" >> audit-error.log
	fi
else
echo -e "Source routed packets are accepted: \033[1;31mERROR\033[0m"
echo -e "Source routed packets are accepted: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##3.3.2 Ensure ICMP redirects are not accepted (Automated)##
if test -f /etc/sysctl.d/60-netipv4_sysctl.conf; then

	if grep -q "net.ipv4.conf.all.accept_redirects = 0" /etc/sysctl.d/60-netipv4_sysctl.conf &&
		 grep -q "net.ipv4.conf.default.accept_redirects = 0" /etc/sysctl.d/60-netipv4_sysctl.conf; then

		 echo -e "ICMP redirects are not accepted: \033[1;32mOK\033[0m"
		 let COUNTER++
	else
		 echo -e "ICMP redirects are accepted: \033[1;31mERROR\033[0m"
                 echo -e "ICMP redirects are accepted: \033[1;31mERROR\033[0m"  >> audit-error.log

	 fi
else
echo -e "ICMP redirects are accepted: \033[1;31mERROR\033[0m"
echo -e "ICMP redirects are accepted: \033[1;31mERROR\033[0m"  >> audit-error.log

fi

##3.3.2 Ensure secure ICMP redirects are not accepted (Automated)##
if test -f /etc/sysctl.d/60-netipv4_sysctl.conf; then

	if grep -q "net.ipv4.conf.all.secure_redirects = 0" /etc/sysctl.d/60-netipv4_sysctl.conf &&
		 grep -q "net.ipv4.conf.default.secure_redirects = 0" /etc/sysctl.d/60-netipv4_sysctl.conf; then

		 echo -e "Secure ICMP redirects are not accepted: \033[1;32mOK\033[0m"
		 let COUNTER++
	else
		echo -e "Secure ICMP redirects are accepted: \033[1;31mERROR\033[0m"
 		echo -e "Secure ICMP redirects are accepted: \033[1;31mERROR\033[0m" >> audit-error.log
	 fi
else
echo -e "Secure ICMP redirects are accepted: \033[1;31mERROR\033[0m"
echo -e "Secure ICMP redirects are accepted: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##3.3.4 Ensure suspicious packets are logged (Automated)##
if test -f /etc/sysctl.d/60-netipv4_sysctl.conf; then

	if grep -q "net.ipv4.conf.all.log_martians = 1" /etc/sysctl.d/60-netipv4_sysctl.conf &&
		 grep -q "net.ipv4.conf.all.log_martians = 1" /etc/sysctl.d/60-netipv4_sysctl.conf; then

		 echo -e "Suspicious packets are logged: \033[1;32mOK\033[0m"
		 let COUNTER++
	else
		 echo -e "Suspicious packets are not logged: \033[1;31mERROR\033[0m"
                 echo -e "Suspicious packets are not logged: \033[1;31mERROR\033[0m" >> audit-error.log

	 fi
else
echo -e "Suspicious packets are not logged: \033[1;31mERROR\033[0m" 
echo -e "Suspicious packets are not logged: \033[1;31mERROR\033[0m" >> audit-error.log

fi

##3.3.5 Ensure broadcast ICMP requests are ignored (Automated)##
if test -f /etc/sysctl.d/60-netipv4_sysctl.conf; then

	if grep -q "net.ipv4.icmp_echo_ignore_broadcasts = 1" /etc/sysctl.d/60-netipv4_sysctl.conf; then

		 echo -e "Broadcast ICMP requests are ignored: \033[1;32mOK\033[0m"
		 let COUNTER++
	else
		 echo -e "Broadcast ICMP requests are not ignored: \033[1;31mERROR\033[0m"
 		echo -e "Broadcast ICMP requests are not ignored: \033[1;31mERROR\033[0m" >> audit-error.log
	 fi
else
echo -e "Broadcast ICMP requests are not ignored: \033[1;31mERROR\033[0m"
echo -e "Broadcast ICMP requests are not ignored: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##3.3.6 Ensure bogus ICMP responses are ignored (Automated)##
if test -f /etc/sysctl.d/60-netipv4_sysctl.conf; then

	if grep -q "net.ipv4.icmp_ignore_bogus_error_responses = 1" /etc/sysctl.d/60-netipv4_sysctl.conf; then

		 echo -e "Bogus ICMP responses are ignored: \033[1;32mOK\033[0m"
		 let COUNTER++
	else
		 echo -e "Bogus ICMP responses are not ignored: \033[1;31mERROR\033[0m"
		echo -e "Bogus ICMP responses are not ignored: \033[1;31mERROR\033[0m" >> audit-error.log
	 fi
else
echo -e "Bogus ICMP responses are not ignored: \033[1;31mERROR\033[0m" 
echo -e "Bogus ICMP responses are not ignored: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##3.3.7 Ensure Reverse Path Filtering is enabled (Automated)##
if test -f /etc/sysctl.d/60-netipv4_sysctl.conf; then

	if grep -q "net.ipv4.conf.all.rp_filter = 1" /etc/sysctl.d/60-netipv4_sysctl.conf &&
		 grep -q "net.ipv4.conf.default.rp_filter = 1" /etc/sysctl.d/60-netipv4_sysctl.conf; then

		 echo -e "Reverse Path Filtering is enabled: \033[1;32mOK\033[0m"
		 let COUNTER++
	else
		 echo -e "Reverse Path Filtering is not enabled: \033[1;31mERROR\033[0m"
		echo -e "Reverse Path Filtering is not enabled: \033[1;31mERROR\033[0m" >> audit-error.log
    fi
else
echo -e "Reverse Path Filtering is not enabled: \033[1;31mERROR\033[0m"
echo -e "Reverse Path Filtering is not enabled: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##3.3.8 Ensure TCP SYN Cookies is enabled (Automated)##
if test -f /etc/sysctl.d/60-netipv4_sysctl.conf; then

	if grep -q "net.ipv4.tcp_syncookies = 1" /etc/sysctl.d/60-netipv4_sysctl.conf; then

		 echo -e "TCP SYN Cookies is enabled: \033[1;32mOK\033[0m"
		 let COUNTER++
	else
		echo -e "TCP SYN Cookies is not enabled: \033[1;31mERROR\033[0m"
		 echo -e "TCP SYN Cookies is not enabled: \033[1;31mERROR\033[0m" >> audit-error.log

	 fi
else
echo -e "TCP SYN Cookies is not enabled: \033[1;31mERROR\033[0m"
echo -e "TCP SYN Cookies is not enabled: \033[1;31mERROR\033[0m" >> audit-error.log
fi


##3.3.9 Ensure IPv6 router advertisements are not accepted (Automated)##
if test -f /etc/sysctl.d/60-netipv4_sysctl.conf; then

	if grep -q "net.ipv6.conf.all.accept_ra = 0" /etc/sysctl.d/60-netipv4_sysctl.conf &&
		 grep -q "net.ipv6.conf.default.accept_ra = 0" /etc/sysctl.d/60-netipv4_sysctl.conf; then

		 echo -e "IPv6 router advertisements are not accepted: \033[1;32mOK\033[0m"
		 let COUNTER++
	else
		echo -e "IPv6 router advertisements are not accepted: \033[1;31mERROR\033[0m" 
		 echo -e "IPv6 router advertisements are not accepted: \033[1;31mERROR\033[0m" >> audit-error.log
	 fi
else
echo -e "IPv6 router advertisements are not accepted: \033[1;31mERROR\033[0m" 
echo -e "IPv6 router advertisements are not accepted: \033[1;31mERROR\033[0m" >> audit-error.log

fi

##3.4.1

##3.4.1.1 Ensure firewalld is installed
if rpm -q firewalld iptables &> /dev/null; then
    echo -e "firewalld and iptables installed: \033[1;32mOK\033[0m"
     let COUNTER++
else
     echo -e "firewalld and iptables not found: \033[1;31mERROR\033[0m"   
     echo -e "firewalld and iptables not found: \033[1;31mERROR\033[0m" >> audit-error.log

fi
##3.4.1.2 Ensure iptables-services not installed with firewalld
if rpm -q iptables-services &> /dev/null; then
    echo -e "package iptables-services found: \033[1;31mERROR\033[0m"
     let COUNTER++
else   
   echo -e "package iptables-services not installed: \033[1;32mOK\033[0m"
  echo -e "package iptables-services not installed: \033[1;32mOK\033[0m" >> audit-error.log

fi

##3.4.1.3 Ensure nftables either not installed or masked with firewalld 
if  rpm -q nftables &> /dev/null; then
     echo -e "package nftables not installed: \033[1;32mOK\033[0m"
     let COUNTER++
else   
     echo -e "package nftables found: \033[1;31mERROR\033[0m"
     echo -e "package nftables found: \033[1;31mERROR\033[0m" >> audit-error.log

fi

##3.4.1.4 Ensure firewalld service enabled and running
if  systemctl is-enabled firewalld &> /dev/null; then
    echo -e "Enabled: \033[1;32mOK\033[0m"
     let COUNTER++
else   
    echo -e "Not enabled: \033[1;31mERROR\033[0m"
    echo -e "Not enabled: \033[1;31mERROR\033[0m" >> audit-error.log

fi

if  firewall-cmd --state &> /dev/null; then
    echo -e "Running: \033[1;32mOK\033[0m"
    let COUNTER++
else   
    echo -e "Not running: \033[1;31mERROR\033[0m"
    echo -e "Not running: \033[1;31mERROR\033[0m" >> audit-error.log

fi

##3.4.1.5 Ensure firewalld default zone is set 

if   firewall-cmd --get-default-zone &> /dev/null; then
    echo -e "Zone is set: \033[1;32mOK\033[0m"
    let COUNTER++
else   
    echo -e "No zone found: \033[1;31mERROR\033[0m"
    echo -e "No zone found: \033[1;31mERROR\033[0m" >> audit-error.log

fi

##3.4.2

##3.4.2.1 Ensure nftables is installed (Automated)

if  rpm -q nftables &> /dev/null; then
    echo -e "nftables installed: \033[1;32mOK\033[0m"
    let COUNTER++
else   
     echo -e "nftable not found: \033[1;31mERROR\033[0m"
     echo -e "nftable not found: \033[1;31mERROR\033[0m" >> audit-error.log

fi
##3.4.2.2 Ensure firewalld is either not installed or masked with nftables 
if   systemctl is-enabled firewalld &> /dev/null; then
    echo -e "firewalld unmasked: \033[1;31mERROR\033[0m"
     let COUNTER++
else   
   echo -e "firewalld nmasked: \033[1;32mOK\033[0m"
   echo -e "firewalld nmasked: \033[1;32mOK\033[0m" >> audit-error.log
fi
##3.4.2.3 Ensure iptables-services not installed with nftables
if  rpm -q iptables-services &> /dev/null; then
     echo -e "package iptables-services found: \033[1;31mERROR\033[0m"
     let COUNTER++
else
     echo -e "package iptables-services not installed: \033[1;32mOK\033[0m"    
     echo -e "package iptables-services not installed: \033[1;32mOK\033[0m" >> audit-error.log

fi

##3.4.2.4 Ensure iptables are flushed with nftables (Manual)

##3.4.2.5 Ensure an nftables table exists
 nft list tables
echo -e  "nftables table exists: \033[1;32mOK\033[0m"
 let COUNTER++

##3.4.2.6 Ensure nftables base chains exist

if   nft list ruleset | grep 'hook input' &> /dev/null; then
     echo -e "type filter hook input priority 0: \033[1;32mOK\033[0m"
     let COUNTER++
else   
     echo -e "type filter hook input priority 0 not found: \033[1;31mERROR\033[0m"
     echo -e "type filter hook input priority 0 not found: \033[1;31mERROR\033[0m" >> audit-error.log

fi

if    nft list ruleset | grep 'hook forward' &> /dev/null; then
     echo -e "type filter hook forward priority 0: \033[1;32mOK\033[0m"  
     let COUNTER++
else   
     echo -e "type filter hook forward priority 0 not found: \033[1;31mERROR\033[0m"
     echo -e "type filter hook forward priority 0 not found: \033[1;31mERROR\033[0m" >> audit-error.log

fi

if     nft list ruleset | grep 'hook output' &> /dev/null; then
     echo -e "type filter hook output priority 0: \033[1;32mOK\033[0m"
     let COUNTER++
else   
     echo -e "type filter hook output priority 0 not found: \033[1;31mERROR\033[0m"
     echo -e "type filter hook output priority 0 not found: \033[1;31mERROR\033[0m" >> audit-error.log
fi


##3.4.2.7 Ensure nftables loopback traffic is configured

if     nft list ruleset | awk '/hook input/,/}/' | grep 'iif "lo" accept' &> /dev/null; then
     echo -e "loopback interface configured: \033[1;32mOK\033[0m"
     let COUNTER++
else   
     echo -e "loopback interface configured: \033[1;31mERROR\033[0m"
     echo -e "loopback interface configured: \033[1;31mERROR\033[0m" >> audit-error.log

fi



##3.4.2.8 Ensure nftables outbound and established connections are configured (Manual)

##3.4.2.9 Ensure nftables default deny firewall policy (Automated)

if     nft list ruleset | grep 'hook input' &> /dev/null; then
     echo -e "type filter hook input priority 0; policy drop configured: \033[1;32mOK\033[0m"
     let COUNTER++
else   
     echo -e "type filter hook input priority 0; policy drop not configured: \033[1;31mERROR\03$"
     echo -e "type filter hook input priority 0; policy drop not configured: \033[1;31mERROR\03$" >> audit-error.log

fi

if     nft list ruleset | grep 'hook forward' &> /dev/null; then
     echo -e "type filter hook forward priority 0; policy drop configured: \033[1;32mOK\033[0m"
     let COUNTER++
else   
     echo -e "type filter hook forward priority 0; policy drop not configured: \033[1;31mERROR\$"
     echo -e "type filter hook forward priority 0; policy drop not configured: \033[1;31mERROR\$" >> audit-error.log

fi

if     nft list ruleset | grep 'hook output' &> /dev/null; then
     echo -e "type filter hook output priority 0; policy drop configured: \033[1;32mOK\033[0m"
     let COUNTER++
else   
     echo -e "type filter hook output priority 0; policy drop not configured: \033[1;31mERROR\0$"
     echo -e "type filter hook output priority 0; policy drop not configured: \033[1;31mERROR\0$" >> audit-error.log
fi

##3.4.2.10 Ensure nftables service is enabled## 
if     systemctl is-enabled nftables &> /dev/null; then
     echo -e "nftables services enabled: \033[1;32mOK\033[0m"
     let COUNTER++
else   
     echo -e "nftables services not enabled: \033[1;31mERROR\033[0m"
     echo -e "nftables services not enabled: \033[1;31mERROR\033[0m" >> audit-error.log

fi

if rpm -q iptables ip tables-services &> /dev/null; then
    echo -e "iptables installed: \033[1;32mOK\033[0m"
    let COUNTER++
else   
    echo -e "ip tables not found: \033[1;31mERROR\033[0m"
    echo -e "ip tables not found: \033[1;31mERROR\033[0m" >> audit-error.log

fi

if rpm -q nftables &> /dev/null; then
    echo -e "nftables installed: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "nftables not installed: \033[1;31mERROR\033[0m"
    echo -e "nftables not installed: \033[1;31mERROR\033[0m" >> audit-error.log

fi

if rpm -q firewalld &> /dev/null; then
    echo -e "firewalld installed: \033[1;32mOK\033[0m"
     let COUNTER++
else
    echo -e "firewalld not installed: \033[1;31mERROR\033[0m"
     echo -e "firewalld not installed: \033[1;31mERROR\033[0m" >> audit-error.log

fi

##4.1.1.1 Ensure auditd is installed
if rpm -q audit &> /dev/null; then
   echo -e "auditd installed: \033[1;32mOK\033[0m"
   let COUNTER++
else   
  echo -e "auditd not found: \033[1;31mERROR\033[0m"
  echo -e "auditd not found: \033[1;31mERROR\033[0m" >> audit-error.log
fi


##4.1.1.2 Ensure auditd service is enabled
if systemctl is-enabled auditd &> /dev/null; then
   echo -e "auditd is enabled: \033[1;32mOK\033[0m"
   let COUNTER++
else   
  echo -e "auditd not enabled: \033[1;31mERROR\033[0m"
  echo -e "auditd not enabled: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##4.1.1.3 Ensure auditing for processes that start prior to auditd is enabled
if find /boot -type f -name 'grubenv' -exec grep -P 'kernelopts=([^#\n\r]+\h+)?(audit=1)' {} \; &> /dev/null; then
   echo -e "audit=1 found: \033[1;32mOK\033[0m"
   let COUNTER++
else   
  echo -e "audit=1 not found: \033[1;31mERROR\033[0m"
  echo -e "audit=1 not found: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##4.1.1.4 Ensure audit_backlog_limit is sufficient 
if find /boot -type f -name 'grubenv' -exec grep -P 'kernelopts=([^#\n\r]+\h+)?(audit_backlog_limit=\S+\b)' {} \; &> /dev/null; then
   echo -e "audit_backlog_limit value is sufficient: \033[1;32mOK\033[0m"
   let COUNTER++
else   
  echo -e "audit_backlog_limit value is not sufficient: \033[1;31mERROR\033[0m"
  echo -e "audit_backlog_limit value is not sufficient: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##4.1.2.1 Ensure audit log storage size is configured 
if grep -w "^\s*max_log_file\s*=" /etc/audit/auditd.conf &> /dev/null; then
   echo -e "audit storage size configured: \033[1;32mOK\033[0m"
   let COUNTER++
else   
  echo -e "audit storage size not configured: \033[1;31mERROR\033[0m"
  echo -e "audit storage size not configured: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##4.1.2.2 Ensure audit logs are not automatically deleted
if grep max_log_file_action /etc/audit/auditd.conf &> /dev/null; then
   echo -e "logs not automatically deleted: \033[1;32mOK\033[0m"
   let COUNTER++
else   
  echo -e "logs automatically deleted: \033[1;31mERROR\033[0m"
  echo -e "logs automatically deleted: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##4.1.2.3 Ensure system is disabled when audit logs are full 
if grep space_left_action /etc/audit/auditd.conf &> /dev/null; then
   echo -e "space_left_action = email: \033[1;32mOK\033[0m"
   let COUNTER++
else   
  echo -e "space_left_action = unknown: \033[1;31mERROR\033[0m"
  echo -e "space_left_action = unknown: \033[1;31mERROR\033[0m" >> audit-error.log
fi

if grep action_mail_acct /etc/audit/auditd.conf &> /dev/null; then
   echo -e "action_mail_acct = root: \033[1;32mOK\033[0m"
   let COUNTER++
else   
  echo -e "action_mail_acct = unknown: \033[1;31mERROR\033[0m"
  echo -e "action_mail_acct = unknown: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##4.1.3.1 Ensure changes to system administration scope (sudoers) is collected
if [ $(grep -c scope /etc/audit/rules.d/50-scope.rules) -eq 2 ]; then
	echo -e "Administration scope (sudo) collection is set in disk config: \033[1;32mOK\033[0m"
    let COUNTER++
else
	echo -e "Administration scope (sudo) collection is not set in disk config: \033[1;31mERROR\033[0m"
    echo -e "Administration scope (sudo) collection is not set in disk config: \033[1;31mERROR\033[0m" >> audit-error.log
fi

if [$(auditctl -l | grep -c scope) -eq 2]; then
	echo -e "Administration scope (sudo) collection is set in running config: \033[1;32mOK\033[0m"
    let COUNTER++
else
	echo -e "Administration scope (sudo) collection not set in running config: \033[1;31mERROR\033[0m"
    echo -e "Administration scope (sudo) collection not set in running config: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##4.1.3.2 Ensure actions as another user are always logged
if [ $(grep -c user_emulation /etc/audit/rules.d/50-user_emulation.rules) -eq 2 ]; then
	echo -e "Actions as another user logs is set in disk config: \033[1;32mOK\033[0m"
    let COUNTER++
else
	echo -e "Actions as another user logs is not set in disk config: \033[1;31mERROR\033[0m"
    echo -e "Actions as another user logs is not set in disk config: \033[1;31mERROR\033[0m" >> audit-error.log
fi

if [$(auditctl -l | grep -c user_emulation) -eq 2 ]; then
	echo -e "Actions as another user logs is set in running config: \033[1;32mOK\033[0m"
    let COUNTER++
else
	echo -e "Actions as another user logs is not set in running config: \033[1;31mERROR\033[0m"
    echo -e "Actions as another user logs is not set in running config: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##4.1.3.3 Ensure events that modify the sudo log file are collected
if [ $(grep -c sudo_log_file /etc/audit/rules.d/50-sudo.rules) -eq 1 ]; then
	echo -e "Sudo log file modification events is set in disk config: \033[1;32mOK\033[0m"
    let COUNTER++
else
	echo -e "Sudo log file modification events is not set in disk config: \033[1;31mERROR\033[0m"
    echo -e "Sudo log file modification events is not set in disk config: \033[1;31mERROR\033[0m" >> audit-error.log
fi

if [$(auditctl -l | grep -c sudo_log_file) -eq 1]; then
	echo -e "Sudo log file modification events is set in running config: \033[1;32mOK\033[0m"
    let COUNTER++
else
	echo -e "Sudo log file modification events is not set in running config: \033[1;31mERROR\033[0m"
    echo -e "Sudo log file modification events is not set in running config: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##4.1.3.4 Ensure events that modify date and time information are collected
if [ $(grep -c time-change /etc/audit/rules.d/50-time-change.rules) -eq 3 ]; then
	echo -e "Date and time info modification events set in disk config: \033[1;32mOK\033[0m"
    let COUNTER++
else
	echo -e "Date and time info modification events not set in disk config: \033[1;31mERROR\033[0m"
    echo -e "Date and time info modification events not set in disk config: \033[1;31mERROR\033[0m" >> audit-error.log
fi

if [ $(auditctl -l | grep -c time-change) -eq 3 ]; then
	echo -e "Date and time info modification events set in running config: \033[1;32mOK\033[0m"
    let COUNTER++
else
	echo -e "Date and time info modification events not set in running config: \033[1;31mERROR\033[0m"
    echo -e "Date and time info modification events not set in running config: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##4.1.3.5 Ensure events that modify the system's network environment are collected
if [ $(grep -c system-locale /etc/audit/rules.d/50-system_local.rules) -eq 7 ]; then
	echo -e "Network environment modification events set in disk config: \033[1;32mOK\033[0m"
    let COUNTER++
else
	echo -e "Network environment modification events not set in disk config: \033[1;31mERROR\033[0m"
    echo -e "Network environment modification events not set in disk config: \033[1;31mERROR\033[0m" >> audit-error.log
fi

if [ $(auditctl -l | grep -c system-locale) -eq 7 ]; then
	echo -e "Network environment modification events set in running config: \033[1;32mOK\033[0m"
    let COUNTER++
else
	echo -e "Network environment modification events not set in running config: \033[1;31mERROR\033[0m"
    echo -e "Network environment modification events not set in running config: \033[1;31mERROR\033[0m" >> audit-error.log
fi

# 4.1.3.7

if [ $(grep -c access /etc/audit/rules.d/50-access.rules) -eq 4 ]; then
    echo -e "Access rules for file systems set on disk config: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "Access rules for file systems not set on disk config: \033[1;31mERROR\033[0m"
    echo -e "Access rules for file systems not set on disk config: \033[1;31mERROR\033[0m" >> audit-error.log
fi

if [ $(auditctl -l | grep -c access) -eq 4 ]; then
    echo -e "Access rules for file systems set on running config: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "Access rules for file systems not set on running config: \033[1;31mERROR\033[0m"
    echo -e "Access rules for file systems not set on running config: \033[1;31mERROR\033[0m" >> audit-error.log
fi

# 4.1.3.8 

if [ $(grep -c identity /etc/audit/rules.d/50-identity.rules) -eq 5 ]; then
    echo -e "User/Group info modification events set on disk config: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "User/Group info modification events not set on disk config: \033[1;31mERROR\033[0m"
    echo -e "User/Group info modification events not set on disk config: \033[1;31mERROR\033[0m" >> audit-error.log
fi

if [ $(auditctl -l | grep -c identity) -eq 5 ]; then
    echo -e "User/Group info modification events set on running config: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "User/Group info modification events not set on running config: \033[1;31mERROR\033[0m"
    echo -e "User/Group info modification events not set on running config: \033[1;31mERROR\033[0m" >> audit-error.log
fi

# 4.1.3.9

if [ $(grep -c perm_mod /etc/audit/rules.d/50-perm_mod.rules) -eq 6 ]; then
    echo -e "Permission modification events set on disk config: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "Permission modification events not set on disk config: \033[1;31mERROR\033[0m"
    echo -e "Permission modification events not set on disk config: \033[1;31mERROR\033[0m" >> audit-error.log
fi

if [ $(auditctl -l | grep -c perm_mod) -eq 6 ]; then
    echo -e "Permission modification events set on running config: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "Permission modification events not set on running config: \033[1;31mERROR\033[0m"
    echo -e "Permission modification events not set on running config: \033[1;31mERROR\033[0m" >> audit-error.log
fi

# 4.1.3.10

if [ $(grep -c mounts /etc/audit/rules.d/50-perm_mod.rules) -eq 2 ]; then
    echo -e "Successful file system mounts events set on disk config: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "Successful file system mounts events not set on disk config: \033[1;31mERROR\033[0m"
    echo -e "Successful file system mounts events not set on disk config: \033[1;31mERROR\033[0m" >> audit-error.log
fi

if [ $(auditctl -l | grep -c mounts) -eq 2 ]; then
    echo -e "Successful file system mounts events set on running config: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "Successful file system mounts events not set on running config: \033[1;31mERROR\033[0m"
    echo -e "Successful file system mounts events not set on running config: \033[1;31mERROR\033[0m" >> audit-error.log
fi

# 4.1.3.11

if [ $(grep -c session /etc/audit/rules.d/50-session.rules) -eq 3 ]; then
    echo -e "Session initiation information set on disk config: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "Session initiation information not set on disk config: \033[1;31mERROR\033[0m"
    echo -e "Session initiation information not set on disk config: \033[1;31mERROR\033[0m" >> audit-error.log
fi

if [ $(auditctl -l | grep -c session) -eq 3 ]; then
    echo -e "Session initiation information set on running config: \033[1;32mOK\033[0m"
else
    echo -e "Session initiation information not set on running config: \033[1;31mERROR\033[0m"
    echo -e "Session initiation information not set on running config: \033[1;31mERROR\033[0m" >> audit-error.log
fi

# 4.1.3.12

if [ $(grep -c logins /etc/audit/rules.d/50-login.rules) -eq 2 ]; then
    echo -e "Login and logout events set on disk config: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "Login and logout events not set on disk config: \033[1;31mERROR\033[0m"
    echo -e "Login and logout events not set on disk config: \033[1;31mERROR\033[0m" >> audit-error.log
fi

if [ $(auditctl -l | grep -c logins) -eq 2 ]; then
    echo -e "Login and logout events set on running config: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "Login and logout events not set on running config: \033[1;31mERROR\033[0m"
    echo -e "Login and logout events not set on running config: \033[1;31mERROR\033[0m" >> audit-error.log
fi

# 4.1.3.13

if [ $(grep -c delete /etc/audit/rules.d/50-delete.rules) -eq 2 ]; then
    echo -e "File deletion events set on disk config: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "File deletion events not set on disk config: \033[1;31mERROR\033[0m"
    echo -e "File deletion events not set on disk config: \033[1;31mERROR\033[0m" >> audit-error.log
fi

if [ $(auditctl -l | grep -c delete) -eq 2 ]; then
    echo  "File deletion events set on running config: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "File deletion events not set on running config: \033[1;31mERROR\033[0m"
    echo -e "File deletion events not set on running config: \033[1;31mERROR\033[0m" >> audit-error.log
fi

# 4.1.3.14

if [ $(grep -c MAC-policy /etc/audit/rules.d/50-MAC-policy.rules) -eq 2 ]; then
    echo -e "MAC system modification events set on disk config: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "MAC system modification events not set on disk config: \033[1;31mERROR\033[0m"
    echo -e "MAC system modification events not set on disk config: \033[1;31mERROR\033[0m" >> audit-error.log
fi

if [ $(auditctl -l | grep -c MAC-policy) -eq 2 ]; then
    echo -e "MAC system modification events set on running config: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "MAC system modification events not set on running config: \033[1;31mERROR\033[0m"
    echo -e "MAC system modification events not set on running config: \033[1;31mERROR\033[0m" >> audit-error.log
fi

# 4.1.3.15

if [ $(grep -c path=/usr/bin/chcon /etc/audit/rules.d/50-perm_chng.rules) -eq 1 ]; then
    echo -e "Unsuccessful chcon events set on disk config: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "Unsuccessful chcon events not set on disk config: \033[1;31mERROR\033[0m"
    echo -e "Unsuccessful chcon events not set on disk config: \033[1;31mERROR\033[0m" >> audit-error.log
fi

if [ $(auditctl -l | grep -c path=/usr/bin/chcon) -eq 1 ]; then
    echo -e "Unsuccessful chcon events set on running config: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "Unsuccessful chcon events not set on running config: \033[1;31mERROR\033[0m"
    echo -e "Unsuccessful chcon events not set on running config: \033[1;31mERROR\033[0m" >> audit-error.log
fi

# 4.1.3.16

if [ $(grep -c path=/usr/bin/setfacl /etc/audit/rules.d/50-priv_cmd.rules) -eq 1 ]; then
    echo -e "Unsuccessful setfacl events set on disk config: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "Unsuccessful setfacl events not set on disk config: \033[1;31mERROR\033[0m"
    echo -e "Unsuccessful setfacl events not set on disk config: \033[1;31mERROR\033[0m" >> audit-error.log
fi

if [ $(auditctl -l | grep -c path=/usr/bin/setfacl) -eq 1 ]; then
    echo -e "Unsuccessful setfacl events set on running config: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "Unsuccessful setfacl events not set on running config: \033[1;31mERROR\033[0m"
    echo -e "Unsuccessful setfacl events not set on running config: \033[1;31mERROR\033[0m" >> audit-error.log
fi

# 4.1.3.17

if [ $(grep -c path=/usr/bin/chacl /etc/audit/rules.d/50-perm_chng.rules) -eq 1 ]; then
    echo -e "Unsuccessful chacl events set on disk config: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "Unsuccessful chacl events not set on disk config: \033[1;31mERROR\033[0m"
    echo -e "Unsuccessful chacl events not set on disk config: \033[1;31mERROR\033[0m" >> audit-error.log
fi

if [ $(auditctl -l | grep -c path=/usr/bin/chacl) -eq 1 ]; then
    echo -e "Unsuccessful chacl events set on running config: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "Unsuccessful chacl events not set on running config: \033[1;31mERROR\033[0m"
    echo -e "Unsuccessful chacl events not set on running config: \033[1;31mERROR\033[0m" >> audit-error.log
fi

# 4.1.3.18

if [ $(grep -c usermod /etc/audit/rules.d/50-usermod.rules) -eq 1 ]; then
    echo -e "Unsuccessful usermod events set on disk config: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "Unsuccessful usermod events not set on disk config: \033[1;31mERROR\033[0m"
    echo -e "Unsuccessful usermod events not set on disk config: \033[1;31mERROR\033[0m" >> audit-error.log
fi

if [ $(auditctl -l | grep -c usermod) -eq 1 ]; then
    echo -e "Unsuccessful usermod events set on running config: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "Unsuccessful usermod events not set on running config: \033[1;31mERROR\033[0m"
    echo -e "Unsuccessful usermod events not set on running config: \033[1;31mERROR\033[0m" >> audit-error.log
fi

# 4.1.3.19

if [ $(grep -c kernel_modules /etc/audit/rules.d/50-kernel_modules.rules) -eq 2 ]; then
    echo -e "Kernel module events set on disk config: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "Kernel module events not set on disk config: \033[1;31mERROR\033[0m"
    echo -e "Kernel module events not set on disk config: \033[1;31mERROR\033[0m" >> audit-error.log
fi

if [ $(auditctl -l | grep -c kernel_modules) -eq 2 ]; then
    echo -e "Kernel module events set on running config: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "Kernel module events not set on running config: \033[1;31mERROR\033[0m"
    echo -e "Kernel module events not set on running config: \033[1;31mERROR\033[0m" >> audit-error.log
fi

# 4.1.3.20

if [ "$(grep "-e 2" /etc/audit/rules.d/*.rules | tail -1 | cut -d ':' -f 2)" = "-e 2" ]; then
    echo -e "Audit configuration set to immutable: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "Audit configuration not set to immutable: \033[1;31mERROR\033[0m"
    echo -e "Audit configuration not set to immutable: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##4.2.1.1 Ensure rsyslog is installed (Automated)##
if rpm -q rsyslog &> /dev/null; then
	echo -e "rsyslog is installed: \033[1;32mOK\033[0m"
    let COUNTER++
else
	echo -e "rsyslog is not installed: \033[1;31mERROR\033[0m"
    echo -e "rsyslog is not installed: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##4.2.1.2 Ensure rsyslog service is enabled (Automated)##
if systemctl is-enabled rsyslog &> /dev/null; then
	echo -e "rsyslog service is enabled: \033[1;32mOK\033[0m"
    let COUNTER++
else
	echo -e "rsyslog service is not enabled: \033[1;31mERROR\033[0m"
    echo -e "rsyslog service is not enabled: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##4.2.1.4 Ensure rsyslog default file permissions are configured(Automated)##

if test -f /etc/rsyslog.conf; then
	
	if grep ^\$FileCreateMode /etc/rsyslog.conf &> /dev/null; then
	echo -e "rsyslog default file permissions are configured: \033[1;32mOK\033[0m"
    let COUNTER++
	else 
	echo -e "rsyslog default file permissions are not configured: \033[1;31mERROR\033[0m"
    echo -e "rsyslog default file permissions are not configured: \033[1;31mERROR\033[0m" >> audit-error.log
	fi 

else
	echo -e "rsyslog default file permissions are not configured: \033[1;31mERROR\033[0m"
    echo -e "rsyslog default file permissions are not configured: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##4.2.1.7 Ensure rsyslog is not configured to recieve logs from a remote client(Automated)##

if test -f /etc/rsyslog.conf; then
	
	if grep -q 'module(load="imtcp")' /etc/rsyslog.conf  &&
	grep -q 'input(type="imtcp" port="514")' /etc/rsyslog.conf; then

	echo -e "rsyslog is not configured to recieve logs from a remote client: \033[1;32mOK\033[0m"
    let COUNTER++
	else
	echo -e "rsyslog is configured to recieve logs from a remote client: \033[1;31mERROR\033[0m"
    echo -e "rsyslog is configured to recieve logs from a remote client: \033[1;31mERROR\033[0m" >> audit-error.log
	fi 

else
	echo -e "rsyslog is configured to recieve logs from a remote client: \033[1;31mERROR\033[0m"
    echo -e "rsyslog is configured to recieve logs from a remote client: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##5.1.2 Ensure permissions on /etc/crontab are configured
if stat /etc/crontab &> /dev/null; then
    echo -e "Permissions on /etc/crontab configured: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "Permissions on etc/crontab not configured: \033[1;31mERROR\033[0m"
	echo -e "Permissions on etc/crontab not configured: \033[1;31mERROR\033[0m" >> audit-error.log

fi

##5.1.3 Ensure permissions on /etc/cron.hourly are configure
if stat /etc/cron.hourly &> /dev/null; then
    echo -e "Permissions on /etc/cron.hourly configured: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "Permissions on /etc/cron.hourly not configured: \033[1;31mERROR\033[0m"
	echo -e "Permissions on /etc/cron.hourly not configured: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##5.1.4 Ensure permissions on /etc/cron.daily are configured
if stat /etc/cron.daily &> /dev/null; then
    echo -e "Permissions on /etc/cron.daily configured: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "Permissions on /etc/cron.daily not configured: \033[1;31mERROR\033[0m"
	echo -e "Permissions on /etc/cron.daily not configured: \033[1;31mERROR\033[0m" >> audit-error.log

fi

##5.1.5 Ensure permissions on /etc/cron.weekly are configured
if stat /etc/cron.weekly &> /dev/null; then
    echo -e "Permissions on /etc/cron.weekly configured: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "Permissions on /etc/cron.weekly not configured: \033[1;31mERROR\033[0m"
	echo -e "Permissions on /etc/cron.weekly not configured: \033[1;31mERROR\033[0m" >> audit-error.log

fi

##5.1.6 Ensure permissions on /etc/cron.monthly are configured
if stat /etc/cron.monthly &> /dev/null; then
    echo -e "Permissions on /etc/cron.monthly configured: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "Permissions on /etc/cron.monthly not configured: \033[1;31mERROR\033[0m"
	echo -e "Permissions on /etc/cron.monthly not configured: \033[1;31mERROR\033[0m" >> audit-error.log

fi

##5.1.7 Ensure permissions on /etc/cron.d are configured
if stat /etc/cron.d &> /dev/null; then
    echo -e "Permissions on /etc/cron.d configured: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "Permissions on /etc/cron.d not configured: \033[1;31mERROR\033[0m"
	echo -e "Permissions on /etc/cron.d not configured: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##5.1.8 Ensure cron is restricted to authorized users
if rpm -q cronie >/dev/null; then
    echo -e "cron still installed: \033[1;31mERROR\033[0m"
	echo -e "cron still installed: \033[1;31mERROR\033[0m" >> audit-error.log
else
    echo -e "cron not installed: \033[1;32mOK\033[0m"
    let COUNTER++

fi

##5.1.9 Ensure at is restricted to authorized users
if rpm -q at >/dev/null; then
    echo -e "at still installed: \033[1;31mERROR\033[0m"
    echo -e "at still installed: \033[1;31mERROR\033[0m" >> audit-error.log

else
    echo -e "at not installed: \033[1;32mOK\033[0m"
    let COUNTER++

fi

# 5.2.1 Ensure permissions on /etc/ssh/sshd_config are configured

if [ $(stat -c %u /etc/ssh/sshd_config) -eq 0 ]; then
    echo -e "Owned by root, checking for permissions..."

    if [ $(stat -c %a /etc/ssh/sshd_config) -eq 600 ]; then
        echo -e "Permissions set to read-only for root: \033[1;32mOK\033[0m"
    let COUNTER++
    else
        echo -e "Permissions not set to read-only for root: \033[1;31mERROR\033[0m"
		echo -e "Permissions not set to read-only for root: \033[1;31mERROR\033[0m" >> audit-error.log
    fi
else
    echo -e "File not owned by root: \033[1;31mERROR\033[0m"
	echo -e "File not owned by root: \033[1;31mERROR\033[0m" >> audit-error.log

fi

# 5.2.2 Ensure permissions on SSH private host key files are configured

ssh_priv_keys=$(find /etc/ssh -xdev -type f -name 'ssh_host_*_key')
ssh_group_id=$(getent group ssh_keys | cut -d ':' -f 3)

for file in $ssh_priv_keys
do
    if [ $(stat -c %u $file) -eq 0 ] && [ $(stat -c %g $file) -eq $ssh_group_id ] && [ $(stat -c %a $file) -eq 640 ]; then
        echo -e "$(stat -c %n $file) has root ownership & part of ssh_keys group, and has appropriate permissions: \033[1;32mOK\033[0m"
        let COUNTER++
    else
        echo -e "$(stat -c %n $file) has permissions and/or ownership/group conflict: \033[1;31mERROR\033[0m"
		echo -e "$(stat -c %n $file) has permissions and/or ownership/group conflict: \033[1;31mERROR\033[0m" >> audit-error.log
    fi
done

# 5.2.3 Ensure permissions on SSH public host key files are configured

ssh_pub_keys=$(find /etc/ssh -xdev -type f -name 'ssh_host_*_key.pub')

for file in $ssh_pub_keys
do
    if [ $(stat -c %a $file) -eq 600 ]; then
        echo -e "File permission for $(stat -c %n $file) is set to 600: \033[1;32mOK\033[0m"
        let COUNTER++
    else   
        echo -e "File permission for $(stat -c %n $file) not set to 600: \033[1;31mERROR\033[0m"
		echo -e "File permission for $(stat -c %n $file) not set to 600: \033[1;31mERROR\033[0m" >> audit-error.log
    fi
done

# 5.2.5 Ensure SSH LogLevel is appropriate

if sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep -e "loglevel VERBOSE" -e "loglevel INFO" &> /dev/null; then
    echo -e "SSH LogLevel set to appropriate: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "SSH LogLevel not set to appropriate: \033[1;31mERROR\033[0m"
	echo -e "SSH LogLevel not set to appropriate: \033[1;31mERROR\033[0m" >> audit-error.log
fi

# 5.2.6 Ensure SSH PAM is enabled

if sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep -i "usepam yes" &> /dev/null; then
    echo -e "SSH PAM is enabled: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "SSH PAM is not enabled: \033[1;31mERROR\033[0m"
	echo -e "SSH PAM is not enabled: \033[1;31mERROR\033[0m" >> audit-error.log
fi

# 5.2.7 Ensure SSH root login is disabled

if sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep "permitrootlogin no" &> /dev/null; then
    echo -e "SSH root login is enabled: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "SSH root login is not enabled: \033[1;31mERROR\033[0m"
	echo -e "SSH root login is not enabled: \033[1;31mERROR\033[0m" >> audit-error.log
fi

# 5.2.8 Ensure SSH HostbasedAuthentication is disabled

if sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep "hostbasedauthentication no" &> /dev/null; then
    echo -e "SSH HostbasedAuthentication is disabled: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "SSH HostbasedAuthentication is not disabled: \033[1;31mERROR\033[0m"
	echo -e "SSH HostbasedAuthentication is not disabled: \033[1;31mERROR\033[0m" >> audit-error.log
fi 

# 5.2.9 Ensure SSH PermitEmptyPasswords is disabled

if sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep "permitemptypasswords no" &> /dev/null; then
    echo -e "SSH PermitEmptyPasswords is disabled: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "SSH PermitEmptyPasswords is not disabled: \033[1;31mERROR\033[0m"
	echo -e "SSH PermitEmptyPasswords is not disabled: \033[1;31mERROR\033[0m" >> audit-error.log
fi

# 5.2.10 Ensure SSH PermitUserEnvironment is disabled

if sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep -i "permituserenvironment no" &> /dev/null; then
    echo -e "SSH PermitUserEnvironment is disabled: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "SSH PermitUserEnvironment is not disabled: \033[1;31mERROR\033[0m"
	echo -e "SSH PermitUserEnvironment is not disabled: \033[1;31mERROR\033[0m" >> audit-error.log
fi

# 5.2.11 Ensure SSH IgnoreRhosts is enabled

if sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep "ignorerhosts yes" &> /dev/null; then
    echo -e "SSH IgnoreRhosts is enabled: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "SSH IgnoreRhosts is not enabled: \033[1;31mERROR\033[0m"
	echo -e "SSH IgnoreRhosts is not enabled: \033[1;31mERROR\033[0m" >> audit-error.log
fi

# 5.2.12 Ensure SSH X11 forwarding is disabled

if sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep -i "x11forwarding no" &> /dev/null; then
    echo -e "SSH X11 forwarding is disabled: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "SSH X11 forwarding is not disabled: \033[1;31mERROR\033[0m"
	echo -e "SSH X11 forwarding is not disabled: \033[1;31mERROR\033[0m" >> audit-error.log
fi

# 5.2.13 Ensure SSH AllowTcpForwarding is disabled

if sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep -i "allowtcpforwarding no" &> /dev/null; then
    echo -e "SSH AllowTcpForwarding is disabled: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "SSH AllowTcpForwarding is not disabled: \033[1;31mERROR\033[0m"
	echo -e "SSH AllowTcpForwarding is not disabled: \033[1;31mERROR\033[0m" >> audit-error.log
fi

# 5.2.14 Ensure system-wide crypto policy is not over-ridden

if ! grep -i '^\s*CRYPTO_POLICY=' /etc/sysconfig/sshd; then
    echo -e "System-wide crypto policy is not over-ridden: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "System-wide crypto policy is over-ridden: \033[1;31mERROR\033[0m"
	echo -e "System-wide crypto policy is over-ridden: \033[1;31mERROR\033[0m" >> audit-error.log
fi

# 5.2.15 Ensure SSH warning banner is configured

if sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep "banner /etc/issue.net" &> /dev/null; then
    echo -e "SSH warning banner is enabled: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "SSH warning banner is not enabled: \033[1;31mERROR\033[0m"
	echo -e "SSH warning banner is not enabled: \033[1;31mERROR\033[0m" >> audit-error.log
fi

# 5.2.16 Ensure SSH MaxAuthTries is set to 4 or less

if sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep "maxauthtries [1-4]" &> /dev/null; then
    echo -e "SSH MaxAuthTries set to 4 or less: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "SSH MaxAuthTries not set to 4 or less: \033[1;31mERROR\033[0m"
	echo -e "SSH MaxAuthTries not set to 4 or less: \033[1;31mERROR\033[0m" >> audit-error.log
fi

# 5.2.17 Ensure SSH MaxStartups is configured

if sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep "maxstartups 10:30:60" &> /dev/null; then
    echo -e "SSH MaxStartups is configured: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "SSH MaxStartups is not configured: \033[1;31mERROR\033[0m"
	echo -e "SSH MaxStartups is not configured: \033[1;31mERROR\033[0m" >> audit-error.log
fi

# 5.2.18 SSH MaxSessions is set to 10 or less

if sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep "maxsessions [1-10]" &> /dev/null; then
    echo -e "SSH MaxSessions set to 10 or less: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "SSH MaxSessions not set to 10 or less: \033[1;31mERROR\033[0m"
	echo -e "SSH MaxSessions not set to 10 or less: \033[1;31mERROR\033[0m" >> audit-error.log
fi

# 5.2.19 Ensure SSH LoginGraceTime is set to one minute or less

if sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep "logingracetime [30-60]" &> /dev/null; then
    echo -e "SSH LoginGraceTime set to 1 minute or less: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "SSH LoginGraceTime not set to 1 minute or less: \033[1;31mERROR\033[0m"
	echo -e "SSH LoginGraceTime not set to 1 minute or less: \033[1;31mERROR\033[0m" >> audit-error.log
fi

# 5.2.20 Ensure SSH Idle Timeout Interval is configured

if sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep "clientaliveinterval [1-900]" &> /dev/null; then
    echo -e "SSH Idle Timeout Interval is configured: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "SSH Idle Timeout Interval is not configured: \033[1;31mERROR\033[0m"
	echo -e "SSH Idle Timeout Interval is not configured: \033[1;31mERROR\033[0m" >> audit-error.log
fi


##5.3.1 Ensure sudo is installed
if rpm -q sudo &> /dev/null; then
    echo -e "sudo installed: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "sudo not installed: \033[1;31mERROR\033[0m"
    echo -e "sudo not installed: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##5.3.2 Ensure sudo commands use pty
if grep /etc/sudoers /etc/sudoers &> /dev/null; then
    echo -e "sudo commands use pty: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "sudo commands does not use pty: \033[1;31mERROR\033[0m"
	echo -e "sudo commands does not use pty: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##5.3.3 Ensure sudo log file exists
if grep -q "Defaults logfile=/var/log/sudo.log" /etc/suduoers; then

    echo -e "sudo log file exists: \033[1;32mOK\033[0m"
    let COUNTER++

else
    echo -e "sudo log file does not exist: \033[1;31mERROR\033[0m"
    echo -e "sudo log file does not exist: \033[1;31mERROR\033[0m" >> audit-error.log

fi

##5.3.4 Ensure users must provide password for escalation
if grep -q "NOPASSWD" /etc/suduoers; then

    echo -e "NOPASSWD does exist: \033[1;31mERROR\033[0m"
    echo -e "NOPASSWD does exist: \033[1;31mERROR\033[0m" >> audit-error.log
   
else
    echo -e "NOPASSWD does not exist: \033[1;32mOK\033[0m" 
    let COUNTER++

fi

##5.3.5 Ensure re-authentication for privilege escalation is not disabled globally
if grep -q "!authenticate" /etc/suduoers; then

    echo -e "!authenticate does exist: \033[1;31mERROR\033[0m"
    echo -e "!authenticate does exist: \033[1;31mERROR\033[0m" >> audit-error.log
   
else
    echo -e "!authenticate does not exist: \033[1;32mOK\033[0m" 
    let COUNTER++

fi

##5.3.6 Ensure sudo authentication timeout is configured correctly
if grep -roP "timestamp_timeout=\K[0-9]*"  /etc/group; then
    echo -e  "authentication timeout is not configured: \033[1;31mERROR\033[0m"
    echo -e  "authentication timeout is not configured: \033[1;31mERROR\033[0m" >> audit-error.log

else
    echo -e "authentication timeout is configured: \033[1;32mOK\033[0m"
    let COUNTER++


fi 

##5.3.7 Ensure access to the su command is restricted
if grep sugroup /etc/group; then
    echo -e "empty group added: \033[1;32mOK\033[0m"
    let COUNTER++

else
    echo -e "empty group not found: \033[1;31mERROR\033[0m"
    echo -e "empty group not found: \033[1;31mERROR\033[0m" >> audit-error.log

fi

##5.4.2 Ensure authselect includes with-faillock (Automated)##

if grep pam_faillock.so /etc/pam.d/password-auth /etc/pam.d/system-auth &> /dev/null; then
	
	echo -e "Authselect includes with-faillock: \033[1;32mOK\033[0m"
    let COUNTER++

else
	echo -e "Authselect does not includes with-faillock: \033[1;31mERROR\033[0m"
	echo -e "Authselect does not includes with-faillock: \033[1;31mERROR\033[0m" >> audit-error.log

fi

	
##5.5.1 Ensure password creation requirements are configured(Automated)##

if grep -q "minlen = 14" /etc/security/pwquality.conf &&
grep -q "minclass = 4" /etc/security/pwquality.conf &&
grep -q "dcredit = -1" /etc/security/pwquality.conf &&
grep -q "ucredit = -1" /etc/security/pwquality.conf &&
grep -q "ocredit = -1" /etc/security/pwquality.conf &&
grep -q "lcredit = -1" /etc/security/pwquality.conf; then

    echo -e "Password creation requirements are configured: \033[1;32mOK\033[0m" 
    let COUNTER++

else

    echo -e "Password creation requirements are not configured: \033[1;31mERROR\033[0m" 
    echo -e "Password creation requirements are not configured: \033[1;31mERROR\033[0m" >> audit-error.log

fi


##5.5.2 Ensure lockout for failed password attempts is configured(Automated)##

if grep -qw "deny = 5" /etc/security/faillock.conf &&
grep -qw "unlock_time = 900" /etc/security/faillock.conf; then

	echo -e "Lockout for failed password attempts is configured: \033[1;32mOK\033[0m"
    let COUNTER++

else 
	echo -e "Lockout for failed password attempts is not configured: \033[1;31mERROR\033[0m"
	echo -e "Lockout for failed password attempts is not configured: \033[1;31mERROR\033[0m" >> audit-error.log
fi



##5.5.4 Ensure password hashing algorithm is SHA-512 (Automated)##

if grep -Ei -q '^\s*crypt_style\s*=\s*sha512\b' /etc/libuser.conf; then

    echo -e "Configured hashing algorithm is sha512 in /etc/libuser.conf: \033[1;32mOK\033[0m"
    let COUNTER++

else 
    echo -e "Hashing algorithm is not sha512 in /etc/libuser.conf: \033[1;31mERROR\033[0m"
    echo -e "Hashing algorithm is not sha512 in /etc/libuser.conf: \033[1;31mERROR\033[0m" >> audit-error.log

fi

if grep -Ei -q '^\s*ENCRYPT_METHOD\s+SHA512\b' /etc/login.defs; then 

    echo -e "Configured hashing algorithm is sha512 in /etc/login.defs: \033[1;32mOK\033[0m"
    let COUNTER++

else 
    echo -e "Hashing algorithm is not sha512 in /etc/login.defs: \033[1;31mERROR\033[0m"
    echo -e "Hashing algorithm is not sha512 in /etc/login.defs: \033[1;31mERROR\033[0m" >> audit-error.log
fi


##5.6.1.1 Ensure password expiration is 365 days or less (Automated)##

if grep -qw "PASS_MAX_DAYS   365" /etc/login.defs; then

    echo -e "Password expiration is set to 365 days: \033[1;32mOK\033[0m"
    let COUNTER++

else
    echo -e "Password expiration is not set to 365 days: \033[1;31mERROR\033[0m"
    echo -e "Password expiration is not set to 365 days: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##5.6.1.2 Ensure minimum days between password changes is 7 or more(Automated)##

if grep -qw "PASS_MIN_DAYS   7" /etc/login.defs; then

    echo -e "Minimum days between password changes is set to 7: \033[1;32mOK\033[0m"
    let COUNTER++

else
    echo -e "Minimum days between password changes is not set to 7: \033[1;31mERROR\033[0m"
    echo -e "Minimum days between password changes is not set to 7: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##5.6.1.3 Ensure password expiration warning days is 7 or more(Automated)##

if grep -qw "PASS_WARN_AGE   7" /etc/login.defs; then

    echo -e "Password expiration warning days is set to 7: \033[1;32mOK\033[0m"
    let COUNTER++

else
    echo -e "Password expiration warning days is not set to 7: \033[1;31mERROR\033[0m"
    echo -e "Password expiration warning days is not set to 7: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##5.6.1.4 Ensure inactive password lock is 30 days or less (Automated)##

if useradd -D | grep -qw "INACTIVE=30"; then

    echo -e "Inactive password lock is set to 30 days: \033[1;32mOK\033[0m"
    let COUNTER++

else
    echo -e "Inactive password lock is not set to 30 days: \033[1;31mERROR\033[0m"
    echo -e "Inactive password lock is not set to 30 days: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##5.6.1.5 Ensure all users last password change date is in the past(Automated)##
if awk -F: '/^[^:]+:[^!*]/{print $1}' /etc/shadow | while read -r usr; \
do change=$(date -d "$(chage --list $usr | grep '^Last password change' | cut -d: -f2 | grep -v 'never$')" +%s); \
if [[ "$change" -gt "$(date +%s)" ]]; then \
echo "User: \"$usr\" last password change was \"$(chage --list $usr | grep
'^Last password change' | cut -d: -f2)\""; fi; done;then

    echo -e "All users last password change date is in the past: \033[1;32mOK\033[0m"
    let COUNTER++

else
    echo -e "Some users last password change date is in the future: \033[1;31mERROR\033[0m"
    echo -e "Some users last password change date is in the future: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##5.6.3 Ensure default user shell timeout is 900 seconds or less(Automated)##

if grep -q "TMOUT=900" /etc/profile &&
grep -q "readonly TMOUT" /etc/profile &&
grep -q "export TMOUT" /etc/profile; then

    echo -e "Default user shell timeout is set to 900 seconds in /etc/profile: \033[1;32mOK\033[0m"
    let COUNTER++

else
    echo -e "Default user shell timeout is not set to 900 seconds in /etc/profile: \033[1;31mERROR\033[0m"
    echo -e "Default user shell timeout is not set to 900 seconds in /etc/profile: \033[1;31mERROR\033[0m" >> audit-error.log

fi

if grep -q "TMOUT=900" /etc/bashrc && grep -q "readonly TMOUT" /etc/bashrc && grep -q "export TMOUT" /etc/bashrc; then
    echo -e "Default user shell timeout is set to 900 seconds in /etc/bashrc: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "Default user shell timeout is not set to 900 seconds in /etc/bashrc: \033[1;31mERROR\033[0m"
    echo -e "Default user shell timeout is not set to 900 seconds in /etc/bashrc: \033[1;31mERROR\033[0m" >> audit-error.log

fi

##5.6.4 Ensure default group for the root account is GID 0 (Automated)##

if grep -q "^root:" /etc/passwd | cut -f4 -d: ;then

    echo -e "Default group for the root account is GID 0: \033[1;32mOK\033[0m"
    let COUNTER++

else 
    echo -e "Default group for the root account is not GID 0: \033[1;31mERROR\033[0m"
    echo -e "Default group for the root account is not GID 0: \033[1;31mERROR\033[0m" >> audit-error.log
fi


##5.6.5 Ensure default user umask is 027 or more restrictive (Automated)##


if test -f /etc/profile.d/set_umask.sh; then

	if grep -q "umask 027" /etc/profile.d/set_umask.sh; then

    echo -e "Default user mask is 027: \033[1;32mOK\033[0m"
    let COUNTER++

    else
        echo -e "Default user mask is not 027: \033[1;31mERROR\033[0m"
        echo -e "Default user mask is not 027: \033[1;31mERROR\033[0m" >> audit-error.log
	fi
else
    echo -e "Default user mask is not 027: \033[1;31mERROR\033[0m"
    echo -e "Default user mask is not 027: \033[1;31mERROR\033[0m" >> audit-error.log

fi

##6.1

##6.1.1 Audit system file permissions (Manual)

##6.1.2 Ensure sticky bit is set on all world-writable directories 
if  df --local -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' find '{}' -xdev -type d \( -perm -0002 -a ! -perm -1000 \) 2>/dev/null &> /dev/null; then
    echo -e "Sticky bit is set: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "Sticky bit is not set: \033[1;31mERROR\033[0m"
    echo -e "Sticky bit is not set: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##6.1.3 Ensure permissions on /etc/passwd are configured 
if stat /etc/passwd &> /dev/null; then
    echo -e "Permissions on /etc/passwd configured: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "Permissions on /etc/passwd not configured: \033[1;31mERROR\033[0m"
    echo -e "Permissions on /etc/passwd not configured: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##6.1.4 Ensure permissions on /etc/shadow are configured
if stat /etc/shadow &> /dev/null; then
    echo -e "Permissions on /etc/shadow configured: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "Permissions on /etc/shadow not configured: \033[1;31mERROR\033[0m"
    echo -e "Permissions on /etc/shadow not configured: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##6.1.5 Ensure permissions on /etc/group are configured
if stat /etc/group &> /dev/null; then
    echo -e "Permissions on /etc/group configured: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "Permissions on /etc/group not configured: \033[1;31mERROR\033[0m"
    echo -e "Permissions on /etc/group not configured: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##6.1.6 Ensure permissions on /etc/gshadow are configured
if stat /etc/gshadow &> /dev/null; then
    echo -e "Permissions on /etc/gshadow configured: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "Permissions on /etc/gshadow not configured: \033[1;31mERROR\033[0m"
    echo -e "Permissions on /etc/gshadow not configured: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##6.1.7 Ensure permissions on /etc/passwd- are configured
if stat /etc/passwd- &> /dev/null; then
    echo -e "Permissions on /etc/passwd- configured: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "Permissions on /etc/passwd- not configured: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##6.1.8 Ensure permissions on /etc/shadow- are configured
if stat /etc/shadow- &> /dev/null; then
    echo -e "Permissions on /etc/shadow- configured: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "Permissions on /etc/shadow- not configured: \033[1;31mERROR\033[0m"
    echo -e "Permissions on /etc/shadow- not configured: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##6.1.9 Ensure permissions on /etc/group- are configured
if stat /etc/group- &> /dev/null; then
    echo -e "Permissions on /etc/group- configured: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "Permissions on /etc/group- not configured: \033[1;31mERROR\033[0m"
    echo -e "Permissions on /etc/group- not configured: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##6.1.10 Ensure permissions on /etc/gshadow- are configured 
if stat /etc/gshadow- &> /dev/null; then
    echo -e "Permissions on /etc/gshadow-- configured: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "Permissions on /etc/gshadow- not configured: \033[1;31mERROR\033[0m"
    echo -e "Permissions on /etc/gshadow- not configured: \033[1;31mERROR\033[0m" >> audit-error.log
fi


# 6.2.1 Ensure password fields are not empty
if [ $(awk -F: '($2 == "" ) { print $1 " does not have a password " }'  /etc/shadow | wc -l) -eq 0 ]; then
    echo -e "Password fields are not empty: \033[1;32mOK\033[0m"
else
    echo -e "Some password fields are empty: \033[1;31mERROR\033[0m"
    echo -e "Some password fields are empty: \033[1;31mERROR\033[0m" >> audit-error.log
fi

# 6.2.2 Ensure all groups in /etc/passwd exist in /etc/group

group_counter=0

for i in $(cut -s -d: -f4 /etc/passwd | sort -u ); do 
    grep -q -P "^.*?:[^:]*:$i:" /etc/group 
    
    if [ $? -ne 0 ]; then 
        echo -e "Group $i is referenced by /etc/passwd but does not exist in /etc/group: \033[1;31mERROR\033[0m"
        echo -e "Group $i is referenced by /etc/passwd but does not exist in /etc/group: \033[1;31mERROR\033[0m" >> audit-error.log
        let group_counter++
    fi
done

if [ $group_counter -eq 0 ]; then
    echo -e "All groups in /etc/passwd exists in /etc/group: \033[1;32mOK\033[0m"
fi

# 6.2.3 Ensure no duplicate UIDs exist

uid_counter=0

cut -f3 -d ":" /etc/passwd | sort -n | uniq -c | while read x ; do 
    [ -z "$x" ] && break 
    set - $x 
    if [ $1 -gt 1 ]; then 
        users=$(awk -F: '($3 == n) { print $1 }' n=$2 /etc/passwd | xargs) 
        echo -e "Duplicate UID ($2) $users: \033[1;31mERROR\033[0m"
        echo -e "Duplicate UID ($2) $users: \033[1;31mERROR\033[0m" >> audit-error.log
        let uid_counter++
    fi 
done

if [ $uid_counter -eq 0 ]; then
    echo -e "No UID duplicates: \033[1;32mOK\033[0m"
fi

# 6.2.4 Ensure no duplicate GIDs exist

gid_counter=0

cut -d: -f3 /etc/group | sort | uniq -d | while read x ; do 
    echo -e "Duplicate GID ($x) in /etc/group: \033[1;31mERROR\033[0m"
    echo -e "Duplicate GID ($x) in /etc/group: \033[1;31mERROR\033[0m" >> audit-error.log
    let gid_counter++
done

if [ $gid_counter -eq 0 ]; then
    echo -e "No duplicate GIDs found: \033[1;32mOK\033[0m"
fi

# 6.2.5 Ensure no duplicate user names exist

user_counter=0

cut -d: -f1 /etc/passwd | sort | uniq -d | while read x; do 
    echo -e "Duplicate login name ${x} in /etc/passwd: \033[1;31mERROR\033[0m"
    echo -e "Duplicate login name ${x} in /etc/passwd: \033[1;31mERROR\033[0m" >> audit-error.log
    let user_counter++
done

if [ $user_counter -eq 0 ]; then
    echo -e "No duplicate user names found: \033[1;32mOK\033[0m"
fi

# 6.2.6 Ensure no duplicate group names exist

group_name_counter=0

cut -d: -f1 /etc/group | sort | uniq -d | while read -r x; do 
    echo -e "Duplicate group name ${x} in /etc/group: \033[1;31mERROR\033[0m"
    echo -e "Duplicate group name ${x} in /etc/group: \033[1;31mERROR\033[0m" >> audit-error.log
    let group_name_counter++
done

if [ $group_name_counter -eq 0 ]; then
    echo -e "No duplicate group names found: \033[1;32mOK\033[0m"
fi

if [ $(awk -F: '($3 == 0) { print $1 }' /etc/passwd | wc -l) -eq 1 ] && [ $(awk -F: '($3 == 0) { print $1 }' /etc/passwd | grep -c root) -eq 1 ]; then
    echo -e "Root is only user with UID of 0: \033[1;32mOK\033[0m"
else
    echo -e "Root not only user with UID of 0: \033[1;31mERROR\033[0m"
fi

##6.2.9 Ensure all users' home directories exist (Automated)##

if
awk -F: '($1!~/(halt|sync|shutdown|nfsnobody)/ &&
$7!~/^(\/usr)?\/sbin\/nologin(\/)?$/ && $7!~/(\/usr)?\/bin\/false(\/)?$/) {
print $1 " " $6 }' /etc/passwd | while read -r user dir; do
 if [ ! -d "$dir" ]; then
 echo "User: \"$user\" home directory: \"$dir\" does not exist."
 fi
done; then

echo -e "All users' home directories exist: \033[1;32mOK\033[0m"
let COUNTER++
else 

echo -e "Users home directories does not exist: \033[1;31mERROR\033[0m"
echo -e "Users home directories does not exist: \033[1;31mERROR\033[0m" >> audit-error.log

fi

##6.2.10 Ensure users own their home directories(Automated)##

if
awk -F: '($1!~/(halt|sync|shutdown|nfsnobody)/ &&
$7!~/^(\/usr)?\/sbin\/nologin(\/)?$/ && $7!~/(\/usr)?\/bin\/false(\/)?$/) {
print $1 " " $6 }' /etc/passwd | while read -r user dir; do
 if [ ! -d "$dir" ]; then
 echo "User: \"$user\" home directory: \"$dir\" does not exist, creating
home directory"
 mkdir "$dir"
 chmod g-w,o-rwx "$dir"
 chown "$user" "$dir"
 else
 owner=$(stat -L -c "%U" "$dir")
 if [ "$owner" != "$user" ]; then
 chmod g-w,o-rwx "$dir"
 chown "$user" "$dir"
 fi
 fi
done; then 

echo -e "Users own their home directories: \033[1;32mOK\033[0m"
let COUNTER++
else

echo -e "Users own their home directories are not configured: \033[1;31mERROR\033[0m"
echo -e "Users own their home directories are not configured: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##6.2.13 Ensure users .netrc Files are not group or world accessible(Automated)##

if
awk -F: '($1!~/(halt|sync|shutdown|nfsnobody)/ && $7!~/^(\/usr)?\/sbin\/nologin(\/)?$/ && $7!~/(\/usr)?\/bin\/false(\/)?$/) {print $1 " " $6 }' /etc/passwd | while read -r user dir; do
 if [ -d "$dir" ]; then
 file="$dir/.netrc"
 if [ ! -h "$file" ] && [ -f "$file" ]; then
 if stat -L -c "%A" "$file" | cut -c4-10 | grep -Eq '[^-]+'; then
 echo "FAILED: User: \"$user\" file: \"$file\" exists with permissions: \"$(stat -L -c "%a" "$file")\", remove file or excessive permissions"
 else
 echo "WARNING: User: \"$user\" file: \"$file\" exists with permissions: \"$(stat -L -c "%a" "$file")\", remove file unless required"
 fi
 fi
 fi
done; then 

echo -e "Users .netrc Files are not group or world accessible: \033[1;32mOK\033[0m"
let COUNTER++
else

echo -e "Users .netrc Files are group or world accessible: \033[1;31mERROR\033[0m"
echo -e "Users .netrc Files are group or world accessible: \033[1;31mERROR\033[0m" >> audit-error.log

fi

##6.2.14 Ensure no users have .forward files (Automated)##

if
awk -F: '($1!~/(halt|sync|shutdown|nfsnobody)/ &&
$7!~/^(\/usr)?\/sbin\/nologin(\/)?$/ && $7!~/(\/usr)?\/bin\/false(\/)?$/) {
print $1 " " $6 }' /etc/passwd | while read -r user dir; do
 if [ -d "$dir" ]; then
 file="$dir/.forward"
 if [ ! -h "$file" ] && [ -f "$file" ]; then
 echo "User: \"$user\" file: \"$file\" exists"
 fi
 fi
done; then

echo -e "No users have .forward files: \033[1;32mOK\033[0m "
let COUNTER++
else

echo -e "Some users have .forward files: \033[1;31mERROR\033[0m"
echo -e "Some users have .forward files: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##6.2.15 Ensure no users have .netrc files (Automated)##

if
awk -F: '($1!~/(halt|sync|shutdown|nfsnobody)/ &&
$7!~/^(\/usr)?\/sbin\/nologin(\/)?$/ && $7!~/(\/usr)?\/bin\/false(\/)?$/) {
print $1 " " $6 }' /etc/passwd | while read -r user dir; do
 if [ -d "$dir" ]; then
 file="$dir/.netrc"
 if [ ! -h "$file" ] && [ -f "$file" ]; then
 echo "User: \"$user\" file: \"$file\" exists"
 fi
 fi
done; then

echo -e "No users have .netrc files: \033[1;32mOK\033[0m "
let COUNTER++
else

echo -e "Some users have .netrc files: \033[1;31mERROR\033[0m"
echo -e "Some users have .netrc files: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##6.2.16 Ensure no users have .rhosts files (Automated)##

if
awk -F: '($1!~/(halt|sync|shutdown|nfsnobody)/ &&
$7!~/^(\/usr)?\/sbin\/nologin(\/)?$/ && $7!~/(\/usr)?\/bin\/false(\/)?$/) {
print $1 " " $6 }' /etc/passwd | while read -r user dir; do
 if [ -d "$dir" ]; then
 file="$dir/.rhosts"
 if [ ! -h "$file" ] && [ -f "$file" ]; then
 echo "User: \"$user\" file: \"$file\" exists"
 fi
 fi
done; then

echo -e "No users have .rhosts files: \033[1;32mOK\033[0m "
let COUNTER++
else

echo -e "Some users have .rhosts files: \033[1;31mERROR\033[0m"
echo -e "Some users have .rhosts files: \033[1;31mERROR\033[0m" >> audit-error.log
fi


printf "Finished auditing with score: $COUNTER/219 \n"
