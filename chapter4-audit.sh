#!/bin/bash

COUNTER=0

##4.1.1.1 Ensure auditd is installed
if rpm -q audit &> /dev/null; then
   echo -e "audit installed: \033[1;32mOK\033[0m"
   let COUNTER++
else   
  echo -e "audit not found: \033[1;31mERROR\033[0m"
fi


##4.1.1.2 Ensure auditd service is enabled
if systemctl is-enabled auditd &> /dev/null; then
   echo -e "audit is enabled: \033[1;32mOK\033[0m"
   let COUNTER++
else   
  echo -e "audit not enabled: \033[1;31mERROR\033[0m"
fi

##4.1.1.3 Ensure auditing for processes that start prior to auditd is enabled
if find /boot -type f -name 'grubenv' -exec grep -P 'kernelopts=([^#\n\r]+\h+)?(audit=1)' {} \; &> /dev/null; then
   echo -e "audit=1 found: \033[1;32mOK\033[0m"
   let COUNTER++
else   
  echo -e "audit=1 not found: \033[1;31mERROR\033[0m"
fi

##4.1.1.4 Ensure audit_backlog_limit is sufficient 
if find /boot -type f -name 'grubenv' -exec grep -P 'kernelopts=([^#\n\r]+\h+)?(audit_backlog_limit=\S+\b)' {} \; &> /dev/null; then
   echo -e "limit value is sufficient: \033[1;32mOK\033[0m"
   let COUNTER++
else   
  echo -e "limit value is not sufficient: \033[1;31mERROR\033[0m"
fi

##4.1.2.1 Ensure audit log storage size is configured 
if grep -w "^\s*max_log_file\s*=" /etc/audit/auditd.conf &> /dev/null; then
   echo -e "audit storage size configured: \033[1;32mOK\033[0m"
   let COUNTER++
else   
  echo -e "audit storage size not configured: \033[1;31mERROR\033[0m"
fi

##4.1.2.2 Ensure audit logs are not automatically deleted
if grep max_log_file_action /etc/audit/auditd.conf &> /dev/null; then
   echo -e "logs not automatically deleted: \033[1;32mOK\033[0m"
   let COUNTER++
else   
  echo -e "logs automatically deleted: \033[1;31mERROR\033[0m"
fi

##4.1.2.3 Ensure system is disabled when audit logs are full 
if grep space_left_action /etc/audit/auditd.conf &> /dev/null; then
   echo -e "space_left_action = email: \033[1;32mOK\033[0m"
   let COUNTER++
else   
  echo -e "space_left_action = unknown: \033[1;31mERROR\033[0m"
fi

if grep action_mail_acct /etc/audit/auditd.conf &> /dev/null; then
   echo -e "action_mail_acct = root: \033[1;32mOK\033[0m"
   let COUNTER++
else   
  echo -e "action_mail_acct = unknown: \033[1;31mERROR\033[0m"
fi

##4.1.3.1 Ensure changes to system administration scope (sudoers) is collected
if [ $(grep -c scope /etc/audit/rules.d/50-scope.rules) -eq 2]; then
	echo -e "aDMINISTRATION: \033[1;32mOK\033[0m"
    let COUNTER++
else
	echo -e "does not exist: \033[1;31mERROR\033[0m"
fi

if [$(auditctl -l | grep -c scope) -eq 2]; then
	echo -e "Successful in setting system administration scope: \033[1;32mOK\033[0m"
    let COUNTER++
else
	echo -e "Unuccessful in setting system administration scope: \033[1;31mERROR\033[0m"
fi

##4.1.3.2 Ensure actions as another user are always logged
if [ $(grep -c user_emulation /etc/audit/rules.d/50-user_emulation.rules) -eq 2]; then
	echo -e "exists: \033[1;32mOK\033[0m"
    let COUNTER++
else
	echo -e "does not exist: \033[1;31mERROR\033[0m"
fi

if [$(auditctl -l | grep -c user_emulation) -eq 2]; then
	echo -e "Successful in setting emulation rules: \033[1;32mOK\033[0m"
    let COUNTER++
else
	echo -e "Unuccessful in setting emulation rules: \033[1;31mERROR\033[0m"
fi

##4.1.3.3 Ensure events that modify the sudo log file are collected
if [ $(grep -c sudo_log_file /etc/audit/rules.d/50-sudo.rules) -eq 1]; then
	echo -e "exists: \033[1;32mOK\033[0m"
    let COUNTER++
else
	echo -e "does not exist: \033[1;31mERROR\033[0m"
fi

if [$(auditctl -l | grep -c sudo_log_file) -eq 1]; then
	echo -e "Successful in modifying sudo log files: \033[1;32mOK\033[0m"
    let COUNTER++
else
	echo -e "Unuccessful in modifying sudo log files: \033[1;31mERROR\033[0m"
fi

##4.1.3.4 Ensure events that modify date and time information are collected
if [ $(grep -c time-change /etc/audit/rules.d/50-time-change.rules) -eq 3]; then
	echo -e "exists: \033[1;32mOK\033[0m"
    let COUNTER++
