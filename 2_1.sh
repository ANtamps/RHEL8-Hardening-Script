#!/bin/bash
##2.1 Time Synchronization##
##2.1.1 Ensure time synchronization is in use##

if  rpm -qa | grep -q "chrony"; then
	echo "CHRONY already installed"
else
	echo "CHRONY not installed, installing.."
	dnf install chrony
fi

