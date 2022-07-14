#!/bin/bash

cat << "EOF"
=====================================================================
  _____       _                     _____           _       _   
 |_   _|     | |                   / ____|         (_)     | |  
   | |  _ __ | |_ ___ _ __ _ __   | (___   ___ _ __ _ _ __ | |_ 
   | | | '_ \| __/ _ \ '__| '_ \   \___ \ / __| '__| | '_ \| __|
  _| |_| | | | ||  __/ |  | | | |  ____) | (__| |  | | |_) | |_ 
 |_____|_| |_|\__\___|_|  |_| |_| |_____/ \___|_|  |_| .__/ \__|
                                                     | |        
                                                     |_|  
	         
		By: Benlot,  Tampoy, and Vero										
=====================================================================													 
EOF

echo -e "Pick out your preferred firewall from the list below: \n"

PS3="Enter your preferred firewall: "
options=("firewalld" "nftables" "iptables" "quit")

select opt in "${options[@]}"
do
	case $opt in
		"firewalld")
			echo -e "\nRunning script with firewalld..."
			firewall_value=1
			break
			;;
		"nftables")
			echo -e "\nRunning script with nftables..."
			firewall_value=2
			break
			;;
		"iptables")
			echo -e "\nRunning script with iptables..."
			firewall_value=3
			break
			;;
		"quit")
			echo -e "\nQuitting program..."
			exit
			;;
		*) echo "Invalid option $REPLY";;
	esac 
done
		

##1.2.3 Ensure gpgcheck is globally activated (Automated)##
sed -i 's/^gpgcheck\s*=\s*.*/gpgcheck=1/' /etc/dnf/dnf.conf


##1.3Filesystem Integrity Checking##

##1.3.1 Ensure AIDE is installed##
if  rpm -qa | grep -q "aide"; then
	echo "AIDE already installed"
else
	echo "AIDE not installed, installing.."
	dnf -y install aide
fi

##To initialize AIDE##
echo "Initializing AIDE..."
aide --init

echo "Removing new AIDE to ensure AIDE is working..."
mv /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz

##1.3.2 Ensure filesystem integrity is regularly checked##
crontab -u root -l > mycron
echo "0 5 * * * /usr/sbin/aide --check" >> mycron
crontab -u root mycron
rm mycron

##The checking in this recommendation occurs every day at 5am.##

# Set grub2-password

nohup bash dependencies_script/grub2-setpw.sh >/dev/null 2>&1
echo "Grub2 password set"

# Update the grub2 configuration

grub2-mkconfig -o "$(dirname "$(find /boot -type f \( -name 'grubenv' -o -name 'grub.conf' -o -name 'grub.cfg' \) -exec grep -Pl '^\h*(kernelopts=|linux|kernel)' {} \;)")/grub.cfg"

# Ensure permissions on bootloader config are configured

echo "Setting ownership and permissions for grub.cfg..."

[ -f /boot/grub2/grub.cfg ] && chown root:root /boot/grub2/grub.cfg
[ -f /boot/grub2/grub.cfg ] && chmod og-rwx /boot/grub2/grub.cfg

echo "Setting ownership and permissions for grubenv..."

[ -f /boot/grub2/grubenv ] && chown root:root /boot/grub2/grubenv
[ -f /boot/grub2/grubenv ] && chmod og-rwx /boot/grub2/grubenv

echo "Setting ownership and permissions for user.cfg..."

[ -f /boot/grub2/user.cfg ] && chown root:root /boot/grub2/user.cfg
[ -f /boot/grub2/user.cfg ] && chmod og-rwx /boot/grub2/user.cfg

# Ensure authentication is required when booting into rescue mode

if grep -q /systemd-sulogin-shell /usr/lib/systemd/system/rescue.service; then
	echo "Login authentication when rescue mode is set, continuing..."
fi


# Edits the coredump.conf to none to ensure core dumps is disabled

sed -i 's/#Storage=external/Storage=none/g' /etc/systemd/coredump.conf

# Edits the coredump.conf ProcessSize to 0 to ensure backtraces are disabled

sed -i 's/#ProcessSizeMax=2G/ProcessSizeMax=0/g' /etc/systemd/coredump.conf

# Sets kernel.randomize_va_space to 2

sysctl -w kernel.randomize_va_space=2 

# Install SELinux

if rpm -qa | grep -q "libselinux"; then
	echo "Libselinux installed, continuing..."
else
	echo "Installing libselinux..."
	dnf install libselinux
fi

# Ensure SELinux is not disabled in bootloader configuration

echo "Updating SELinux to ensure its not disabled in bootloader config..."
grubby --update-kernel ALL --remove-args 'selinux=0 enforcing=0'

# Check if SELINUXTYPE=targeted, if not set it to targeted

if grep -q "SELINUXTYPE=targeted" /etc/selinux/config; then
	echo "SELINUXTYPE set to targeted, continuing..."
else
	sed 's/SELINUXTYPE/SELINUXTYPE=targeted/g' /etc/selinux/config
fi

# Set SELinux mode to Enforcing

echo "Setting enforce mode to 1"
setenforce 1

# Edit SELinux parameter to Enforcing

if grep -q "SELINUX=enforcing" /etc/selinux/config; then
	echo "SELinux set to enforcing, continuing..."
else
	sed 's/SELINUX/SELINUX=enforcing/g' /etc/selinux/config
fi

# Remove setroubleshoot if installed

if rpm -qa | grep setroubleshoot; then
	echo "Setroubleshoot package found, removing..."
	dnf remove "setroubleshoot*"
else
	echo "Setroubleshoot package not found, continuing..."
fi

# Remove mcstrans if installed

if rpm -qa | grep mcstrans; then
	echo "Mcstrans package found, removing..."
	dnf remove "mcstrans*"
else
	echo "Mcstrans package not found, continuing..."
fi

##1.7 Command Line Warning Banners##

##1.7.1 Ensure message of the day is configured properly##
if test -f /etc/motd/; then
        echo "MOTD exists on your filesystem, removing..."
	rm /etc/motd
else
    	echo "MOTD not found, continuing..."
fi

##1.7.2 Ensure local login warning banner is configured properly##
echo "Authorized uses only. All activity may be monitored and reported." > /etc/issue

##1.7.3 Ensure remote login warning banner is configured properly##
echo "Authorized uses only. All activity may be monitored and reported." > /etc/issue.net

##1.7.4 Ensure permissions on /etc/motd are configured##

##1.7.5 Ensure permissions on /etc/issue are configured##
chown root:root /etc/issue
chmod u-x,go-wx /etc/issue

##1.7.6 Ensure permissions on /etc/issue.net are configured##
chown root:root /etc/issue.net
chmod u-x,go-wx /etc/issue.net

##For 1.8##