else
	echo -e "does not exist: \033[1;31mERROR\033[0m"
fi

if [$(auditctl -l | grep -c time-change) -eq 3]; then
	echo -e "Successful in modifying system dates: \033[1;32mOK\033[0m"
    let COUNTER++
else
	echo -e "Unuccessful in modifying system dates: \033[1;31mERROR\033[0m"
fi

##4.1.3.5 Ensure events that modify the system's network environment are collected
if [ $(grep -c system-locale /etc/audit/rules.d/50-system_local.rules) -eq 7]; then
	echo -e "exists: \033[1;32mOK\033[0m"
    let COUNTER++
else
	echo -e "does not exist: \033[1;31mERROR\033[0m"
fi

if [$(auditctl -l | grep -c system-locale) -eq 7]; then
	echo -e "Successful in setting system local rules: \033[1;32mOK\033[0m"
    let COUNTER++
else
	echo -e "Unuccessful in setting system local rules: \033[1;31mERROR\033[0m"
fi

if [ $(grep -c access /etc/audit/rules.d/50-access.rules) -eq 4 ]; then
    echo "Access rules for file systems set on disk config: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo "Access rules for file systems not set on disk config: \033[1;31mERROR\033[0m"
fi

if [ $(auditctl -l | grep -c access) -eq 4 ]; then
    echo "Access rules for file systems set on running config: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo "Access rules for file systems not set on running config: \033[1;31mERROR\033[0m"
fi

# 4.1.3.8 

if [ $(grep -c identity /etc/audit/rules.d/50-identity.rules) -eq 5 ]; then
    echo "User/Group info modification events set on disk config: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo "User/Group info modification events not set on disk config: \033[1;31mERROR\033[0m"
fi

if [ $(auditctl -l | grep -c identity) -eq 5 ]; then
    echo "User/Group info modification events set on running config: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo "User/Group info modification events not set on running config: \033[1;31mERROR\033[0m"
fi

# 4.1.3.9

if [ $(grep -c perm_mod /etc/audit/rules.d/50-perm_mod.rules) -eq 6 ]; then
    echo "Permission modification events set on disk config: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo "Permission modification events not set on disk config: \033[1;31mERROR\033[0m"
fi

if [ $(auditctl -l | grep -c perm_mod) -eq 6 ]; then
    echo "Permission modification events set on running config: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo "Permission modification events not set on running config: \033[1;31mERROR\033[0m"
fi

# 4.1.3.10

if [ $(grep -c mounts /etc/audit/rules.d/50-perm_mod.rules) -eq 2 ]; then
    echo "Successful file system mounts events set on disk config: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo "Successful file system mounts events not set on disk config: \033[1;31mERROR\033[0m"
fi

if [ $(auditctl -l | grep -c mounts) -eq 2 ]; then
    echo "Successful file system mounts events set on running config: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo "Successful file system mounts events not set on running config: \033[1;31mERROR\033[0m"
fi

# 4.1.3.11

if [ $(grep -c session /etc/audit/rules.d/50-session.rules) -eq 3 ]; then
    echo "Session initiation information set on disk config: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo "Session initiation information not set on disk config: \033[1;31mERROR\033[0m"
fi

if [ $(auditctl -l | grep -c session) -eq 3 ]; then
    echo "Session initiation information set on running config: \033[1;32mOK\033[0m"
else
    echo "Session initiation information not set on running config: \033[1;31mERROR\033[0m"
fi

# 4.1.3.12

if [ $(grep -c logins /etc/audit/rules.d/50-login.rules) -eq 2 ]; then
    echo "Login and logout events set on disk config: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo "Login and logout events not set on disk config: \033[1;31mERROR\033[0m"
fi

if [ $(auditctl -l | grep -c logins) -eq 2 ]; then
    echo "Login and logout events set on running config: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo "Login and logout events not set on running config: \033[1;31mERROR\033[0m"
fi

# 4.1.3.13

if [ $(grep -c delete /etc/audit/rules.d/50-delete.rules) -eq 2 ]; then
    echo "File deletion events set on disk config: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo "File deletion events not set on disk config: \033[1;31mERROR\033[0m"
fi

if [ $(auditctl -l | grep -c delete) -eq 2 ]; then
    echo "File deletion events set on running config: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo "File deletion events not set on running config: \033[1;31mERROR\033[0m"
fi

# 4.1.3.14

if [ $(grep -c MAC-policy /etc/audit/rules.d/50-MAC-policy.rules) -eq 2 ]; then
    echo "MAC system modification events set on disk config: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo "MAC system modification events not set on disk config: \033[1;31mERROR\033[0m"
fi

if [ $(auditctl -l | grep -c MAC-policy) -eq 2 ]; then
    echo "MAC system modification events set on running config: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo "MAC system modification events not set on running config: \033[1;31mERROR\033[0m"
fi

# 4.1.3.15

if [ $(grep -c path=/usr/bin/chcon /etc/audit/rules.d/50-perm_chng.rules) -eq 1 ]; then
    echo "Unsuccessful chcon events set on disk config: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo "Unsuccessful chcon events not set on disk config: \033[1;31mERROR\033[0m"
fi

if [ $(auditctl -l | grep -c path=/usr/bin/chcon) -eq 1 ]; then
    echo "Unsuccessful chcon events set on running config: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo "Unsuccessful chcon events not set on running config: \033[1;31mERROR\033[0m"
fi

# 4.1.3.16

if [ $(grep -c path=/usr/bin/setfacl /etc/audit/rules.d/50-priv_cmd.rules) -eq 1 ]; then
    echo "Unsuccessful setfacl events set on disk config: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo "Unsuccessful setfacl events not set on disk config: \033[1;31mERROR\033[0m"
fi

if [ $(auditctl -l | grep -c path=/usr/bin/setfacl) -eq 1 ]; then
    echo "Unsuccessful setfacl events set on running config: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo "Unsuccessful setfacl events not set on running config: \033[1;31mERROR\033[0m"
fi

# 4.1.3.17

if [ $(grep -c path=/usr/bin/chacl /etc/audit/rules.d/50-perm_chng.rules) -eq 1 ]; then
    echo "Unsuccessful chacl events set on disk config: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo "Unsuccessful chacl events not set on disk config: \033[1;31mERROR\033[0m"
fi

if [ $(auditctl -l | grep -c path=/usr/bin/chacl) -eq 1 ]; then
    echo "Unsuccessful chacl events set on running config: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo "Unsuccessful chacl events not set on running config: \033[1;31mERROR\033[0m"
fi

# 4.1.3.18

if [ $(grep -c usermod /etc/audit/rules.d/50-usermod.rules) -eq 1 ]; then
    echo "Unsuccessful chacl events set on disk config: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo "Unsuccessful chacl events not set on disk config: \033[1;31mERROR\033[0m"
fi

if [ $(auditctl -l | grep -c usermod) -eq 1 ]; then
    echo "Unsuccessful chacl events set on running config: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo "Unsuccessful chacl events not set on running config: \033[1;31mERROR\033[0m"
fi

# 4.1.3.19

if [ $(grep -c kernel_modules /etc/audit/rules.d/50-kernel_modules.rules) -eq 2 ]; then
    echo "Unsuccessful chacl events set on disk config: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo "Unsuccessful chacl events not set on disk config: \033[1;31mERROR\033[0m"
fi

if [ $(auditctl -l | grep -c kernel_modules) -eq 2 ]; then
    echo "Unsuccessful chacl events set on running config: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo "Unsuccessful chacl events not set on running config: \033[1;31mERROR\033[0m"
fi

# 4.1.3.20

if [ "$(grep "-e 2" /etc/audit/rules.d/*.rules | tail -1 | cut -d ':' -f 2)" = "-e 2" ]; then
    echo "Audit configuration set to immutable: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo "Audit configuration not set to immutable: \033[1;31mERROR\033[0m"
fi

##4.2.1.1 Ensure rsyslog is installed (Automated)##
if rpm -q rsyslog &> /dev/null; then
	echo -e "rsyslog is installed: \033[1;32mOK\033[0m"
    let COUNTER++
else
	echo -e "rsyslog is not installed: \033[1;31mERROR\033[0m"
fi

##4.2.1.2 Ensure rsyslog service is enabled (Automated)##
if systemctl is-enabled rsyslog &> /dev/null; then
	echo -e "rsyslog service is enabled: \033[1;32mOK\033[0m"
    let COUNTER++
else
	echo -e "rsyslog service is not enabled: \033[1;31mERROR\033[0m"
fi

##4.2.1.4 Ensure rsyslog default file permissions are configured(Automated)##

if test -f /etc/rsyslog.conf; then
	
	if grep ^\$FileCreateMode /etc/rsyslog.conf &> /dev/null; then
	echo -e "rsyslog default file permissions are configured: \033[1;32mOK\033[0m"
    let COUNTER++
	else 
	echo -e "rsyslog default file permissions are not configured: \033[1;31mERROR\033[0m"
	fi 

else
	echo -e "rsyslog default file permissions are not configured: \033[1;31mERROR\033[0m"
fi

##4.2.1.7 Ensure rsyslog is not configured to recieve logs from a remote client(Automated)##

if test -f /etc/rsyslog.conf; then
	
	if grep -q 'module(load="imtcp")' /etc/rsyslog.conf  &&
	grep -q 'input(type="imtcp" port="514")' /etc/rsyslog.conf; then

	echo -e "rsyslog is not configured to recieve logs from a remote client: \033[1;32mOK\033[0m"
    let COUNTER++
	else
	echo -e "rsyslog is configured to recieve logs from a remote client: \033[1;31mERROR\033[0m"
	fi 

else
	echo -e "rsyslog is configured to recieve logs from a remote client: \033[1;31mERROR\033[0m"
fi

printf "Finished auditing with score: $COUNTER/48"