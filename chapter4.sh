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

# 4.1.3.7

echo "Setting UID_MIN..."
UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)

echo "Making access audit log rules..."
touch /etc/audit/rules.d/50-access.rules

[ -n "${UID_MIN}" ] && printf "
-a always,exit -F arch=b64 -S creat,open,openat,truncate,ftruncate -F exit=-EACCES -F auid>=${UID_MIN} -F auid!=unset -k access
-a always,exit -F arch=b64 -S creat,open,openat,truncate,ftruncate -F exit=-EPERM -F auid>=${UID_MIN} -F auid!=unset -k access
-a always,exit -F arch=b32 -S creat,open,openat,truncate,ftruncate -F exit=-EACCES -F auid>=${UID_MIN} -F auid!=unset -k access
-a always,exit -F arch=b32 -S creat,open,openat,truncate,ftruncate -F exit=-EPERM -F auid>=${UID_MIN} -F auid!=unset -k access
" >> /etc/audit/rules.d/50-access.rules \ || printf "ERROR: Variable 'UID_MIN' is unset. \n"

# 4.1.3.8
echo "Making identity audit log rules..."
touch /etc/audit/rules.d/50-identity.rules

printf "
-w /etc/group -p wa -k identity
-w /etc/passwd -p wa -k identity 
-w /etc/gshadow -p wa -k identity 
-w /etc/shadow -p wa -k identity 
-w /etc/security/opasswd -p wa -k identity
" >> /etc/audit/rules.d/50-identity.rules

# 4.1.3.9

echo "Making permission modification audit log rules..."
touch /etc/audit/rules.d/50-perm_mod.rules

[ -n "${UID_MIN}" ] && printf "
-a always,exit -F arch=b64 -S chmod,fchmod,fchmodat -F auid>=${UID_MIN} -F auid!=unset -F key=perm_mod
-a always,exit -F arch=b64 -S chown,fchown,lchown,fchownat -F auid>=${UID_MIN} -F auid!=unset -F key=perm_mod
-a always,exit -F arch=b32 -S chmod,fchmod,fchmodat -F auid>=${UID_MIN} -F auid!=unset -F key=perm_mod
-a always,exit -F arch=b32 -S lchown,fchown,chown,fchownat -F auid>=${UID_MIN} -F auid!=unset -F key=perm_mod
-a always,exit -F arch=b64 -S setxattr,lsetxattr,fsetxattr,removexattr,lremovexattr,fremovexattr -F auid>=${UID_MIN} -F auid!=unset -F key=perm_mod
-a always,exit -F arch=b32 -S setxattr,lsetxattr,fsetxattr,removexattr,lremovexattr,fremovexattr -F auid>=${UID_MIN} -F auid!=unset -F key=perm_mod
" >> /etc/audit/rules.d/50-perm_mod.rules \ || printf "ERROR: Variable 'UID_MIN' is unset. \n"

# 4.1.3.10
echo "Adding in file system mounts audit log rules to permissison modification rules..."
[ -n "${UID_MIN}" ] && printf "
-a always,exit -F arch=b32 -S mount -F auid>=1000 -F auid!=unset -k mounts
-a always,exit -F arch=b64 -S mount -F auid>=1000 -F auid!=unset -k mounts
" >> /etc/audit/rules.d/50-perm_mod.rules \ || printf "ERROR: Variable 'UID_MIN' is unset. \n"

# 4.1.3.11
echo "Making session initiation information audit log rules..."
touch /etc/audit/rules.d/50-session.rules

printf "
-w /var/run/utmp -p wa -k session 
-w /var/log/wtmp -p wa -k session 
-w /var/log/btmp -p wa -k session
" >> /etc/audit/rules.d/50-session.rules

# 4.1.3.12
echo "Making login and logout event audit log rules..."
touch /etc/audit/rules.d/50-login.rules

printf "
-w /var/log/lastlog -p wa -k logins 
-w /var/run/faillock -p wa -k logins 
" >> /etc/audit/rules.d/50-login.rules

# 4.1.3.13
echo "Making deletion event audit log rules..."
touch /etc/audit/rules.d/50-delete.rules

[ -n "${UID_MIN}" ] && printf "
-a always,exit -F arch=b64 -S rename,unlink,unlinkat,renameat -F auid>=${UID_MIN} -F auid!=unset -F key=delete
-a always,exit -F arch=b32 -S rename,unlink,unlinkat,renameat -F auid>=${UID_MIN} -F auid!=unset -F key=delete
" >> /etc/audit/rules.d/50-delete.rules

# 4.1.3.14
echo "Making MAC modification events audit log rules..."
touch /etc/audit/rules.d/50-MAC-policy.rules

printf "
-w /etc/selinux -p wa -k MAC-policy
-w /usr/share/selinux -p wa -k MAC-policy
" >> /etc/audit/rules.d/50-MAC-policy.rules