#To check if there's a GUI in Linux
if ls /usr/bin/*session | grep -q "/usr/bin/gnome-session" ; then

##1.8.2 Ensure GDM login banner is configured (Automated)##
if test -f /etc/dconf/profile/gdm; then

	if grep -q "user-db:user" /etc/dconf/profile/gdm &&
	grep -q "system-db:gdm" /etc/dconf/profile/gdm &&
	grep -q "file-db:/usr/share/gdm/greeter-dconf-defaults" /etc/dconf/profile/gdm; then 

	echo "GDM Profile is set.. Continuing..."

	else
	echo -e "user-db:user\nsystem-db:gdm\nfile-db:/usr/share/gdm/greeter-dconf-defaults" > /etc/dconf/profile/gdm
	fi
else 

touch /etc/dconf/profile/gdm
echo -e "user-db:user\nsystem-db:gdm\nfile-db:/usr/share/gdm/greeter-dconf-defaults" > /etc/dconf/profile/gdm

fi

if test -f /etc/dconf/db/gdm.d/01-banner-message; then

	if grep -q "[org/gnome/login-screen]" /etc/dconf/db/gdm.d/01-banner-message &&
	grep -q "banner-message-enable=true" /etc/dconf/db/gdm.d/01-banner-message &&
	grep -q "banner-message-text='<banner message>" /etc/dconf/db/gdm.d/01-banner-message; then

	echo "Banner message is set.. Continuing..."

	else
	echo -e "[org/gnome/login-screen]\nbanner-message-enable=true\nbanner-message-text='<banner message>'" > /etc/dconf/db/gdm.d/01-banner-message
	fi
else 

touch /etc/dconf/db/gdm.d/01-banner-message
echo -e "[org/gnome/login-screen]/nbanner-message-enable=true/nbanner-message-text='<banner message>'" > /etc/dconf/db/gdm.d/01-banner-message

dconf update

fi 

##1.8.3 Ensure last logged in user display is disabled (Automated)##
if test -f /etc/dconf/db/gdm.d/00-login-screen; then

	if grep -q "[org/gnome/login-screen]" /etc/dconf/db/gdm.d/00-login-screen &&
	grep -q "disable-user-list=true" /etc/dconf/db/gdm.d/00-login-screen; then

	echo "Last logged display is set.. Continuing..."

	else
	echo -e "[org/gnome/login-screen]\ndisable-user-list=true" > /etc/dconf/db/gdm.d/00-login-screen
	fi
else

touch /etc/dconf/db/gdm.d/00-login-screen
echo -e "[org/gnome/login-screen]\ndisable-user-list=true" > /etc/dconf/db/gdm.d/00-login-screen

dconf update

fi

else

echo "The server has no GUI... Continuing"

fi

##1.10 Ensure system-wide crypto policy is not legacy (Automated)#
update-crypto-policies --set DEFAULT
update-crypto-policies

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

##3.1.2 Ensure SCTP is disabled (Automated)##
if test -f /etc/modprobe.d/sctp.conf; then 

	if grep -q "install sctp /bin/true" /etc/modprobe.d/sctp.conf; then
	
	echo "SCTP is disabled... Continuing..."

	else 
	printf "
	install sctp /bin/true
	" >> /etc/modprobe.d/sctp.conf
	fi

else 
touch /etc/modprobe.d/sctp.conf
printf "
	install sctp /bin/true
	" >> /etc/modprobe.d/sctp.conf
fi

##3.1.3 Ensure DCCP is disabled (Automated)##
if test -f /etc/modprobe.d/dccp.conf; then 

	if grep -q "install dccp /bin/true" /etc/modprobe.d/dccp.conf; then
	
	echo "DCCP is disabled... Continuing..."

	else 
	printf "
	install dccp /bin/true
	" >> /etc/modprobe.d/dccp.conf
	fi

else 
touch /etc/modprobe.d/dccp.conf
printf "
	install dccp /bin/true
	" >> /etc/modprobe.d/dccp.conf
fi

##3.1.4 Ensure wireless interfaces are disabled (Automated)##
#!/usr/bin/env bash
{
 if command -v nmcli >/dev/null 2>&1 ; then
 nmcli radio all off
 echo "Disabled wireless interface.. Continuing... "
 else
 if [ -n "$(find /sys/class/net/*/ -type d -name wireless)" ]; then
 mname=$(for driverdir in $(find /sys/class/net/*/ -type d -name
wireless | xargs -0 dirname); do basename "$(readlink -f
"$driverdir"/device/driver/module)";done | sort -u)
 for dm in $mname; do echo "install $dm /bin/true" >> /etc/modprobe.d/disable_wireless.conf
 done
 fi
 echo "Disabled wireless interface.. Continuing... "
 fi
}

##3.2
if cat /etc/sysctl.d/60-netipv4_sysctl.conf | grep "net.ipv4.ip_forward = 0" &> /dev/null; then
    echo "IPv4 forwarding is disabled, checking in sysctl..."

    if sysctl net.ipv4.ip_forward | grep "net.ipv4.ip_forward = 0" &> /dev/null; then
        echo "Kernel parameter for ip forwarding set to 0, continuing..."
    else
        echo "Setting kernel parameter of ipv4 forwarding to 0..."
        sysctl -w net.ipv4.ip_forward=0 &> /dev/null
    fi

     if sysctl net.ipv4.route.flush | grep "net.ipv4.route.flush = 1" &> /dev/null; then
        echo "Kernel parameter for route flush set to 1, continuing..."
    else
        echo "Setting kernel parameter of route flush to 1..."
        sysctl -w net.ipv4.route.flush=1 &> /dev/null
    fi
else
    echo "IPv4 forwarding might be enabled, adding in parameter to conf file..."
    echo "net.ipv4.ip_forward = 0" >> /etc/sysctl.d/60-netipv4_sysctl.conf

    echo "IPv4 forwarding set, checking in sysctl..."

    if sysctl net.ipv4.ip_forward | grep "net.ipv4.ip_forward = 0" &> /dev/null; then
        echo "Kernel parameter for ip forwarding set to 0, continuing..."
    else
        echo "Setting kernel parameter of ipv4 forwarding to 0..."
        sysctl -w net.ipv4.ip_forward=0 &> /dev/null
    fi

     if sysctl net.ipv4.route.flush | grep "net.ipv4.route.flush = 1" &> /dev/null; then
        echo "Kernel parameter for route flush set to 1, continuing..."
    else
        echo "Setting kernel parameter of route flush to 1..."
        sysctl -w net.ipv4.route.flush=1 &> /dev/null
    fi
fi

# IF IPv6 is enabled, uncomment this

# if cat /etc/sysctl.d/60-netipv6_sysctl.conf | grep "net.ipv6.conf.all.forwarding = 0" &> /dev/null; then
#     echo "IPv4 forwarding is disabled, checking in sysctl..."

#     if sysctl net.ipv6.conf.all.forwarding | grep "net.ipv6.conf.all.forwarding = 0" &> /dev/null; then
#         echo "Kernel parameter for ipv6 forwarding set to 0, continuing..."
#     else
#         echo "Setting kernel parameter of ipv6 forwarding to 0..."
#         sysctl -w net.ipv6.conf.all.forwarding=0 &> /dev/null
#     fi

#      if sysctl net.ipv6.route.flush | grep "net.ipv6.route.flush = 1" &> /dev/null; then
#         echo "Kernel parameter for route flush set to 1, continuing..."
#     else
#         echo "Setting kernel parameter of route flush to 1..."
#         sysctl -w net.ipv6.route.flush=1 &> /dev/null
#     fi
# else
#     echo "IPv6 forwarding might be enabled, adding in parameter to conf file..."
#     echo "net.ipv6.conf.all.forwarding" >> /etc/sysctl.d/60-netipv4_sysctl.conf

#     echo "IPv6 forwarding set, checking in sysctl..."

#     if sysctl net.ipv6.conf.all.forwarding | grep "net.ipv6.conf.all.forwarding = 0" &> /dev/null; then
#         echo "Kernel parameter for ipv6 forwarding set to 0, continuing..."
#     else
#         echo "Setting kernel parameter of ipv6 forwarding to 0..."
#         sysctl -w net.ipv6.conf.all.forwarding=0 &> /dev/null
#     fi

#      if sysctl net.ipv6.route.flush | grep "net.ipv6.route.flush = 1" &> /dev/null; then
#         echo "Kernel parameter for route flush set to 1, continuing..."
#     else
#         echo "Setting kernel parameter of route flush to 1..."
#         sysctl -w net.ipv6.route.flush=1 &> /dev/null
#     fi
# fi

if cat /etc/sysctl.d/60-netipv4_syctl.conf | grep "net.ipv4.conf.all.send_redirects = 0" &> /dev/null; then
    echo "Packet redirecting all set to 0, checking in sysctl..."

    if sysctl net.ipv4.conf.all.send_redirects | grep "net.ipv4.conf.all.send_redirects = 0" &> /dev/null; then
        echo "Packet redirecting all set to 0 in kernel parameters, continuing..."
    else
        echo "Kernel parameter not set for packet redirecting, fixing..."
        sysctl -w net.ipv4.conf.all.send_redirects=0 &> /dev/null
    fi

else
	echo "Packet redirecting not set to 0, adding it..."
	echo "net.ipv4.conf.all.send_redirects = 0" >> /etc/sysctl.d/60-netipv4_syctl.conf

	if sysctl net.ipv4.conf.all.send_redirects | grep "net.ipv4.conf.all.send_redirects = 0" &> /dev/null; then
        echo "Packet redirecting all set to 0 in kernel parameters, continuing..."
    else
        echo "Kernel parameter not set for packet redirecting, fixing..."
        sysctl -w net.ipv4.conf.all.send_redirects=0 &> /dev/null
    fi
fi

if cat /etc/sysctl.d/60-netipv4_syctl.conf | grep "net.ipv4.conf.default.send_redirects = 0" &> /dev/null; then
    echo "Packet redirecting default set to 0, checking in sysctl..."

    if sysctl net.ipv4.conf.default.send_redirects | grep "net.ipv4.conf.default.send_redirects = 0" &> /dev/null; then
        echo "Packet redirecting default set to 0 in kernel parameters, continuing..."
    else
        echo "Kernel parameter not set for packet redirecting, fixing..."
        sysctl -w net.ipv4.conf.default.send_redirects=0 &> /dev/null
    fi
else
	echo "Packet redirecting default not set to 0, adding it..."
	echo "net.ipv4.conf.default.send_redirects = 0" >> /etc/sysctl.d/60-netipv4_syctl.conf

	if sysctl net.ipv4.conf.default.send_redirects | grep "net.ipv4.conf.default.send_redirects = 0" &> /dev/null; then
        echo "Packet redirecting default set to 0 in kernel parameters, continuing..."
    else
        echo "Kernel parameter not set for packet redirecting, fixing..."
        sysctl -w net.ipv4.conf.default.send_redirects=0 &> /dev/null
    fi
fi

##3.3##
##3.3.1 Ensure source routed packets are not accepted (Automated)##
if test -f /etc/sysctl.d/60-netipv4_sysctl.conf; then

	if grep -q "net.ipv4.conf.all.accept_source_route = 0" /etc/sysctl.d/60-netipv4_sysctl.conf &&
		 grep -q "net.ipv4.conf.default.accept_source_route = 0" /etc/sysctl.d/60-netipv4_sysctl.conf; then
		 
		 echo "Source routed packets are not accepted... Continuing..."
	else
			printf "
			net.ipv4.conf.all.accept_source_route = 0
			net.ipv4.conf.default.accept_source_route = 0
			" >> /etc/sysctl.d/60-netipv4_sysctl.conf
	fi
else
touch /etc/sysctl.d/60-netipv4_sysctl.conf
printf "
			net.ipv4.conf.all.accept_source_route = 0
			net.ipv4.conf.default.accept_source_route = 0
			" >> /etc/sysctl.d/60-netipv4_sysctl.conf
fi

{
 sysctl -w net.ipv4.conf.all.accept_source_route=0
 sysctl -w net.ipv4.conf.default.accept_source_route=0
 sysctl -w net.ipv4.route.flush=1
}

##3.3.2 Ensure ICMP redirects are not accepted (Automated)##
if test -f /etc/sysctl.d/60-netipv4_sysctl.conf; then

	if grep -q "net.ipv4.conf.all.accept_redirects = 0" /etc/sysctl.d/60-netipv4_sysctl.conf &&
		 grep -q "net.ipv4.conf.default.accept_redirects = 0" /etc/sysctl.d/60-netipv4_sysctl.conf; then

		 echo "ICMP redirects are not accepted... Continuing..."

	else
		 printf "
		 net.ipv4.conf.all.accept_redirects = 0
		 net.ipv4.conf.default.accept_redirects = 0
		 " >> /etc/sysctl.d/60-netipv4_sysctl.conf
	 fi
else
touch /etc/sysctl.d/60-netipv4_sysctl.conf	
printf "
	net.ipv4.conf.all.accept_redirects = 0
	net.ipv4.conf.default.accept_redirects = 0
	" >> /etc/sysctl.d/60-netipv4_sysctl.conf
fi

{
 sysctl -w net.ipv4.conf.all.accept_redirects=0
 sysctl -w net.ipv4.conf.default.accept_redirects=0
 sysctl -w net.ipv4.route.flush=1
}

##3.3.2 Ensure secure ICMP redirects are not accepted (Automated)##
if test -f /etc/sysctl.d/60-netipv4_sysctl.conf; then

	if grep -q "net.ipv4.conf.all.secure_redirects = 0" /etc/sysctl.d/60-netipv4_sysctl.conf &&
		 grep -q "net.ipv4.conf.default.secure_redirects = 0" /etc/sysctl.d/60-netipv4_sysctl.conf; then

		 echo "Secure ICMP redirects are not accepted... Continuing..."

	else
		 printf "
		 net.ipv4.conf.all.secure_redirects = 0
		 net.ipv4.conf.default.secure_redirects = 0
		 " >> /etc/sysctl.d/60-netipv4_sysctl.conf
	 fi
else
touch /etc/sysctl.d/60-netipv4_sysctl.conf	
printf "
	net.ipv4.conf.all.secure_redirects = 0
	net.ipv4.conf.default.secure_redirects = 0
	" >> /etc/sysctl.d/60-netipv4_sysctl.conf
fi

{
 sysctl -w net.ipv4.conf.all.secure_redirects=0
 sysctl -w net.ipv4.conf.default.secure_redirects=0
 sysctl -w net.ipv4.route.flush=1
}

##3.3.4 Ensure suspicious packets are logged (Automated)##
if test -f /etc/sysctl.d/60-netipv4_sysctl.conf; then

	if grep -q "net.ipv4.conf.all.log_martians = 1" /etc/sysctl.d/60-netipv4_sysctl.conf &&
		 grep -q "net.ipv4.conf.all.log_martians = 1" /etc/sysctl.d/60-netipv4_sysctl.conf; then

		 echo "Suspicious packets are logged... Continuing..."

	else
		 printf "
		 net.ipv4.conf.all.log_martians = 1
		 net.ipv4.conf.all.log_martians = 1
		 " >> /etc/sysctl.d/60-netipv4_sysctl.conf
	 fi
else
touch /etc/sysctl.d/60-netipv4_sysctl.conf	
printf "
	net.ipv4.conf.all.log_martians = 1
	net.ipv4.conf.all.log_martians = 1
	" >> /etc/sysctl.d/60-netipv4_sysctl.conf
fi

{
 sysctl -w net.ipv4.conf.all.log_martians=1
 sysctl -w net.ipv4.conf.default.log_martians=1
 sysctl -w net.ipv4.route.flush=1
}

##3.3.5 Ensure broadcast ICMP requests are ignored (Automated)##
if test -f /etc/sysctl.d/60-netipv4_sysctl.conf; then

	if grep -q "net.ipv4.icmp_echo_ignore_broadcasts = 1" /etc/sysctl.d/60-netipv4_sysctl.conf; then

		 echo "Broadcast ICMP redirects are ignored... Continuing..."

	else
		 printf "
		 net.ipv4.icmp_echo_ignore_broadcasts = 1
		 " >> /etc/sysctl.d/60-netipv4_sysctl.conf
	 fi
else
touch /etc/sysctl.d/60-netipv4_sysctl.conf	
printf "
	net.ipv4.icmp_echo_ignore_broadcasts = 1
	" >> /etc/sysctl.d/60-netipv4_sysctl.conf
fi

{
 sysctl -w net.ipv4.icmp_echo_ignore_broadcasts=1
 sysctl -w net.ipv4.route.flush=1
}

##3.3.6 Ensure bogus ICMP responses are ignored (Automated)##
if test -f /etc/sysctl.d/60-netipv4_sysctl.conf; then

	if grep -q "net.ipv4.icmp_ignore_bogus_error_responses = 1" /etc/sysctl.d/60-netipv4_sysctl.conf; then

		 echo "Bogus ICMP responses are ignored... Continuing..."

	else
		 printf "
		 net.ipv4.icmp_ignore_bogus_error_responses = 1
		 " >> /etc/sysctl.d/60-netipv4_sysctl.conf
	 fi
else
touch /etc/sysctl.d/60-netipv4_sysctl.conf	
printf "
	net.ipv4.icmp_ignore_bogus_error_responses = 1
	" >> /etc/sysctl.d/60-netipv4_sysctl.conf
fi

{
 sysctl -w net.ipv4.icmp_ignore_bogus_error_responses=1
 sysctl -w net.ipv4.route.flush=1
}

##3.3.7 Ensure Reverse Path Filtering is enabled (Automated)##
if test -f /etc/sysctl.d/60-netipv4_sysctl.conf; then

	if grep -q "net.ipv4.conf.all.rp_filter = 1" /etc/sysctl.d/60-netipv4_sysctl.conf &&
		 grep -q "net.ipv4.conf.default.rp_filter = 1" /etc/sysctl.d/60-netipv4_sysctl.conf; then

		 echo "Reverse Path Filtering is enabled... Continuing..."

	else
		 printf "
		 net.ipv4.conf.all.rp_filter = 1
		 net.ipv4.conf.default.rp_filter = 1
		 " >> /etc/sysctl.d/60-netipv4_sysctl.conf
	 fi
else
touch /etc/sysctl.d/60-netipv4_sysctl.conf	
printf "
	net.ipv4.conf.all.rp_filter = 1
	net.ipv4.conf.default.rp_filter = 1
	" >> /etc/sysctl.d/60-netipv4_sysctl.conf
fi

{
 sysctl -w net.ipv4.conf.all.rp_filter=1
 sysctl -w net.ipv4.conf.default.rp_filter=1
 sysctl -w net.ipv4.route.flush=1
}

##3.3.8 Ensure TCP SYN Cookies is enabled (Automated)##
if test -f /etc/sysctl.d/60-netipv4_sysctl.conf; then

	if grep -q "net.ipv4.tcp_syncookies = 1" /etc/sysctl.d/60-netipv4_sysctl.conf; then

		 echo "TCP SYN Cookies is enabled... Continuing..."

	else
		 printf "
		 net.ipv4.tcp_syncookies = 1
		 " >> /etc/sysctl.d/60-netipv4_sysctl.conf
	 fi
else
touch /etc/sysctl.d/60-netipv4_sysctl.conf	
printf "
	net.ipv4.tcp_syncookies = 1
	" >> /etc/sysctl.d/60-netipv4_sysctl.conf
fi

{
 sysctl -w net.ipv4.tcp_syncookies=1
 sysctl -w net.ipv4.route.flush=1
}

##3.3.9 Ensure IPv6 router advertisements are not accepted (Automated)##
if test -f /etc/sysctl.d/60-netipv4_sysctl.conf; then

	if grep -q "net.ipv6.conf.all.accept_ra = 0" /etc/sysctl.d/60-netipv4_sysctl.conf &&
		 grep -q "net.ipv6.conf.default.accept_ra = 0" /etc/sysctl.d/60-netipv4_sysctl.conf; then

		 echo "IPv6 router advertisments are not accepted... Continuing..."

	else
		 printf "
		 net.ipv6.conf.all.accept_ra = 0
		 net.ipv6.conf.default.accept_ra = 0
		 " >> /etc/sysctl.d/60-netipv4_sysctl.conf
	 fi
else
touch /etc/sysctl.d/60-netipv4_sysctl.conf	
printf "
	net.ipv6.conf.all.accept_ra = 0
	net.ipv6.conf.default.accept_ra = 0
	" >> /etc/sysctl.d/60-netipv4_sysctl.conf
fi

{
 sysctl -w net.ipv6.conf.all.accept_ra=0
 sysctl -w net.ipv6.conf.default.accept_ra=0
 sysctl -w net.ipv6.route.flush=1
}

##3.4.1 

if [ $firewall_value -eq 1 ]; then

	##3.4.1.1 Ensure firewalld is installed
	if rpm -q firewalld iptables &> /dev/null; then
		echo "FirewallD and iptables installed, continuing..."
	else   
		echo "ip tables not found, installing..."
		dnf -y install firewalld iptables &> /dev/null
	fi
	##3.4.1.2 Ensure iptables-services not installed with firewalld

	if rpm -q iptables-services &> /dev/null; then
		echo "package iptables-services  found, removing..."
		sudo yum -y install iptables-services
		systemctl stop iptables
		dnf -y remove iptables-services

	else   
		echo "Package iptables-services is not installed, continuing..."
	fi

	##3.4.1.3 Ensure nftables either not installed or masked with firewalld 

	if  rpm -q nftables &> /dev/null; then
		echo "nftables installed, removing..."
		dnf -y remove nftables &> /dev/null
	else
		echo "nftables not installed, continuing..."
	fi

	##3.4.1.4 Ensure firewalld service enabled and running
		
	if   systemctl is-enabled firewalld &> /dev/null; then
		echo "already enabled, continuing..."
	
	else
		echo "firewalld is still masked, enabling..."
		sudo yum -y install firewalld
		systemctl unmask firewalld
	fi

	if    firewall-cmd --state &> /dev/null; then
		echo "already running, continuing..."
	
	else
		echo "firewalld is not running, enabling..."
		systemctl --now enable firewalld
	fi
	##3.4.1.5 Ensure firewalld default zone is set 
		firewall-cmd --set-default-zone=public

	##3.4.1.6 Ensure network interfaces are assigned to appropriate zone (Manual)
	##3.4.1.7 Ensure firewalld drops unnecessary services and ports (Manual)
fi

##3.4.2

if [ $firewall_value -eq 2 ]; then
	##3.4.2.1 Ensure nftables is installed (Automated)

	if  rpm -q nftables &> /dev/null; then
		echo "nftables installed, continuing..."
	else   
		echo "nftables not found, installing..."
		dnf -y install nftables &> /dev/null
	fi

	##3.4.2.2 Ensure firewalld is either not installed or masked with nftables 

	if rpm -q iptables-services &> /dev/null; then
	echo "Firewalld found.. masking.."
	systemctl --now mask firewalld

	else   
		echo "Firewalld is masked, continuing..."
		systemctl --now mask firewalld
	fi

	##3.4.2.3 Ensure iptables-services not installed with nftables

	if  rpm -q iptables-services &> /dev/null; then
		echo "iptables-services installed, removing..."
		dnf -y remove iptables-services &> /dev/null
	else
		echo "iptables-services not installed, continuing..."
		dnf -y remove iptables-services
	fi

	##3.4.2.4 Ensure iptables are flushed with nftables (Manual)

	##3.4.2.5 Ensure an nftables table exists
	nft create table inet filter

	##3.4.2.6 Ensure nftables base chains exist
	nft create chain inet filter input { type filter hook input priority 0 \; }
	nft create chain inet filter forward { type filter hook forward priority 0 \; }
	nft create chain inet filter output { type filter hook output priority 0 \; }

	##3.4.2.7 Ensure nftables loopback traffic is configured
	if  nft list ruleset | awk '/hook input/,/}/' | grep 'iif "lo" accept' &> /dev/null; then
	nft add rule inet filter input iif lo accept
	echo "Loopback interface already configured, continuing.."
		
	else
		echo "Loopback interface is not set, configuring.."
		nft add rule inet filter input iif lo accept
	fi

	##3.4.2.8 Ensure nftables outbound and established connections are configured (Manual)

	##3.4.2.9 Ensure nftables default deny firewall policy (Automated)
	nft chain inet filter input { policy drop \; }
	nft chain inet filter forward { policy drop \; }
	nft chain inet filter output { policy drop \; }

	##3.4.2.10 Ensure nftables service is enabled
	if  systemctl is-enabled nftables &> /dev/null; then
		systemctl enable nftables
		echo "nftables services enabled, continuing..."
	else   
		echo "nftables services not enabled, configuring..."
		sudo yum -y install nftables
		systemctl enable nftables
	fi
fi

if [ $firewall_value -eq 3 ]; then
	# 3.4.3.1.1 Ensure iptables packages are installed

	if rpm -q iptables ip tables-services &> /dev/null; then
		echo "iptables installed, continuing..."
	else   
		echo "ip tables not found, installing..."
		dnf -y install iptables iptables-services &> /dev/null
	fi

	# 3.4.3.1.2 Ensure nftables is not installed with iptables

	if rpm -q nftables &> /dev/null; then
		echo "nftables installed, removing..."
		dnf remove nftables &> /dev/null
	else
		echo "nftables not installed, continuing..."
	fi

	# 3.4.3.1.3 Ensure firewalld is removed or masked with iptables

	if rpm -q firewalld &> /dev/null; then
		echo "firewalld installed, removing..."
		dnf remove firewalld &> /dev/null
	else
		echo "firewalld not installed, continuing..."
	fi

	# 

	# Flush IPtables rules 

	iptables -F 

	# Ensure default deny firewall policy 

	iptables -P INPUT DROP iptables -P OUTPUT DROP iptables -P FORWARD DROP 

	# Ensure loopback traffic is configured 

	iptables -A INPUT -i lo -j ACCEPT iptables -A OUTPUT -o lo -j ACCEPT 

	iptables -A INPUT -s 127.0.0.0/8 -j DROP 

	# Ensure outbound and established connections are configured 

	iptables -A OUTPUT -p tcp -m state --state NEW,ESTABLISHED -j ACCEPT 

	iptables -A OUTPUT -p udp -m state --state NEW,ESTABLISHED -j ACCEPT 

	iptables -A OUTPUT -p icmp -m state --state NEW,ESTABLISHED -j ACCEPT 

	iptables -A INPUT -p tcp -m state --state ESTABLISHED -j ACCEPT 

	iptables -A INPUT -p udp -m state --state ESTABLISHED -j ACCEPT 

	iptables -A INPUT -p icmp -m state --state ESTABLISHED -j ACCEPT 

	# Open inbound ssh(tcp port 22) connections 

	iptables -A INPUT -p tcp --dport 22 -m state --state NEW -j ACCEPT

	# 3.4.3.2.4 Ensure iptables default deny firewall policy

	iptables -p INPUT DROP
	iptables -p OUTPUT DROP
	iptables -P FORWARD DROP

	# 3.4.3.2.5 Ensure iptables config is saved

	service iptables save

	# 3.4.3.2.6 Ensure iptables is enabled and active

	if systemctl is-active iptables | grep "active" &> /dev/null; then
		echo "iptables is activated, continuing..."
	else
		echo "Activating iptables..."
		systemctl --now enable iptables
	fi

	# Flush ip6tables rules 
	ip6tables -F 

	# Ensure default deny firewall policy 

	ip6tables -P INPUT DROP ip6tables -P OUTPUT DROP ip6tables -P FORWARD DROP 

	# Ensure loopback traffic is configured 

	ip6tables -A INPUT -i lo -j ACCEPT ip6tables -A OUTPUT -o lo -j ACCEPT ip6tables -A INPUT -s ::1 -j DROP 

	# Ensure outbound and established connections are configured 

	ip6tables -A OUTPUT -p tcp -m state --state NEW,ESTABLISHED -j ACCEPT 

	ip6tables -A OUTPUT -p udp -m state --state NEW,ESTABLISHED -j ACCEPT 

	ip6tables -A OUTPUT -p icmp -m state --state NEW,ESTABLISHED -j ACCEPT 

	ip6tables -A INPUT -p tcp -m state --state ESTABLISHED -j ACCEPT 

	ip6tables -A INPUT -p udp -m state --state ESTABLISHED -j ACCEPT 

	ip6tables -A INPUT -p icmp -m state --state ESTABLISHED -j ACCEPT 

	# Open inbound ssh(tcp port 22) connections 

	ip6tables -A INPUT -p tcp --dport 22 -m state --state NEW -j ACCEPT

	# 3.4.3.3.4 Ensure ip6tables default deny firewall policy

	ip6tables -P INPUT DROP

	ip6tables -P OUTPUT DROP

	ip6tables -P FORWARD DROP

	# 3.4.3.3.5 Ensure ip6tables config is saved

	service ip6tables save

	# 3.4.3.3.6 Ensure ip6tables is enabled and active

	if systemctl is-active ip6tables | grep "active" &> /dev/null; then
		echo "ip6tables is activated, continuing..."
	else
		echo "Activating ip6tables..."
		systemctl --now enable ip6tables
	fi
fi

##4.1.1.1 Ensure auditd is installed
if rpm -q audit &> /dev/null; then
    echo "auditd already installed, continuing..."
else   
    echo "ip tables not found, installing..."
    dnf -y install audit &> /dev/null
fi

##4.1.1.2 Ensure auditd service is enabled
if  systemctl is-enabled auditd &> /dev/null; then
    echo "auditd already enabled, continuing..."
else   
    echo "auditd not enabled, configuring..."
    systemctl --now enable auditd &> /dev/null
fi

##4.1.1.3 Ensure auditing for processes that start prior to auditd is enabled
grubby --update-kernel ALL --args 'audit=1'

##4.1.1.4 Ensure audit_backlog_limit is sufficient
grubby --update-kernel ALL --args 'audit_backlog_limit=8192'

##4.1.2.1 Ensure audit log storage size is configured
sed -i 's/max_log_file = 8/max_log_file= 20/g' /etc/audit/auditd.conf
grep -w "^\s*max_log_file\s*=" /etc/audit/auditd.conf


##4.1.2.2 Ensure audit logs are not automatically deleted
sed -i 's/max_log_file_action = ROTATE/max_log_file_action = keep_logs/g' /etc/audit/auditd.conf
 grep max_log_file_action /etc/audit/auditd.conf


##4.1.2.3 Ensure system is disabled when audit logs are full 
sed -i 's/space_left_action = SYSLOG/space_left_action = email/g' /etc/audit/auditd.conf
grep space_left_action /etc/audit/auditd.conf
grep action_mail_acct /etc/audit/auditd.conf



##4.1.3.1 Ensure changes to system administration scope (sudoers) is collected
echo "Setting system administration scope..."
touch /etc/audit/rules.d/50-scope.rules

printf "
-w /etc/sudoers -p wa -k scope
-w /etc/sudoers.d -p wa -k scope
" >> /etc/audit/rules.d/50-scope.rules

##4.1.3.2 Ensure actions as another user are always logged
echo "Setting emulation rules..."
touch /etc/audit/rules.d/50-user_emulation.rules

printf "
-a always,exit -F arch=b64 -C euid!=uid -F auid!=unset -S execve -k 
user_emulation 
-a always,exit -F arch=b32 -C euid!=uid -F auid!=unset -S execve -k 
user_emulation
" >> /etc/audit/rules.d/50-user_emulation.rules

##4.1.3.3 Ensure events that modify the sudo log file are collected
echo "Setting SUDO LOG FILE..."
SUDO_LOG_FILE=$(grep -r logfile /etc/sudoers* | sed -e 's/.*logfile=//;s/,? .*//' -e 's/"//g')

echo "Making sudo log rules..."
touch /etc/audit/rules.d/50-sudo.rules

[ -n "${SUDO_LOG_FILE_ESCAPED}" ] && printf "
-w ${SUDO_LOG_FILE} -p wa -k sudo_log_file
" >> /etc/audit/rules.d/50-sudo.rules \ || printf "ERROR: Variable 'SUDO_LOG_FILE_ESCAPED' is unset.\n"

##4.1.3.4 Ensure events that modify date and time information are collected
echo "Modifying system dates..."
touch /etc/audit/rules.d/50-time-change.rules

 printf "
-a always,exit -F arch=b64 -S adjtimex,settimeofday,clock_settime -k timechange
-a always,exit -F arch=b32 -S adjtimex,settimeofday,clock_settime -k timechange
-w /etc/localtime -p wa -k timechange
" >> /etc/audit/rules.d/50-time-change.rules

##4.1.3.5 Ensure events that modify the system's network environment are collected
echo "Setting system local rules..."
touch /etc/audit/rules.d/50-system_local.rules

printf "
-a always,exit -F arch=b64 -S sethostname,setdomainname -k system-locale
-a always,exit -F arch=b32 -S sethostname,setdomainname -k system-locale
-w /etc/issue -p wa -k system-locale
-w /etc/issue.net -p wa -k system-locale
-w /etc/hosts -p wa -k system-locale
-w /etc/sysconfig/network -p wa -k system-locale
-w /etc/sysconfig/network-scripts/ -p wa -k system-locale
" >> /etc/audit/rules.d/50-system_local.rules

# 4.1.3.7

echo "Setting UID_MIN..."
UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)

echo "Making access audit log rules..."
touch /etc/audit/rules.d/50-access.rules

[ -n "${UID_MIN}" ] && printf "
-a always,exit -F arch=b64 -S creat,open,openat,truncate,ftruncate -F exit=-EACCES -F auid>=${UID_MIN} -F auid!=unset -k access
-a always,exit -F arch=b64 -S creat,open,openat,truncate,ftruncate -F exit=-EPERM -F auid>=${UID_MIN} -F auid!=unset -k access
-a always,exit -F arch=b32 -S creat,open,openat,truncate,ftruncate -F exit=-EACCES -F auid>=${UID_MIN} -F auid!=unset -k access
-a always,exit -F arch=b32 -S creat,open,openat,truncate,ftruncate -F exit=-EPERM -F auid>=${UID_MIN} -F auid!=unset -k access
" >> /etc/audit/rules.d/50-access.rules \ || printf "ERROR: Variable 'UID_MIN' is unset. \n"

# 4.1.3.8
echo "Making identity audit log rules..."
touch /etc/audit/rules.d/50-identity.rules

printf "
-w /etc/group -p wa -k identity
-w /etc/passwd -p wa -k identity 
-w /etc/gshadow -p wa -k identity 
-w /etc/shadow -p wa -k identity 
-w /etc/security/opasswd -p wa -k identity
" >> /etc/audit/rules.d/50-identity.rules

# 4.1.3.9

echo "Making permission modification audit log rules..."
touch /etc/audit/rules.d/50-perm_mod.rules

[ -n "${UID_MIN}" ] && printf "
-a always,exit -F arch=b64 -S chmod,fchmod,fchmodat -F auid>=${UID_MIN} -F auid!=unset -F key=perm_mod
-a always,exit -F arch=b64 -S chown,fchown,lchown,fchownat -F auid>=${UID_MIN} -F auid!=unset -F key=perm_mod
-a always,exit -F arch=b32 -S chmod,fchmod,fchmodat -F auid>=${UID_MIN} -F auid!=unset -F key=perm_mod
-a always,exit -F arch=b32 -S lchown,fchown,chown,fchownat -F auid>=${UID_MIN} -F auid!=unset -F key=perm_mod
-a always,exit -F arch=b64 -S setxattr,lsetxattr,fsetxattr,removexattr,lremovexattr,fremovexattr -F auid>=${UID_MIN} -F auid!=unset -F key=perm_mod
-a always,exit -F arch=b32 -S setxattr,lsetxattr,fsetxattr,removexattr,lremovexattr,fremovexattr -F auid>=${UID_MIN} -F auid!=unset -F key=perm_mod
" >> /etc/audit/rules.d/50-perm_mod.rules \ || printf "ERROR: Variable 'UID_MIN' is unset. \n"

# 4.1.3.10
echo "Adding in file system mounts audit log rules to permissison modification rules..."
[ -n "${UID_MIN}" ] && printf "
-a always,exit -F arch=b32 -S mount -F auid>=1000 -F auid!=unset -k mounts
-a always,exit -F arch=b64 -S mount -F auid>=1000 -F auid!=unset -k mounts
" >> /etc/audit/rules.d/50-perm_mod.rules \ || printf "ERROR: Variable 'UID_MIN' is unset. \n"

# 4.1.3.11
echo "Making session initiation information audit log rules..."
touch /etc/audit/rules.d/50-session.rules

printf "
-w /var/run/utmp -p wa -k session 
-w /var/log/wtmp -p wa -k session 
-w /var/log/btmp -p wa -k session
" >> /etc/audit/rules.d/50-session.rules

# 4.1.3.12
echo "Making login and logout event audit log rules..."
touch /etc/audit/rules.d/50-login.rules

printf "
-w /var/log/lastlog -p wa -k logins 
-w /var/run/faillock -p wa -k logins 
" >> /etc/audit/rules.d/50-login.rules

# 4.1.3.13
echo "Making deletion event audit log rules..."
touch /etc/audit/rules.d/50-delete.rules

[ -n "${UID_MIN}" ] && printf "
-a always,exit -F arch=b64 -S rename,unlink,unlinkat,renameat -F auid>=${UID_MIN} -F auid!=unset -F key=delete
-a always,exit -F arch=b32 -S rename,unlink,unlinkat,renameat -F auid>=${UID_MIN} -F auid!=unset -F key=delete
" >> /etc/audit/rules.d/50-delete.rules

# 4.1.3.14
echo "Making MAC modification events audit log rules..."
touch /etc/audit/rules.d/50-MAC-policy.rules

printf "
-w /etc/selinux -p wa -k MAC-policy
-w /usr/share/selinux -p wa -k MAC-policy
" >> /etc/audit/rules.d/50-MAC-policy.rules

# 4.1.3.15
echo "Making chcon command attempts audit log rules..."
touch /etc/audit/rules.d/50-perm_chng.rules

[ -n "${UID_MIN}" ] && printf "
-a always,exit -F path=/usr/bin/chcon -F perm=x -F auid>=${UID_MIN} -F auid!=unset -k perm_chng
" >> /etc/audit/rules.d/50-perm_chng.rules \ || printf "ERROR: Variable 'UID_MIN' is unset.\n"

# 4.1.3.16

echo "Making setfacl command attempts audit log rules..."
touch /etc/audit/rules.d/50-priv_cmd.rules

[ -n "${UID_MIN}" ] && printf "
-a always,exit -F path=/usr/bin/setfacl -F perm=x -F auid>=${UID_MIN} -F auid!=unset -k perm_chng
" >> /etc/audit/rules.d/50-priv_cmd.rules \ || printf "ERROR: Variable 'UID_MIN' is unset.\n"

# 4.1.3.17
echo "Adding in chacl command attempt audit log rules to chcon audit log rules..."
[ -n "${UID_MIN}" ] && printf "
-a always,exit -F path=/usr/bin/chacl -F perm=x -F auid>=${UID_MIN} -F auid!=unset -k perm_chng
" >> /etc/audit/rules.d/50-perm_chng.rules \ || printf "ERROR: Variable 'UID_MIN' is unset.\n"

# 4.1.3.18
echo "Making usermod command attempt audit log rules..."
touch /etc/audit/rules.d/50-usermod.rules

[ -n "${UID_MIN}" ] && printf "
-a always,exit -F path=/usr/sbin/usermod -F perm=x -F auid>=${UID_MIN} -F auid!=unset -k usermod
" >> /etc/audit/rules.d/50-usermod.rules \ || printf "ERROR: Variable 'UID_MIN' is unset.\n"

# 4.1.3.19
echo "Making kernel module loading or unloading and modification audit log rules..."
touch /etc/audit/rules.d/50-kernel_modules.rules

[ -n "${UID_MIN}" ] && printf "
-a always,exit -F arch=b64 -S init_module,finit_module,delete_module,create_module,query_module -F auid>=${UID_MIN} -F auid!=unset -k kernel_modules
-a always,exit -F path=/usr/bin/kmod -F perm=x -F auid>=${UID_MIN} -F auid!=unset -k kernel_modules
" >> /etc/audit/rules.d/50-kernel_modules.rules \ || printf "ERROR: Variable 'UID_MIN' is unset.\n"

# 4.1.3.20
echo "Setting audit configuration to immutable..."
echo "-e 2" > /etc/audit/rules.d/99-finalize.rules

echo "Loading audit rules..."
augenrules --load &> /dev/null

if [[ $(auditctl -s | grep "enabled") =~ "2" ]]; then 
    printf "Reboot required to load rules\n"; 
fi

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

##5.1##

##5.1.2 Ensure permissions on /etc/crontab are configured
 chown root:root /etc/crontab
 chmod og-rwx /etc/crontab
 stat /etc/crontab
 echo "Permissions on /etc/crontab configured, continuing.."

##5.1.3 Ensure permissions on /etc/cron.hourly are configure
 chown root:root /etc/cron.hourly
 chmod og-rwx /etc/cron.hourly
 stat /etc/cron.hourly
 echo "Permissions on /etc/cron.hourly configured, continuing.."

##5.1.4 Ensure permissions on /etc/cron.daily are configured
 chown root:root /etc/cron.daily
 chmod og-rwx /etc/cron.daily
 stat /etc/cron.daily
 echo "Permissions on stat /etc/cron.daily configured, continuing.."

##5.1.5 Ensure permissions on /etc/cron.weekly are configured
 chown root:root /etc/cron.weekly
 chmod og-rwx /etc/cron.weekly
 stat /etc/cron.weekly
 echo "Permissions on stat /etc/cron.weekly configured, continuing.."

##5.1.6 Ensure permissions on /etc/cron.monthly are configured
 chown root:root /etc/cron.monthly
 chmod og-rwx /etc/cron.monthly
 stat /etc/cron.monthly
 echo "Permissions on /etc/cron.monthly configured, continuing.."

##5.1.7 Ensure permissions on /etc/cron.d are configured
 chown root:root /etc/cron.d
 chmod og-rwx /etc/cron.d
 stat /etc/cron.d
 echo "Permissions on /etc/cron.d configured, continuing.."

##5.1.8 Ensure cron is restricted to authorized users
dnf -y remove cronie
echo "removing cronie.."

##5.1.9 Ensure at is restricted to authorized users
dnf -y remove at
echo "removing at.."

#!/bin/bash

# 5.2.1 Ensure permissions on /etc/ssh/sshd_config are configured

echo "Changing file ownership for sshd_config file to root..."
chown root:root /etc/ssh/sshd_config
echo "Changing permissions for sshd_config file to owner only..."
chmod og-rwx /etc/ssh/sshd_config

# 5.2.2 Ensure permissions on SSH private host key files are configured

echo "Making ssh private keys only owner read/writable..."
find /etc/ssh -xdev -type f -name 'ssh_host_*_key' -exec chmod u=rw,g=r,o= {} \;
echo "Making ssh private keys ownership to root..."
find /etc/ssh -xdev -type f -name 'ssh_host_*_key' -exec chown root:ssh_keys {} \;

# 5.2.3 Ensure permissions on SSH public host key files are configured

echo "Making ssh public keys only owner read/writable..."
find /etc/ssh -xdev -type f -name 'ssh_host_*_key.pub' -exec chmod u=rw,go= {} \;
echo "Making ssh public keys ownership to root..."
find /etc/ssh -xdev -type f -name 'ssh_host_*_key.pub' -exec chown root:root {} \;

# 5.2.4 Ensure SSH access is limited

# 5.2.5 Ensure SSH LogLevel is appropriate

echo "Ensuring LogLevel is appropriate..."
sed -i 's/^#.*LogLevel\s.*$/LogLevel INFO/' /etc/ssh/sshd_config

# 5.2.7 Ensure SSH root login is disabled

echo "Ensuring root login is disabled..."
sed -i 's/^PermitRootLogin\s.*$/PermitRootLogin No/' /etc/ssh/sshd_config

# 5.2.8 Ensure SSH HostbasedAuthentication is disabled

echo "Ensuring Hostbasedauthentication is disabled..."
sed -i 's/^#.*HostbasedAuthentication\s.*$/HostbasedAuthentication No/' /etc/ssh/sshd_config

# 5.2.9 Ensure SSH PermitEmptyPasswords is disabled

echo "Ensuring PermitEmptyPasswords is disabled..."
sed -i 's/^PermitEmptyPasswords\s.*$/PermitEmptyPasswords No/' /etc/ssh/sshd_config

# 5.2.10 Ensure SSH PermitUserEnvironment is disabled

echo "Ensuring PermitUserEnvironment is disabled..."
sed -i 's/^#.*PermitUserEnvironment\s.*$/PermitUserEnvironment No/' /etc/ssh/sshd_config

# 5.2.11 Ensure SSH IgnoreRhosts is enabled

echo "Ensuring SSH IgnoreRhosts is enabled"
sed -i 's/^#.*IgnoreRhosts\s.*$/IgnoreRhosts Yes/' /etc/ssh/sshd_config

# 5.2.12 Ensure SSH X11 forwarding is disabled

echo "Ensuring X11 Forwarding is disabled..."
sed -i 's/^X11Forwarding\s.*$/X11Forwarding No/' /etc/ssh/sshd_config

# 5.2.13 Ensure SSH AllowTcpForwarding is disabled

echo "Ensuring AllowTcpForwarding is disabled..."
sed -i 's/^#.*AllowTcpForwarding\s.*$/AllowTcpForwarding No/' /etc/ssh/sshd_config

# 5.2.14 Ensure system-wide crypto policy is not over-ridden

echo "Ensuring crypto policy is not over-ridden"
sed -ri "s/^\s*(CRYPTO_POLICY\s*=.*)$/# \1/" /etc/sysconfig/sshd

systemctl reload sshd

# 5.2.15 Ensure SSH warning banner is configured

echo  "Ensuring warning banner is configured"
sed -i "s/\#Banner none/Banner \/etc\/issue\.net/" /etc/ssh/sshd_config

# 5.2.16 Ensure SSH MaxAuthTries is set to 4 or less

echo "Ensuring MaxAuthTries set to 4 or less"
sed -i 's/^#.*MaxAuthTries\s.*$/MaxAuthTries 4/' /etc/ssh/sshd_config

# 5.2.17 Ensure SSH MaxStartups is configured

echo "Ensuring MaxStartups is configured..."
sed -i 's/^#.*MaxStartups\s.*$/MaxStartups 10:30:60/' /etc/ssh/sshd_config

# 5.2.18 Ensure SSH MaxSessions is set to 10 or less

echo "Ensuring MaxSessions is set to 10 or less..."
sed -i 's/^#.*MaxSessions\s.*$/MaxSessions 10/' /etc/ssh/sshd_config

# 5.2.19 Ensure SSH LoginGraceTime is set to one minute or less

echo "Ensuring LoginGraceTime set to 1 minute or less..."
sed -i 's/^#.*LoginGraceTime\s.*$/LoginGraceTime 60/' /etc/ssh/sshd_config

# 5.2.20 Ensure SSH Idle Timeout Interval is configured

echo "Ensuring IdleTimeOutInterval is configured..."
sed -i 's/^#.*ClientAliveInterval\s.*$/ClientAliveInterval 900/' /etc/ssh/sshd_config

sed -i 's/^#.*ClientAliveCountMax\s.*$/ClientAliveCountMax 0/' /etc/ssh/sshd_config
#!/bin/bash

##5.3

##5.3.1 Ensure sudo is installed
if rpm -q sudo &> /dev/null; then
    dnf list sudo
    echo "sudo installed, continuing..."
else   
    echo "sudo not found, installing..."
     dnf -y install sudo &> /dev/null
     dnf list sudo
fi

##5.3.2 Ensure sudo commands use pty
if grep -q "/etc/suduoers:Defaults use_pty" /etc/suduoers; then

echo "pty is in use, continuing.."

else
echo -e "/etc/suduoers:Defaults use_pty" >>/etc/suduoers

fi

##5.3.3 Ensure sudo log file exists
if grep -q "Defaults logfile=/var/log/sudo.log" /etc/suduoers; then

echo "sudo log file exists.."

else
echo -e "Defaults logfile=/var/log/sudo.log" >>/etc/suduoers

fi
 
##5.3.4 Ensure users must provide password for escalation
if grep -q "NOPASSWD" /etc/suduoers; then

echo -e "NOPASSWD still exists, removing.."
   sed '/NOPASSWD/d' /etc/suduoers

else
  sed '/NOPASSWD/d' /etc/suduoers
echo -e "NOPASSWD removed from the lines, continuing.."

fi

##5.3.5 Ensure re-authentication for privilege escalation is not disabled globally
if grep -q "!authenticate" /etc/suduoers; then

echo -e "!authenticate still exists, removing.."
  sed '/!authenticate/d' /etc/suduoers
   
else
  sed '/!authenticate/d' /etc/suduoers
echo -e "!authenticate  removed from the lines, continuing.."

fi

##5.3.6 Ensure sudo authentication timeout is configured correctly
sed -i 's/Defaults    env_reset/Defaults    env_reset, timestamp_timeout=15/g' /etc/suduoers
echo -e "sudo authentication timeout is configured correctly, continuing.."

##5.3.7 Ensure access to the su command is restricted
if grep sugroup /etc/group; then
groupadd sugroup
echo "empty group added, continuing"

else
echo "empty group does not exist, adding.."
groupadd sugroup

fi
#!/bin/bash

##5.4.2 Ensure authselect includes with-faillock (Automated)##

if grep pam_faillock.so /etc/pam.d/password-auth /etc/pam.d/system-auth &> /dev/null; then
	
	echo "Authselect includes with-faillock... Continuing..."

else
	authselect enable-feature with-faillock
	authselect apply-changes
fi

	
##5.5.1 Ensure password creation requirements are configured(Automated)##

if grep -q "minlen = 14" /etc/security/pwquality.conf &&
grep -q "minclass = 4" /etc/security/pwquality.conf &&
grep -q "dcredit = -1" /etc/security/pwquality.conf &&
grep -q "ucredit = -1" /etc/security/pwquality.conf &&
grep -q "ocredit = -1" /etc/security/pwquality.conf &&
grep -q "lcredit = -1" /etc/security/pwquality.conf; then

echo "Password creation requirements are configured... Continuing..." 

else

echo -e "minlen = 14\nminclass = 4\ndcredit = -1\nucredit = -1\nocredit = -1\nlcredit = -1" >> /etc/security/pwquality.conf

fi


##5.5.2 Ensure lockout for failed password attempts is configured(Automated)##

if grep -qw "deny = 5" /etc/security/faillock.conf &&
grep -qw "unlock_time = 900" /etc/security/faillock.conf; then

	echo "Lockout for failed password attempts is configured... Continuing..."

else 
	echo "deny = 5" >> /etc/security/faillock.conf
	echo "unlock_time = 900" >> /etc/security/faillock.conf
fi


##5.5.3 Ensure password reuse is limited (Automated)##

##5.5.4 Ensure password hashing algorithm is SHA-512 (Automated)##

if grep -Ei -q '^\s*crypt_style\s*=\s*sha512\b' /etc/libuser.conf; then

echo "Configured hashing algorithm is sha512 in /etc/libuser.conf... Continuing..."

else 
echo "crypt_style = sha512" >> /etc/libuser.conf

fi

if grep -Ei -q '^\s*ENCRYPT_METHOD\s+SHA512\b' /etc/login.defs; then 

echo "Configured hashing algorithm is sha512 in /etc/login.defs... Continuing..."

else 
echo "ENCRYPT_METHOD SHA512" >> /etc/login.defs

fi


##5.6.1.1 Ensure password expiration is 365 days or less (Automated)##

if grep -qw 'PASS_MAX_DAYS   365' /etc/login.defs; then

echo "Password expiration is set to 365 days... Continuing..."

else
sed -i 's/PASS_MAX_DAYS   99999/PASS_MAX_DAYS   365/' /etc/login.defs
fi

##5.6.1.2 Ensure minimum days between password changes is 7 or more(Automated)##

if grep -qw "PASS_MIN_DAYS   7" /etc/login.defs; then

echo "Minimum days between password changes is set to 7... Continuing..."

else
sed -i 's/PASS_MIN_DAYS   0/PASS_MIN_DAYS   7/' /etc/login.defs
fi

##5.6.1.3 Ensure password expiration warning days is 7 or more(Automated)##

if grep -qw "PASS_WARN_AGE   7" /etc/login.defs; then

echo "Password expiration warning days is set to 7... Continuing..."

else
sed -i 's/PASS_WARN_AGE   7/PASS_WARN_AGE   7/' /etc/login.defs
fi

##5.6.1.4 Ensure inactive password lock is 30 days or less (Automated)##

if useradd -D | grep -qw "INACTIVE=30"; then

echo "Inactive password lock is set to 30 days... Continuing..."

else
useradd -D -f 30
fi

##5.6.1.5 Ensure all users last password change date is in the past##
## Manual Remediation ##

##5.6.2 Ensure system accounts are secured (Automated)##

##5.6.3 Ensure default user shell timeout is 900 seconds or less(Automated)##

if grep -q "TMOUT=900" /etc/profile &&
grep -q "readonly TMOUT" /etc/profile &&
grep -q "export TMOUT" /etc/profile; then

echo "Default user shell timeout is set to 900 seconds... Continuing..."

else
echo -e "TMOUT=900\nreadonly TMOUT\nexport TMOUT" >> /etc/profile

fi

if grep -q "TMOUT=900" /etc/bashrc &&
grep -q "readonly TMOUT" /etc/bashrc &&
grep -q "export TMOUT" /etc/bashrc; then

echo "Default user shell timeout is set to 900 seconds... Continuing..."

else
echo -e "TMOUT=900\nreadonly TMOUT\nexport TMOUT" >> /etc/bashrc

fi

##5.6.4 Ensure default group for the root account is GID 0 (Automated)##

if grep -q "^root:" /etc/passwd | cut -f4 -d: ;then

echo "Default group for the root account is GID 0... Continuing..."

else 
usermod -g 0 root
fi


##5.6.5 Ensure default user umask is 027 or more restrictive (Automated)##

if test -f /etc/profile.d/set_umask.sh; then

	if grep -q "umask 027" /etc/profile.d/set_umask.sh; then

echo "Default user mask is 027... Continuing..."

	else
echo "umask 027" > /etc/profile.d/set_umask.sh
fi
else

touch /etc/profile.d/set_umask.sh
echo "umask 027" > /etc/profile.d/set_umask.sh

fi

##6.1

##6.1.1 Audit system file permissions (Manual)

##6.1.2 Ensure sticky bit is set on all world-writable directories 
 df --local -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' find '{}' -xdev -type d \( -perm -0002 -a ! -perm -1000 \) 2>/dev/null | xargs -I '{}' chmod a+t '{}'
 echo "Sticky bit  is set, continuing.."

##6.1.3 Ensure permissions on /etc/passwd are configured
chown root:root /etc/passwd
chmod 644 /etc/passwd
stat /etc/passwd
echo "Permissions on /etc/passwd configured, continuing.."

##6.1.4 Ensure permissions on /etc/shadow are configured
chown root:root /etc/shadow
chmod 0000 /etc/shadow
stat /etc/shadow
echo "Permissions on /etc/shadow configured, continuing.."

##6.1.5 Ensure permissions on /etc/group are configured
chown root:root /etc/group
chmod u-x,g-wx,o-wx /etc/group
stat /etc/group
echo "Permissions on /etc/group configured, continuing.."

##6.1.6 Ensure permissions on /etc/gshadow are configured
chown root:root /etc/gshadow
chmod 0000 /etc/gshadow
stat /etc/gshadow
echo "Permissions on /etc/gshadow configured, continuing.."

##6.1.7 Ensure permissions on /etc/passwd- are configured
chown root:root /etc/passwd-
# chmod chmod u-x,go-wx /etc/passwd-
stat /etc/passwd-
echo "Permissions on /etc/passwd- configured, continuing.."

##6.1.8 Ensure permissions on /etc/shadow- are configured
chown root:root /etc/shadow-
chmod 0000 /etc/shadow-
stat /etc/shadow-
echo "Permissions on /etc/shadow- configured, continuing.."

##6.1.9 Ensure permissions on /etc/group- are configured
chown root:root /etc/group-
chmod u-x,go-wx /etc/group-
stat /etc/group-
echo "Permissions on /etc/group- configured, continuing.."

##6.1.10 Ensure permissions on /etc/gshadow- are configured 
chown root:root /etc/gshadow-
chmod 0000 /etc/gshadow-
stat /etc/gshadow-
echo "Permissions on /etc/gshadow- configured, continuing.."

echo "Creating directory for duplicates..."
mkdir duplicates/ # Create a directory that will store duplicates for manual removal

# 6.2.1 Ensure password fields are not empty

awk -F: '($2 == "" ) { print $1 " does not have a password, disabling..."; system(passwd -l $1)}' /etc/shadow

# 6.2.2 Ensure all groups in /etc/passwd exist in /etc/group

for i in $(cut -s -d: -f4 /etc/passwd | sort -u ); 
do 
    grep -q -P "^.*?:[^:]*:$i:" /etc/group 
    if [ $? -ne 0 ]; then 
        echo "Group $i is referenced by /etc/passwd but does not exist in /etc/group"
        
        while : ; do
            echo -n "Do you want to remove group $i (y/n): "
            if [ $answer == "y" ] || [ $answer == "Y" ]; then
                echo "Removing group $i..."
                groupdel $i

            elif [ $answer == "n" ] || [ $answer == "N" ]; then
                echo "Continuing..."
                break
            else
                echo "You entered a wrong option."
            fi

        done
    fi 
done

# 6.2.3 Ensure no duplicate UIDs exist

uid_counter=0
touch duplicates/uid_duplicates

echo -e "This file shows duplicate UIDs within the system\n" >> duplicates/uid_duplicates

cut -f3 -d ":" /etc/passwd | sort -n | uniq -c | while read x ; do 
    [ -z "$x" ] && break 
    set - $x 
    if [ $1 -gt 1 ]; then 
        users=$(awk -F: '($3 == n) { print $1 }' n=$2 /etc/passwd | xargs) 
        echo "Duplicate UID ($2): $users"
        echo "Duplicate UID ($2): $users" >> duplicates/uid_duplicates
        let uid_counter++
    fi 
done

if [ $uid_counter -eq 0 ]; then
    echo "No UID duplicates, continuing..."
fi

# 6.2.4 Ensure no duplicate GIDs exist

gid_counter=0
touch duplicates/gid_duplicates

echo -e "This file shows duplicate GIDs within the system\n" >> duplicates/gid_duplicates

cut -d: -f3 /etc/group | sort | uniq -d | while read x ; do 
    echo "Duplicate GID ($x) in /etc/group"
    echo "Duplicate GID found: $x" >>  duplicates/gid_duplicates  
    let gid_counter++
done

if [ $gid_counter -eq 0 ]; then
    echo "No duplicate GID found, continuing..."
fi

# 6.2.5 Ensure no duplicate user names exist

user_counter=0
touch duplicates/user_duplicates

echo -e "This file shows duplicate user names within the system\n" >> duplicates/user_duplicates

cut -d: -f1 /etc/passwd | sort | uniq -d | while read x; do 
    echo "Duplicate login name ${x} in /etc/passwd"
    echo "Duplicate login name: ${x}" >> duplicates/user_duplicates
    let user_counter++
done

if [ $user_counter -eq 0 ]; then
    echo "No duplicate user names found, continuing..."
fi

# 6.2.6 Ensure no duplicate group names exist

group_name_counter=0
touch duplicates/group_duplicates

echo -e "This file shows duplicate group names within the system\n" >> duplicates/group_duplicates

cut -d: -f1 /etc/group | sort | uniq -d | while read -r x; do 
    echo "Duplicate group name ${x} in /etc/group"
    echo "Duplicate group name: ${x}" >> duplicates/group_duplicates
done

if [ $group_name_counter -eq 0 ]; then
    echo "No duplicate group names found, continuing..."
fi

# 6.2.7 Ensure root PATH Integrity

RPCV="$(sudo -Hiu root env | grep '^PATH=' | cut -d= -f2)" 

echo "$RPCV" | grep -q "::" && echo "root's path contains a empty directory (::)" 
echo "$RPCV" | grep -q ":$" && echo "root's path contains a trailing (:)" 

for x in $(echo "$RPCV" | tr ":" " "); do 

    if [ -d "$x" ]; then 

    ls -ldH "$x" | awk '$9 == "." {print "PATH contains current working directory (.)"} $3 != "root" {print $9, "is not owned by root"} substr($1,6,1) != "-" {print $9, "is group writable"} substr($1,9,1) != "-" {print $9, "is world writable"}' 

    else 

    echo "$x is not a directory" 
    fi

done

# 6.2.8 Ensure root is the only UID 0 account

root_uid_check=$(awk -F: '($3 == 0) { print $1 }' /etc/passwd)

if [ $(awk -F: '($3 == 0) { print $1 }' /etc/passwd | wc -l) -eq 1 ]; then
    echo "Root is only user with UID of 0, continuing..."
else
    for user in $root_uid_check
    do
        if [ $user != "root" ]; then
             while : ; do
                echo -n "$user has UID of 0 but is not root, do you want to remove it (y/n): "
                if [ $answer == "y" ] || [ $answer == "Y" ]; then
                    echo "Removing user $user..."
                    userdel $user

                elif [ $answer == "n" ] || [ $answer == "N" ]; then
                    echo "Continuing..."
                    break
                else
                    echo "You entered a wrong option."
                fi
            done
        fi
    done
fi
        
##6.2.9 Ensure all users' home directories exist (Automated)##

if 
awk -F: '($1!~/(halt|sync|shutdown|nfsnobody)/ &&
$7!~/^(\/usr)?\/sbin\/nologin(\/)?$/ && $7!~/(\/usr)?\/bin\/false(\/)?$/) {
print $1 " " $6 }' /etc/passwd | while read -r user dir; do
 if [ ! -d "$dir" ]; then
 mkdir "$dir"
 chmod g-w,o-wrx "$dir"
 chown "$user" "$dir"
 fi
