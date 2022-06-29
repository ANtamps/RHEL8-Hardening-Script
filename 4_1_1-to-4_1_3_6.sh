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



##4.1.3.1 Ensure changes to system administration scope (sudoers) is collected
echo "Setting system administration scope..."
touch /etc/audit/rules.d/50-scope.rules

printf "
-w /etc/sudoers -p wa -k scope
-w /etc/sudoers.d -p wa -k scope
" >> /etc/audit/rules.d/50-scope.rules

##4.1.3.2 Ensure actions as another user are always logged
echo "Setting emulation rules..."
touch /etc/audit/rules.d/50-user_emulation.rules

printf "
-a always,exit -F arch=b64 -C euid!=uid -F auid!=unset -S execve -k 
user_emulation 
-a always,exit -F arch=b32 -C euid!=uid -F auid!=unset -S execve -k 
user_emulation
" >> /etc/audit/rules.d/50-user_emulation.rules

##4.1.3.3 Ensure events that modify the sudo log file are collected
echo "Setting SUDO LOG FILE..."
SUDO_LOG_FILE=$(grep -r logfile /etc/sudoers* | sed -e 's/.*logfile=//;s/,? .*//' -e 's/"//g')

echo "Making sudo log rules..."
touch /etc/audit/rules.d/50-sudo.rules

[ -n "${SUDO_LOG_FILE_ESCAPED}" ] && printf "
-w ${SUDO_LOG_FILE} -p wa -k sudo_log_file
" >> /etc/audit/rules.d/50-sudo.rules \ || printf "ERROR: Variable 'SUDO_LOG_FILE_ESCAPED' is unset.\n"

##4.1.3.4 Ensure events that modify date and time information are collected
echo "Modifying system dates..."
touch /etc/audit/rules.d/50-time-change.rules

 printf "
-a always,exit -F arch=b64 -S adjtimex,settimeofday,clock_settime -k timechange
-a always,exit -F arch=b32 -S adjtimex,settimeofday,clock_settime -k timechange
-w /etc/localtime -p wa -k time-change
" >> /etc/audit/rules.d/50-time-change.rules

##4.1.3.5 Ensure events that modify the system's network environment are collected
echo "Setting system local rules..."
touch /etc/audit/rules.d/50-system_local.rules

printf "
-a always,exit -F arch=b64 -S sethostname,setdomainname -k system-locale
-a always,exit -F arch=b32 -S sethostname,setdomainname -k system-locale
-w /etc/issue -p wa -k system-locale
-w /etc/issue.net -p wa -k system-locale
-w /etc/hosts -p wa -k system-locale
-w /etc/sysconfig/network -p wa -k system-locale
-w /etc/sysconfig/network-scripts/ -p wa -k system-locale
" >> /etc/audit/rules.d/50-system_local.rules

##4.1.3.6 Ensure use of privileged commands are collected
echo "Setting privileged rules..."
touch /etc/audit/rules.d/50-privileged.rules

build_audit_rules()
(
 UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)
 AUDIT_RULE_FILE="/etc/audit/rules.d/50-privileged.rules"
 NEW_DATA=()
 for PARTITION in $(findmnt -n -l -k -it $(awk '/nodev/ { print $2 }' 
/proc/filesystems | paste -sd,) | grep -Pv "noexec|nosuid" | awk '{print 
$1}'); do
 readarray -t DATA < <(find "${PARTITION}" -xdev -perm /6000 -type f | awk 
-v UID_MIN=${UID_MIN} '{print "-a always,exit -F path=" $1 " -F perm=x -F 
auid>="UID_MIN" -F auid!=unset -k privileged" }')
 for ENTRY in "${DATA[@]}"; do
 NEW_DATA+=("${ENTRY}")
 done
 done
 readarray &> /dev/null -t OLD_DATA < "${AUDIT_RULE_FILE}"
 COMBINED_DATA=( "${OLD_DATA[@]}" "${NEW_DATA[@]}" )
 printf '%s\n' "${COMBINED_DATA[@]}" | sort -u > "${AUDIT_RULE_FILE}"
)
build_audit_rules

