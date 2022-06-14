#!/bin/bash

##1.2.3 Ensure gpgcheck is globally activated (Automated)##
sed -i 's/^gpgcheck\s*=\s*.*/gpgcheck=1/' /etc/dnf/dnf.conf


##1.3Filesystem Integrity Checking##

##1.3.1 Ensure AIDE is installed##
if  rpm -qa | grep -q "aide"; then
	echo "AIDE already installed"
else
	echo "AIDE not installed, installing.."
	dnf install aide
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
