#!/bin/bash
##Auditing##

##1.2.3 Ensure gpgcheck is globally activated (Automated)##
if grep ^gpgcheck /etc/dnf/dnf.conf &> /dev/null; then
echo -e "gpgcheck=1: \033[1;32mOK\033[0m"
else
	echo -e "gpgcheck!=1: \033[1;31mERROR\033[0m"
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

	else
	echo -e "GDM Profile needs to be configured: \033[1;31mERROR\033[0m"
	fi
else 

echo -e "GDM Profile needs to be configured: \033[1;31mERROR\033[0m"

fi

if test -f /etc/dconf/db/gdm.d/01-banner-message; then

	if grep -q "[org/gnome/login-screen]" /etc/dconf/db/gdm.d/01-banner-message &&
	grep -q "banner-message-enable=true" /etc/dconf/db/gdm.d/01-banner-message &&
	grep -q "banner-message-text='<banner message>" /etc/dconf/db/gdm.d/01-banner-message; then

	echo -e "Banner message is set: \033[1;32mOK\033[0m"

	else
	echo -e "Banner message needs to be configured: \033[1;31mERROR\033[0m"
	fi
else 

echo -e "Banner message needs to be configured: \033[1;31mERROR\033[0m"

fi 

##1.8.3 Ensure last logged in user display is disabled (Automated)##
if test -f /etc/dconf/db/gdm.d/00-login-screen; then

	if grep -q "[org/gnome/login-screen]" /etc/dconf/db/gdm.d/00-login-screen &&
	grep -q "disable-user-list=true" /etc/dconf/db/gdm.d/00-login-screen; then

	echo -e "Last Logged Display is set: \033[1;32mOK\033[0m"

	else
	echo -e "Last Logged Display needs to be configured: \033[1;31mERROR\033[0m"
	fi
else

echo -e "Last Logged Display needs to be configured: \033[1;31mERROR\033[0m"
fi
fi

##1.10 Ensure system-wide crypto policy is not legacy (Automated)##
if ! grep -E -i '^\s*LEGACY\s*(\s+#.*)?$' /etc/crypto-policies/config &> /dev/null; then
echo -e "System-wide crypto policy: \033[1;32mOK\033[0m"
else
	echo -e "System-wide crypto policy not set to default: \033[1;31mERROR\033[0m"
fi

##AUDIT##

##1.3 Filesystem Integrity Checking##
##1.3.1 Ensure AIDE is installed##

if  rpm -q aide &> /dev/null; then
	rpm -q aide
	echo -e "AIDE is already installed: \033[1;32mOK\033[0m"

else
	echo -e "AIDE needs to be installed: \033[1;31mERROR\033[0m"
fi


##1.3.2 Ensure filesystem integrity is regularly checked##

if  grep -Ers '^([^#]+\s+)?(\/usr\/s?bin\/|^\s*)aide(\.wrapper)?\s(--?\S+\s)*(--(check|update)|\$AIDEARGS)\b' /etc/cron.* /etc/crontab /var/spool/cron/ &> /dev/null; then
	echo -e "Check: \033[1;32mOK\033[0m"
else
	echo -e "Check: \033[1;31mERROR\033[0m"
fi

if grep "set superusers" /boot/grub2/grub.cfg &> /dev/null; then
    echo -e "Superuser is set: \033[1;32mOK\033[0m"
else
    echo -e "Superuser is not set! \033[1;31mERROR\033[0m"
fi

if grep "password" /boot/grub2/grub.cfg &> /dev/null; then 
    echo -e "Grub2 password is set: \033[1;32mOK\033[0m"
else
    echo -e "Grub2 password not set! \033[1;31mERROR\033[0m"
fi

if grep -r /systemd-sulogin-shell &> /dev/null || grep -r /usr/lib/systemd/system/rescue.service &> /dev/null || grep -r /etc/systemd/system/rescue.service.d &> /dev/null; then
    echo -e "Authentication in rescue mode set: \033[1;32mOK\033[0m"
else
    echo "Authentication in rescue mode not set!"
fi

if grep -i '^\s*storage\s*=\s*none' /etc/systemd/coredump.conf &> /dev/null; then
    echo -e "Coredump storage equal to none: \033[1;32mOK\033[0m"
else
    echo "Coredump not set to none!"
fi

if grep -i '^\s*ProcessSizeMax\s*=\s*0' /etc/systemd/coredump.conf &> /dev/null; then
    echo -e "Coredump ProcessSizeMax equal to 0: \033[1;32mOK\033[0m"
else
    echo "Coredump ProcessSizeMax not equal to 0!"
fi

if sysctl kernel.randomize_va_space -eq 2 &> /dev/null; then
    echo -e "Kernerl randomize va space set to 2: \033[1;32mOK\033[0m"
else
    echo "Kernel randomize va space not set to 2!"
fi

if rpm -q libselinux &> /dev/null; then
    echo -e "Libselinux is installed: \033[1;32mOK\033[0m"
else
    echo "Libselinux not installed!"
fi

if ! grep "^\s*linux" /boot/grub2/grub.cfg &> /dev/null; then
    echo -e "SELinux is enabled at boot time: \033[1;32mOK\033[0m"
else   
    echo "SELinux not enabled at boot time!"
fi

if grep SELINUXTYPE=targeted /etc/selinux/config &> /dev/null; then
    echo -e "SELINUXTYPE set to targeted: \033[1;32mOK\033[0m"
else
    echo "SELINUXTYPE not set to targeted!"
fi

if grep SELINUX=enforcing /etc/selinux/config &> /dev/null; then
    echo -e "SELINUX set to enforcing: \033[1;32mOK\033[0m"
else   
    echo "SELINUX not set to enforcing!"
fi

if ! ps -eZ | grep unconfined_service_t &> /dev/null; then
    echo -e "unconfined_service_t not running: \033[1;32mOK\033[0m"
else
    echo "unconfined_service_t is running!"
fi

if ! rpm -q setroubleshoot &> /dev/null; then
    echo -e "setroubleshoot not installed: \033[1;32mOK\033[0m"
else
    echo "setroubleshoot is installed!"
fi

if ! rpm -q mcstrans &> /dev/null; then
    echo -e "mcstrans not installed: \033[1;32mOK\033[0m"
else
    echo "mcstrans is installed!"
fi

##AUDIT##

##1.7 Command Line Warning Banners##
##1.7.1 Ensure message of the day is configured properly##

if  cat /etc/motd &> /dev/null; then
	cat /etc/motd
	echo -e "MOTD removed: \033[1;32mOK\033[0m" 

else
	echo -e "MOTD needs to be removed:\033[1;31mERROR\033[0m"

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
