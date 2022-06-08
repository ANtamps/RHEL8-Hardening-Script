#!/bin/bask


##1.3.2 Ensure filesystem integrity is regularly checked##
crontab -u root -e
0 5 * * * /usr/sbin/aide --check

#The checking in this recommendation occurs every day at 5am.
