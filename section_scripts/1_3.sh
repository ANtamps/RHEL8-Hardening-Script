#!/bin/bash

##1.3Filesystem Integrity Checking##

##1.3.1 Ensure AIDE is installed##
dnf install aide

##To initialize AIDE##
aide --init
mv /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz

##1.3.2 Ensure filesystem integrity is regularly checked##
crontab -u root -e
0 5 * * * /usr/sbin/aide --check

##The checking in this recommendation occurs every day at 5am.##
