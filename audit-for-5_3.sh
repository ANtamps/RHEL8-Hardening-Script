#!/bin/bash

##5.3.1 Ensure sudo is installed
if rpm -q sudo &> /dev/null; then
 echo -e "sudo installed: \033[1;32mOK\033[0m"
else
  echo -e "sudo not installed: \033[1;31mERROR\033[0m"
fi

##5.3.2 Ensure sudo commands use pty
if grep -rPi '^\h*Defaults\h+([^#\n\r]+,)?use_pty(,\h*\h+\h*)*\h*(#.*)?$' /etc/sudoers* &> /dev/null; then
 echo -e "sudo commands use pty: \033[1;32mOK\033[0m"
else
  echo -e "sudo commands does not use pty: \033[1;31mERROR\033[0m"
fi

##5.3.3 Ensure sudo log file exists
if grep -rPsi "^\h*Defaults\h+([^#]+,\h*)?logfile\h*=\h*(\"|\')?\H+(\"|\')?(,\h*\H+\h*)*\h*(#.*)?$" /etc/sudoers* &> /dev/null; then
 echo -e "sudo log file exists: \033[1;32mOK\033[0m"
else
  echo -e "sudo log file does not exist: \033[1;31mERROR\033[0m"
fi

##5.3.4 Ensure users must provide password for escalation
if grep -r "^[^#].*NOPASSWD" /etc/sudoers* &> /dev/null; then
 echo -e "operating system configured: \033[1;32mOK\033[0m"
else
  echo -e "operating system not configured: \033[1;31mERROR\033[0m"
fi

##5.3.5 Ensure re-authentication for privilege escalation is not disabled globally
if grep -r "^[^#].*\!authenticate" /etc/sudoers* &> /dev/null; then
 echo -e "re-authentication for privilege escalation enabled.: \033[1;32mOK\033[0m"
else
  echo -e "re-authentication for privilege escalation not enabled: \033[1;31mERROR\033[0m"
fi

##5.3.6 Ensure sudo authentication timeout is configured correctly
if grep -roP "timestamp_timeout=\K[0-9]*" /etc/sudoers* &> /dev/null; then
 echo -e "catching timeout is no more than 15 minutes: \033[1;32mOK\033[0m"
else
 echo -e "catching timeout is more than 15 minutes: \033[1;31mERROR\033[0m"
fi

##5.3.7 Ensure access to the su command is restricted
if  grep -Pi '^\h*auth\h+(?:required|requisite)\h+pam_wheel\.so\h+(?:[^#\n\r]+\h+)?((?!\2)(use_uid\b|group=\H+\b))\h+(?:[^#\n\r]+\h+)?((?!\1)(use_uid\b|group=\H+\b))(\h+.*)?$' /etc/pam.d/su &> /dev/null; then
 grep <group_name> /etc/group
 echo -e " access to the su command is restricted: \033[1;32mOK\033[0m"
else
 grep <group_name> /etc/group
 echo -e " access to the su command is not restricted : \033[1;31mERROR\033[0m"
fi


