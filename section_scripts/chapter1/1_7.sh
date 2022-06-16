#!/bin/bash

##1.7 Command Line Warning Banners##

##1.7.1 Ensure message of the day is configured properly##
rm /etc/motd

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

