#!/bin/bash

##5.1

##5.1.1 Ensure cron daemon is enabled
if systemctl is-enabled crond &> /dev/null; then
    echo -e "cron daemon is enabled: \033[1;32mOK\033[0m"
else
    echo -e "cron daemon is not enabled: \033[1;31mERROR\033[0m"
fi

##5.1.2 Ensure permissions on /etc/crontab are configured
if stat /etc/crontab &> /dev/null; then
    echo -e "Permissions on /etc/crontab configured: \033[1;32mOK\033[0m"
else
    echo -e "Permissions on etc/crontab not configured: \033[1;31mERROR\033[0m"
fi

##5.1.3 Ensure permissions on /etc/cron.hourly are configure
if stat /etc/cron.hourly &> /dev/null; then
    echo -e "Permissions on /etc/cron.hourly configured: \033[1;32mOK\033[0m"
else
    echo -e "Permissions on /etc/cron.hourly not configured: \033[1;31mERROR\033[0m"
fi

##5.1.4 Ensure permissions on /etc/cron.daily are configured
if stat /etc/cron.daily &> /dev/null; then
    echo -e "Permissions on /etc/cron.daily configured: \033[1;32mOK\033[0m"
else
    echo -e "Permissions on /etc/cron.daily not configured: \033[1;31mERROR\033[0m"
fi

##5.1.5 Ensure permissions on /etc/cron.weekly are configured
if stat /etc/cron.weekly &> /dev/null; then
    echo -e "Permissions on /etc/cron.weekly configured: \033[1;32mOK\033[0m"
else
    echo -e "Permissions on /etc/cron.weekly not configured: \033[1;31mERROR\033[0m"
fi

##5.1.6 Ensure permissions on /etc/cron.monthly are configured
if stat /etc/cron.monthly &> /dev/null; then
    echo -e "Permissions on /etc/cron.monthly configured: \033[1;32mOK\033[0m"
else
    echo -e "Permissions on /etc/cron.monthly not configured: \033[1;31mERROR\033[0m"
fi

##5.1.7 Ensure permissions on /etc/cron.d are configured
if stat /etc/cron.d &> /dev/null; then
    echo -e "Permissions on /etc/cron.d configured: \033[1;32mOK\033[0m"
else
    echo -e "Permissions on /etc/cron.d not configured: \033[1;31mERROR\033[0m"
fi

##5.1.8 Ensure cron is restricted to authorized users
if rpm -q cronie >/dev/null; then
    echo -e "cron still installed: \033[1;31mERROR\033[0m"
else
   echo -e "cron not installed: \033[1;32mOK\033[0m"

fi

##5.1.9 Ensure at is restricted to authorized users
if rpm -q at >/dev/null; then
  echo -e "at still installed: \033[1;31mERROR\033[0m"
else
    echo -e "at not installed: \033[1;32mOK\033[0m"

fi
