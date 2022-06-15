#!/bin/bash

if grep "set superusers" /boot/grub2/grub.cfg &> /dev/null; then
    echo "Superuser is set: \033[1;32mOK\033[0m"
else
    echo "Superuser is not set! \033[1;31mERROR\033[0m"
fi

if grep "password" /boot/grub2/grub.cfg &> /dev/null; then 
    echo "Grub2 password is set: \033[1;32mOK\033[0m"
else
    echo "Grub2 password not set! \033[1;31mERROR\033[0m"
fi

if grep -r /systemd-sulogin-shell || grep -r /usr/lib/systemd/system/rescue.service || grep -r /etc/systemd/system/rescue.service.d; then
    echo "Authentication in rescue mode set: "
else
    echo "Authentication in rescue mode not set!"
fi

if grep -i '^\s*storage\s*=\s*none' /etc/systemd/coredump.conf &> /dev/null; then
    echo "Coredump storage equal to none: "
else
    echo "Coredump not set to none!"
fi

if grep -i '^\s*ProcessSizeMax\s*=\s*0' /etc/systemd/coredump.conf &> /dev/null; then
    echo "Coredump ProcessSizeMax equal to 0:"
else
    echo "Coredump ProcessSizeMax not equal to 0!"
fi

if sysctl kernel.randomize_va_space -eq 2 &> /dev/null; then
    echo "Kernerl randomize va space set to 2: "
else
    echo "Kernel randomize va space not set to 2!"
fi

if rpm -q libselinux &> /dev/null; then
    echo "Libselinux is installed: "
else
    echo "Libselinux not installed!"
fi

if grep "^\s*linux" /boot/grub2/grub.cfg &> /dev/null; then
    echo "SELinux is enabled at boot time:"
else   
    echo "SELinux not enabled at boot time!"
fi

if grep SELINUXTYPE=targeted /etc/selinux/config &> /dev/null; then
    echo "SELINUXTYPE set to targeted: "
else
    echo "SELINUXTYPE not set to targeted!"
fi

if grep SELINUX=enforcing &> /dev/null; then
    echo "SELINUX set to enforcing:"
else   
    echo "SELINUX not set to enforcing!"
fi

if ps -eZ | grep unconfined_service_t &> /dev/null; then
    echo "unconfined_service_t not running:"
else
    echo "unconfined_service_t is running!"
fi

if ! rpm -q setroubleshoot &> /dev/null; then
    echo "setroubleshoot not installed:"
else
    echo "setroubleshoot is installed!"
fi

if ! rpm -q mcstrans &> /dev/null; then
    echo "mcstrans not installed:"
else
    echo "mcstrans is installed!"
fi