done; then

echo "Configured all user's home directories... "

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

echo "Configured users own their home directories..."

fi

##6.2.13 Ensure users' .netrc Files are not group or world accessible(Automated)##

{
awk -F: '($1!~/(halt|sync|shutdown|nfsnobody)/ &&
$7!~/^(\/usr)?\/sbin\/nologin(\/)?$/ && $7!~/(\/usr)?\/bin\/false(\/)?$/) {
print $6 }' /etc/passwd | while read -r dir; do
 if [ -d "$dir" ]; then
 file="$dir/.netrc"
 [ ! -h "$file" ] && [ -f "$file" ] && rm -f "$file"
fi
done 

echo "Configured users .netrc Files are not group or world accessible..."
}

##6.2.14 Ensure no users have .forward files (Automated)##

{
awk -F: '($1!~/(halt|sync|shutdown|nfsnobody)/ &&
$7!~/^(\/usr)?\/sbin\/nologin(\/)?$/ && $7!~/(\/usr)?\/bin\/false(\/)?$/) {
print $6 }' /etc/passwd | while read -r dir; do
 if [ -d "$dir" ]; then
 file="$dir/.forward"
 [ ! -h "$file" ] && [ -f "$file" ] && rm -r "$file"
 fi
done

echo "Configured no users have .forward files..."
}

##6.2.15 Ensure no users have .netrc files(Automated)##

{
awk -F: '($1!~/(halt|sync|shutdown|nfsnobody)/ &&
$7!~/^(\/usr)?\/sbin\/nologin(\/)?$/ && $7!~/(\/usr)?\/bin\/false(\/)?$/) {
print $6 }' /etc/passwd | while read -r dir; do
 if [ -d "$dir" ]; then
 file="$dir/.netrc"
 [ ! -h "$file" ] && [ -f "$file" ] && rm -f "$file"
 fi
done

echo "Configured no users have .netrc files"
}

##6.2.16 Ensure no users have .rhosts files (Automated)##

{ 
awk -F: '($1!~/(halt|sync|shutdown|nfsnobody)/ &&
$7!~/^(\/usr)?\/sbin\/nologin(\/)?$/ && $7!~/(\/usr)?\/bin\/false(\/)?$/) {
print $6 }' /etc/passwd | while read -r dir; do
 if [ -d "$dir" ]; then
 file="$dir/.rhosts"
 [ ! -h "$file" ] && [ -f "$file" ] && rm -r "$file"
 fi
done

echo -e "Configured no users have .rhosts files..."
}

