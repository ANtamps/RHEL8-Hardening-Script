#!/bin/bash

##4.1.1.1 Ensure auditd is installed
if rpm -q audit &> /dev/null; then
    echo "auditd already installed, continuing..."
else   
    echo "ip tables not found, installing..."
    dnf -y install audit &> /dev/null
fi

##4.1.1.2 Ensure auditd service is enabled
if  systemctl is-enabled auditd &> /dev/null; then
    echo "auditd already enabled, continuing..."
else   
    echo "auditd not enabled, configuring..."
    systemctl --now enable auditd &> /dev/null
fi

##4.1.1.3 Ensure auditing for processes that start prior to auditd is enabled
grubby --update-kernel ALL --args 'audit=1'

##4.1.1.4 Ensure audit_backlog_limit is sufficient
grubby --update-kernel ALL --args 'audit_backlog_limit=8192'

##4.1.2.1 Ensure audit log storage size is configured
sed -i 's/max_log_file = 8/max_log_file= 20/g' /etc/audit/auditd.conf
grep -w "^\s*max_log_file\s*=" /etc/audit/auditd.conf


##4.1.2.2 Ensure audit logs are not automatically deleted
sed -i 's/max_log_file_action = ROTATE/max_log_file_action = keep_logs/g' /etc/audit/auditd.conf
 grep max_log_file_action /etc/audit/auditd.conf


##4.1.2.3 Ensure system is disabled when audit logs are full 
sed -i 's/space_left_action = SYSLOG/space_left_action = email/g' /etc/audit/auditd.conf
grep space_left_action /etc/audit/auditd.conf
grep action_mail_acct /etc/audit/auditd.conf
