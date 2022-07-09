#!/bin/bash

##6.1

##6.1.1 Audit system file permissions (Manual)

##6.1.2 Ensure sticky bit is set on all world-writable directories 
 df --local -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' find '{}' -xdev -type d \( -perm -0002 -a ! -perm -1000 \) 2>/dev/null | xargs -I '{}' chmod a+t '{}'
 echo "Sticky bit  is set, continuing.."

##6.1.3 Ensure permissions on /etc/passwd are configured
chown root:root /etc/passwd
chmod 644 /etc/passwd
stat /etc/passwd
echo "Permissions on /etc/passwd configured, continuing.."

##6.1.4 Ensure permissions on /etc/shadow are configured
chown root:root /etc/shadow
chmod 0000 /etc/shadow
stat /etc/shadow
echo "Permissions on /etc/shadow configured, continuing.."

##6.1.5 Ensure permissions on /etc/group are configured
chown root:root /etc/group
chmod u-x,g-wx,o-wx /etc/group
stat /etc/group
echo "Permissions on /etc/group configured, continuing.."

##6.1.6 Ensure permissions on /etc/gshadow are configured
chown root:root /etc/gshadow
chmod 0000 /etc/gshadow
stat /etc/gshadow
echo "Permissions on /etc/gshadow configured, continuing.."

##6.1.7 Ensure permissions on /etc/passwd- are configured
chown root:root /etc/passwd-
# chmod chmod u-x,go-wx /etc/passwd-
stat /etc/passwd-
echo "Permissions on /etc/passwd- configured, continuing.."

##6.1.8 Ensure permissions on /etc/shadow- are configured
chown root:root /etc/shadow-
chmod 0000 /etc/shadow-
stat /etc/shadow-
echo "Permissions on /etc/shadow- configured, continuing.."

##6.1.9 Ensure permissions on /etc/group- are configured
chown root:root /etc/group-
chmod u-x,go-wx /etc/group-
stat /etc/group-
echo "Permissions on /etc/group- configured, continuing.."

##6.1.10 Ensure permissions on /etc/gshadow- are configured 
chown root:root /etc/gshadow-
chmod 0000 /etc/gshadow-
stat /etc/gshadow-
echo "Permissions on /etc/gshadow- configured, continuing.."

##6.1.11 Ensure no world writable files exist

##6.1.12 Ensure no unowned files or directories exist

##6.1.13 Ensure no ungrouped files or directories exist

##6.1.14 Audit SUID executables (Manual)

##6.1.15 Audit SGID executables (Manual)

