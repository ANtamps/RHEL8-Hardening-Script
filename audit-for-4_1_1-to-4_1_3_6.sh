#!/bin/bash


##4.1.1.1 Ensure auditd is installed
if rpm -q audit &> /dev/null; then
   echo -e "audit installed: \033[1;32mOK\033[0m"
else   
  echo -e "audit not found: \033[1;31mERROR\033[0m"
fi


##4.1.1.2 Ensure auditd service is enabled
if systemctl is-enabled auditd &> /dev/null; then
   echo -e "audit is enabled: \033[1;32mOK\033[0m"
else   
  echo -e "audit not enabled: \033[1;31mERROR\033[0m"
fi

##4.1.1.3 Ensure auditing for processes that start prior to auditd is enabled
if find /boot -type f -name 'grubenv' -exec grep -P 'kernelopts=([^#\n\r]+\h+)?(audit=1)' {} \; &> /dev/null; then
   echo -e "audit=1 found: \033[1;32mOK\033[0m"
else   
  echo -e "audit=1 not found: \033[1;31mERROR\033[0m"
fi

##4.1.1.4 Ensure audit_backlog_limit is sufficient 
if find /boot -type f -name 'grubenv' -exec grep -P 'kernelopts=([^#\n\r]+\h+)?(audit_backlog_limit=\S+\b)' {} \; &> /dev/null; then
   echo -e "limit value is sufficient: \033[1;32mOK\033[0m"
else   
  echo -e "limit value is not sufficient: \033[1;31mERROR\033[0m"
fi

##4.1.2.1 Ensure audit log storage size is configured 
if grep -w "^\s*max_log_file\s*=" /etc/audit/auditd.conf &> /dev/null; then
   echo -e "audit storage size configured: \033[1;32mOK\033[0m"
else   
  echo -e "audit storage size not configured: \033[1;31mERROR\033[0m"
fi

##4.1.2.2 Ensure audit logs are not automatically deleted
if grep max_log_file_action /etc/audit/auditd.conf &> /dev/null; then
   echo -e "logs not automatically deleted: \033[1;32mOK\033[0m"
else   
  echo -e "logs automatically deleted: \033[1;31mERROR\033[0m"
fi

##4.1.2.3 Ensure system is disabled when audit logs are full 
if grep space_left_action /etc/audit/auditd.conf &> /dev/null; then
   echo -e "space_left_action = email: \033[1;32mOK\033[0m"
else   
  echo -e "space_left_action = unknown: \033[1;31mERROR\033[0m"
fi

if grep action_mail_acct /etc/audit/auditd.conf &> /dev/null; then
   echo -e "action_mail_acct = root: \033[1;32mOK\033[0m"
else   
  echo -e "action_mail_acct = unknown: \033[1;31mERROR\033[0m"
fi

##4.1.3.1 Ensure changes to system administration scope (sudoers) is collected
if awk '/^ *-w/ \ &> /dev/null; then
   echo -e "System administrator scope is set: \033[1;32mOK\033[0m"
else   
  echo -e "System administrator scope is not set: \033[1;31mERROR\033[0m"
fi

if auditctl -l | awk '/^ *-w/ \ &> /dev/null; then
   echo -e "Rules loaded: \033[1;32mOK\033[0m"
else   
  echo -e "Rules not loaded: \033[1;31mERROR\033[0m"
fi

##4.1.3.2 Ensure actions as another user are always logged
if awk '/^ *-a *always,exit/ \ &> /dev/null; then
   echo -e "User emulation rules set: \033[1;32mOK\033[0m"
else   
  echo -e "User emulation rules is not set: \033[1;31mERROR\033[0m"
fi

if auditctl -l | awk '/^ *-a *always,exit/ \ &> /dev/null; then
   echo -e "Rules loaded: \033[1;32mOK\033[0m"
else   
  echo -e "Rules not loaded: \033[1;31mERROR\033[0m"
fi

