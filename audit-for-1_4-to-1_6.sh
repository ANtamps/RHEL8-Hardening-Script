#!/bin/bash

if grep "set superusers" /boot/grub2/grub.cfg &> /dev/null; then
    echo -e "Superuser is set: \033[1;32mOK\033[0m"
else
    echo -e "Superuser is not set! \033[1;31mERROR\033[0m"
fi

if grep "password" /boot/grub2/grub.cfg &> /dev/null; then 
    echo -e "Grub2 password is set: \033[1;32mOK\033[0m"
else
    echo -e "Grub2 password not set! \033[1;31mERROR\033[0m"
fi

if grep -r /systemd-sulogin-shell &> /dev/null || grep -r /usr/lib/systemd/system/rescue.service &> /dev/null || grep -r /etc/systemd/system/rescue.service.d &> /dev/null; then
    echo -e "Authentication in rescue mode set: \033[1;32mOK\033[0m"
else
    echo "Authentication in rescue mode not set!"
fi

if grep -i '^\s*storage\s*=\s*none' /etc/systemd/coredump.conf &> /dev/null; then
    echo -e "Coredump storage equal to none: \033[1;32mOK\033[0m"
else
    echo "Coredump not set to none!"
fi

if grep -i '^\s*ProcessSizeMax\s*=\s*0' /etc/systemd/coredump.conf &> /dev/null; then
    echo -e "Coredump ProcessSizeMax equal to 0: \033[1;32mOK\033[0m"
else
    echo "Coredump ProcessSizeMax not equal to 0!"
fi

if sysctl kernel.randomize_va_space -eq 2 &> /dev/null; then
    echo -e "Kernerl randomize va space set to 2: \033[1;32mOK\033[0m"
else
    echo "Kernel randomize va space not set to 2!"
fi

if rpm -q libselinux &> /dev/null; then
    echo -e "Libselinux is installed: \033[1;32mOK\033[0m"
else
    echo "Libselinux not installed!"
fi

if ! grep "^\s*linux" /boot/grub2/grub.cfg &> /dev/null; then
    echo -e "SELinux is enabled at boot time: \033[1;32mOK\033[0m"
else   
    echo "SELinux not enabled at boot time!"
fi

if grep SELINUXTYPE=targeted /etc/selinux/config &> /dev/null; then
    echo -e "SELINUXTYPE set to targeted: \033[1;32mOK\033[0m"
else
    echo "SELINUXTYPE not set to targeted!"
fi

if grep SELINUX=enforcing /etc/selinux/config &> /dev/null; then
    echo -e "SELINUX set to enforcing: \033[1;32mOK\033[0m"
else   
    echo "SELINUX not set to enforcing!"
fi

if ! ps -eZ | grep unconfined_service_t &> /dev/null; then
    echo -e "unconfined_service_t not running: \033[1;32mOK\033[0m"
else
    echo "unconfined_service_t is running!"
fi

if ! rpm -q setroubleshoot &> /dev/null; then
    echo -e "setroubleshoot not installed: \033[1;32mOK\033[0m"
else
    echo "setroubleshoot is installed!"
fi

if ! rpm -q mcstrans &> /dev/null; then
    echo -e "mcstrans not installed: \033[1;32mOK\033[0m"
else
    echo "mcstrans is installed!"
fi
