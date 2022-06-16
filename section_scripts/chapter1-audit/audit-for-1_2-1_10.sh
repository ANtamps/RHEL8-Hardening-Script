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
