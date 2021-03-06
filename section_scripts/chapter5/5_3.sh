#!/bin/bash

##5.3

##5.3.1 Ensure sudo is installed
if rpm -q sudo &> /dev/null; then
    dnf list sudo
    echo "sudo installed, continuing..."
else   
    echo "sudo not found, installing..."
     dnf -y install sudo &> /dev/null
     dnf list sudo
fi

##5.3.2 Ensure sudo commands use pty
if grep -q "/etc/suduoers:Defaults use_pty" /etc/suduoers; then

echo "pty is in use, continuing.."

else
echo -e "/etc/suduoers:Defaults use_pty" >>/etc/suduoers

fi

##5.3.3 Ensure sudo log file exists
if grep -q "Defaults logfile=/var/log/sudo.log" /etc/suduoers; then

echo "sudo log file exists.."

else
echo -e "Defaults logfile=/var/log/sudo.log" >>/etc/suduoers

fi
 
##5.3.4 Ensure users must provide password for escalation
if grep -q "NOPASSWD" /etc/suduoers; then

echo -e "NOPASSWD still exists, removing.."
   sed '/NOPASSWD/d' /etc/suduoers

else
  sed '/NOPASSWD/d' /etc/suduoers
echo -e "NOPASSWD removed from the lines, continuing.."

fi

##5.3.5 Ensure re-authentication for privilege escalation is not disabled globally
if grep -q "!authenticate" /etc/suduoers; then

echo -e "!authenticate still exists, removing.."
  sed '/!authenticate/d' /etc/suduoers
   
else
  sed '/!authenticate/d' /etc/suduoers
echo -e "!authenticate  removed from the lines, continuing.."

fi

##5.3.6 Ensure sudo authentication timeout is configured correctly
sed -i 's/Defaults    env_reset/Defaults    env_reset, timestamp_timeout=15/g' /etc/suduoers
echo -e "sudo authentication timeout is configured correctly, continuing.."

##5.3.7 Ensure access to the su command is restricted
if grep sugroup /etc/group; then
groupadd sugroup
echo "empty group added, continuing"

else
echo "empty group does not exist, adding.."
groupadd sugroup

fi
