#!/bin/bash

##5.1 

##5.1.1 Ensure cron daemon is enabled 
 if  systemctl is-enabled crond &> /dev/null; then
    echo "cron daemon already enabled, continuing..."
else   
    echo "cron daemon not found, enabling..."
    systemctl --now enable crond
fi

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
dnf remove cronie

##5.1.9 Ensure at is restricted to authorized users
dnf remove at

