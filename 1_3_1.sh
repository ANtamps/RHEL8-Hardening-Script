#!/bin/bash

##1.3Filesystem Integrity Checking##
##1.3.1 Ensure AIDE is installed##
dnf install aide
##To initialize AIDE##
aide --init
mv /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz
