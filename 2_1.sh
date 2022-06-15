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

	echo "Remote server is already configured... Continuing..."

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