# 4.1.3.15
echo "Making chcon command attempts audit log rules..."
touch /etc/audit/rules.d/50-perm_chng.rules

[ -n "${UID_MIN}" ] && printf "
-a always,exit -F path=/usr/bin/chcon -F perm=x -F auid>=${UID_MIN} -F auid!=unset -k perm_chng
" >> /etc/audit/rules.d/50-perm_chng.rules \ || printf "ERROR: Variable 'UID_MIN' is unset.\n"

# 4.1.3.16

echo "Making setfacl command attempts audit log rules..."
touch /etc/audit/rules.d/50-priv_cmd.rules

[ -n "${UID_MIN}" ] && printf "
-a always,exit -F path=/usr/bin/setfacl -F perm=x -F auid>=${UID_MIN} -F auid!=unset -k perm_chng
" >> /etc/audit/rules.d/50-priv_cmd.rules \ || printf "ERROR: Variable 'UID_MIN' is unset.\n"

# 4.1.3.17
echo "Adding in chacl command attempt audit log rules to chcon audit log rules..."
[ -n "${UID_MIN}" ] && printf "
-a always,exit -F path=/usr/bin/chacl -F perm=x -F auid>=${UID_MIN} -F auid!=unset -k perm_chng
" >> /etc/audit/rules.d/50-perm_chng.rules \ || printf "ERROR: Variable 'UID_MIN' is unset.\n"

# 4.1.3.18
echo "Making usermod command attempt audit log rules..."
touch /etc/audit/rules.d/50-usermod.rules

[ -n "${UID_MIN}" ] && printf "
-a always,exit -F path=/usr/sbin/usermod -F perm=x -F auid>=${UID_MIN} -F auid!=unset -k usermod
" >> /etc/audit/rules.d/50-usermod.rules \ || printf "ERROR: Variable 'UID_MIN' is unset.\n"

# 4.1.3.19
echo "Making kernel module loading or unloading and modification audit log rules..."
touch /etc/audit/rules.d/50-kernel_modules.rules

[ -n "${UID_MIN}" ] && printf "
-a always,exit -F arch=b64 -S init_module,finit_module,delete_module,create_module,query_module -F auid>=${UID_MIN} -F auid!=unset -k kernel_modules
-a always,exit -F path=/usr/bin/kmod -F perm=x -F auid>=${UID_MIN} -F auid!=unset -k kernel_modules
" >> /etc/audit/rules.d/50-kernel_modules.rules \ || printf "ERROR: Variable 'UID_MIN' is unset.\n"

# 4.1.3.20
echo "Setting audit configuration to immutable..."
echo "-e 2" > /etc/audit/rules.d/99-finalize.rules

echo "Loading audit rules..."
augenrules --load &> /dev/null

if [[ $(auditctl -s | grep "enabled") =~ "2" ]]; then 
    printf "Reboot required to load rules\n"; 
fi

##4.2.1.1 Ensure rsyslog is installed (Automated)##
if rpm -q rsyslog &> /dev/null; then
	echo "rsyslog is installed, continuing..."
else
	echo "rsyslog is not installed, installing..."
	dnf install -y rsyslog &> /dev/null
fi

##4.2.1.2 Ensure rsyslog service is enabled (Automated)##
if systemctl is-enabled rsyslog &> /dev/null; then
	echo "rsyslog is enabled, continuing..."
else
	echo "rsyslog is not enabled, enabling..."
	systemctl --now enable rsyslog
fi

##4.2.1.4 Ensure rsyslog default file permissions are configured(Automated)##

if test -f /etc/rsyslog.conf; then
	
	if grep ^\$FileCreateMode /etc/rsyslog.conf &> /dev/null; then
	echo "rsyslog default file permissions are configured, continuing..."

	else 
	echo '$FileCreateMode 0640' >> /etc/rsyslog.conf
	fi 

else
	touch /etc/rsyslog.conf
	echo '$FileCreateMode 0640' >> /etc/rsyslog.conf
fi

##4.2.1.7 Ensure rsyslog is not configured to recieve logs from a remote client(Automated)##

if test -f /etc/rsyslog.conf; then
	
	if grep -q 'module(load="imtcp")' /etc/rsyslog.conf  &&
	grep -q 'input(type="imtcp" port="514")' /etc/rsyslog.conf; then

	echo "rsyslog is not configured to recieve logs from a remote client, continuing..."

	else
	echo -e 'module(load="imtcp")\ninput(type="imtcp" port="514")' >> /etc/rsyslog.conf
	fi 

else
	touch /etc/rsyslog.conf
	echo -e 'module(load="imtcp")\ninput(type="imtcp" port="514")' >> /etc/rsyslog.conf
fi

systemctl restart rsyslog
