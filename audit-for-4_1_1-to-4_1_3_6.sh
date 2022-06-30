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

##4.1.3.3 Ensure events that modify the sudo log file are collected

SUDO_LOG_FILE_ESCAPED=$(grep -r logfile /etc/sudoers* | sed -e 

's/.*logfile=//;s/,? .*//' -e 's/"//g' -e 's|/|\\/|g')
# [ -n "${SUDO_LOG_FILE_ESCAPED}" ] && awk "/^ *-w/ \
&&/"${SUDO_LOG_FILE_ESCAPED}"/ \
&&/ +-p *wa/ \
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)" /etc/audit/rules.d/*.rules \ || printf "ERROR: Variable 'SUDO_LOG_FILE_ESCAPED' is unset.\n"

's/.*logfile=//;s/,? .*//' -e 's/"//g' -e 's|/|\\/|g')
# [ -n "${SUDO_LOG_FILE_ESCAPED}" ] && auditctl -l | awk "/^ *-w/ \
&&/"${SUDO_LOG_FILE_ESCAPED}"/ \
&&/ +-p *wa/ \
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)" \ || printf "ERROR: Variable 'SUDO_LOG_FILE_ESCAPED' is unset.\n"

##4.1.3.4 Ensure events that modify date and time information are collected

awk '/^ *-a *always,exit/ \
&&/ -F *arch=b[2346]{2}/ \
&&/ -S/ \
&&(/adjtimex/ \
 ||/settimeofday/ \
 ||/clock_settime/ ) \
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)' /etc/audit/rules.d/*.rules

awk '/^ *-w/ \
&&/\/etc\/localtime/ \
&&/ +-p *wa/ \
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)' /etc/audit/rules.d/*.rules

 auditctl -l | awk '/^ *-a *always,exit/ \
&&/ -F *arch=b[2346]{2}/ \
&&/ -S/ \
&&(/adjtimex/ \
 ||/settimeofday/ \
 ||/clock_settime/ ) \
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)'

 auditctl -l | awk '/^ *-w/ \
&&/\/etc\/localtime/ \
&&/ +-p *wa/ \
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)'

##4.1.3.5 Ensure events that modify the system's network environment are collected

 awk '/^ *-a *always,exit/ \
&&/ -F *arch=b[2346]{2}/ \
&&/ -S/ \
&&(/sethostname/ \
 ||/setdomainname/) \
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)' /etc/audit/rules.d/*.rules

 awk '/^ *-w/ \
&&(/\/etc\/issue/ \
 ||/\/etc\/issue.net/ \
 ||/\/etc\/hosts/ \
 ||/\/etc\/sysconfig\/network/) \
&&/ +-p *wa/ \
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)' /etc/audit/rules.d/*.rules

auditctl -l | awk '/^ *-a *always,exit/ \
&&/ -F *arch=b[2346]{2}/ \
&&/ -S/ \
&&(/sethostname/ \
 ||/setdomainname/) \
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)'

 auditctl -l | awk '/^ *-w/ \
&&(/\/etc\/issue/ \
 ||/\/etc\/issue.net/ \
 ||/\/etc\/hosts/ \
 ||/\/etc\/sysconfig\/network/) \
&&/ +-p *wa/ \
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)'


##4.1.3.6 Ensure use of privileged commands are collected

for PARTITION in $(findmnt -n -l -k -it $(awk '/nodev/ { print $2 }' 
/proc/filesystems | paste -sd,) | grep -Pv "noexec|nosuid" | awk '{print 
$1}'); do
 for PRIVILEGED in $(find "${PARTITION}" -xdev -perm /6000 -type f); do
 grep -qr "${PRIVILEGED}" /etc/audit/rules.d && printf "OK: 
'${PRIVILEGED}' found in auditing rules.\n" || printf "Warning: 
'${PRIVILEGED}' not found in on disk configuration.\n"
 done
done

RUNNING=$(auditctl -l)
[ -n "${RUNNING}" ] && for PARTITION in $(findmnt -n -l -k -it $(awk 
'/nodev/ { print $2 }' /proc/filesystems | paste -sd,) | grep -Pv 
"noexec|nosuid" | awk '{print $1}'); do
 for PRIVILEGED in $(find "${PARTITION}" -xdev -perm /6000 -type f); do
 printf -- "${RUNNING}" | grep -q "${PRIVILEGED}" && printf "OK: 
'${PRIVILEGED}' found in auditing rules.\n" || printf "Warning: 
'${PRIVILEGED}' not found in running configuration.\n"
 done
done \ || printf "ERROR: Variable 'RUNNING' is unset.\n"

