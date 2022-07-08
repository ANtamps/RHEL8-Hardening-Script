#!/bin/bash

##5.3.1 Ensure sudo is installed
if rpm -q sudo &> /dev/null; then
 echo -e "sudo installed: \033[1;32mOK\033[0m"
else
  echo -e "sudo not installed: \033[1;31mERROR\033[0m"
fi

##5.3.2 Ensure sudo commands use pty
if grep /etc/sudoers /etc/sudoers &> /dev/null; then
 echo -e "sudo commands use pty: \033[1;32mOK\033[0m"
else
  echo -e "sudo commands does not use pty: \033[1;31mERROR\033[0m"
fi

##5.3.3 Ensure sudo log file exists
if grep -q "Defaults logfile=/var/log/sudo.log" /etc/suduoers; then

echo -e "sudo log file exists: \033[1;32mOK\033[0m"

else
echo -e "sudo log file does not exist: \033[1;31mERROR\033[0m"

fi

##5.3.4 Ensure users must provide password for escalation
if grep -q "NOPASSWD" /etc/suduoers; then

echo -e "NOPASSWD does exist: \033[1;31mERROR\033[0m"
   
else
echo -e "NOPASSWD does not exist: \033[1;32mOK\033[0m" 

fi

##5.3.5 Ensure re-authentication for privilege escalation is not disabled globally
if grep -q "!authenticate" /etc/suduoers; then

echo -e "!authenticate does exist: \033[1;31mERROR\033[0m"
   
else
echo -e "!authenticate does not exist: \033[1;32mOK\033[0m" 

fi

##5.3.6 Ensure sudo authentication timeout is configured correctly
if grep -roP "timestamp_timeout=\K[0-9]*"  /etc/group; then
echo -e  "authentication timeout is not configured: \033[1;31mERROR\033[0m"

else
echo -e "authentication timeout is configured: \033[1;32mOK\033[0m"


fi 

##5.3.7 Ensure access to the su command is restricted
if grep sugroup /etc/group; then
echo -e "empty group added: \033[1;32mOK\033[0m"

else
echo -e "empty group not found: \033[1;31mERROR\033[0m"

fi
