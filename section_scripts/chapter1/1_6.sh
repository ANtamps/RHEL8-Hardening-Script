#!/bin/bash


# Install SELinux

dnf install libselinux

# Ensure SELinux is not disabled in bootloader configuration

grubby --update-kernel ALL --remove-args 'selinux=0 enforcing=0'

# Check if SELINUXTYPE=targeted, if not set it to targeted

if grep -q "SELINUXTYPE=targeted" /etc/selinux/config; then
	echo "SELINUXTYPE set to targeted, continuing..."
else
	sed 's/SELINUXTYPE/SELINUXTYPE=targeted/g' /etc/selinux/config
fi

# Set SELinux mode to Enforcing

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
	dnf remove setroubleshoot
else
	echo "Setroubleshoot package not found, continuing..."
fi

# Remove mcstrans if installed

if rpm -qa | grep mcstrans; then
	echo "Mcstrans packagr found, removing..."
	dnf remove mcstrans
else
	echo "Mcstrans package not found, continuing..."
fi

