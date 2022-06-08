#!/bin/bash

##For 1.8##
##1.8.2 Ensure GDM login banner is configured (Automated)##
user-db:user
system-db:gdm
file-db:/usr/share/gdm/greeter-dconf-defaults
[org/gnome/login-screen]
banner-message-enable=true
banner-message-text='<banner message>'
dconf update
##1.8.3 Ensure last logged in user display is disabled (Automated)##
user-db:user
system-db:gdm
file-db:/usr/share/gdm/greeter-dconf-defaults
[org/gnome/login-screen]
# Do not show the user list
disable-user-list=true
dconf update
##1.8.4 Ensure XDMCP is not enabled (Automated)##
sed '/Enable=true/d'/etc/gdm/custom.conf
##1.8.5 Ensure automatic mounting of removable media is disabled (Automated)##
cat << EOF >> /etc/dconf/db/local.d/00-media-automount
[org/gnome/desktop/media-handling]
automount=false
automount-open=false
EOF
dconf update
##1.10 Ensure system-wide crypto policy is not legacy (Automated)#
update-crypto-policies --set DEFAULT
update-crypto-policies
