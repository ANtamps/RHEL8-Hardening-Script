#!/bin/bash


##6.1

##6.1.1 Audit system file permissions (Manual)

##6.1.2 Ensure sticky bit is set on all world-writable directories 
if  df --local -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' find '{}' -xdev -type d \( -perm -0002 -a ! -perm -1000 \) 2>/dev/null &> /dev/null; then
    echo -e "Sticky bit is set: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "Sticky bit is not set: \033[1;31mERROR\033[0m"
    echo -e "Sticky bit is not set: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##6.1.3 Ensure permissions on /etc/passwd are configured 
if stat /etc/passwd &> /dev/null; then
    echo -e "Permissions on /etc/passwd configured: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "Permissions on /etc/passwd not configured: \033[1;31mERROR\033[0m"
    echo -e "Permissions on /etc/passwd not configured: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##6.1.4 Ensure permissions on /etc/shadow are configured
if stat /etc/shadow &> /dev/null; then
    echo -e "Permissions on /etc/shadow configured: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "Permissions on /etc/shadow not configured: \033[1;31mERROR\033[0m"
    echo -e "Permissions on /etc/shadow not configured: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##6.1.5 Ensure permissions on /etc/group are configured
if stat /etc/group &> /dev/null; then
    echo -e "Permissions on /etc/group configured: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "Permissions on /etc/group not configured: \033[1;31mERROR\033[0m"
    echo -e "Permissions on /etc/group not configured: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##6.1.6 Ensure permissions on /etc/gshadow are configured
if stat /etc/gshadow &> /dev/null; then
    echo -e "Permissions on /etc/gshadow configured: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "Permissions on /etc/gshadow not configured: \033[1;31mERROR\033[0m"
    echo -e "Permissions on /etc/gshadow not configured: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##6.1.7 Ensure permissions on /etc/passwd- are configured
if stat /etc/passwd- &> /dev/null; then
    echo -e "Permissions on /etc/passwd- configured: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "Permissions on /etc/passwd- not configured: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##6.1.8 Ensure permissions on /etc/shadow- are configured
if stat /etc/shadow- &> /dev/null; then
    echo -e "Permissions on /etc/shadow- configured: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "Permissions on /etc/shadow- not configured: \033[1;31mERROR\033[0m"
    echo -e "Permissions on /etc/shadow- not configured: \033[1;31mERROR\033[0m" >> audit-error.log

##6.1.9 Ensure permissions on /etc/group- are configured
if stat /etc/group- &> /dev/null; then
    echo -e "Permissions on /etc/group- configured: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "Permissions on /etc/group- not configured: \033[1;31mERROR\033[0m"
    echo -e "Permissions on /etc/group- not configured: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##6.1.10 Ensure permissions on /etc/gshadow- are configured 
if stat /etc/gshadow- &> /dev/null; then
    echo -e "Permissions on /etc/gshadow-- configured: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "Permissions on /etc/gshadow- not configured: \033[1;31mERROR\033[0m"
    echo -e "Permissions on /etc/gshadow- not configured: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##6.1.11 Ensure no world writable files exist

##6.1.12 Ensure no unowned files or directories exist

##6.1.13 Ensure no ungrouped files or directories exist

##6.1.14 Audit SUID executables (Manual)

##6.1.15 Audit SGID executables (Manual)


printf "Finished auditing with score: $COUNTER/12 \n"


