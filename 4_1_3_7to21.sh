#!/bin/bash

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

echo "Making identity audit log rules..."
touch /etc/audit/rules.d/50-identity.rules

printf "
-w /etc/group -p wa -k identity
-w /etc/passwd -p wa -k identity 
-w /etc/gshadow -p wa -k identity 
-w /etc/shadow -p wa -k identity 
-w /etc/security/opasswd -p wa -k identity
" >> /etc/audit/rules.d/50-identity.rules

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

echo "Adding in file system mounts audit log rules to permissison modification rules..."
[ -n "${UID_MIN}" ] && printf "
-a always,exit -F arch=b32 -S mount -F auid>=1000 -F auid!=unset -k mounts
-a always,exit -F arch=b64 -S mount -F auid>=1000 -F auid!=unset -k mounts
" >> /etc/audit/rules.d/50-perm_mod.rules \ || printf "ERROR: Variable 'UID_MIN' is unset. \n"

echo "Making session initiation information audit log rules..."
touch /etc/audit/rules.d/50-session.rules

printf "
-w /var/run/utmp -p wa -k session 
-w /var/log/wtmp -p wa -k session 
-w /var/log/btmp -p wa -k session
" >> /etc/audit/rules.d/50-session.rules

echo "Making login and logout event audit log rules..."
touch /etc/audit/rules.d/50-login.rules

printf "
-w /var/log/lastlog -p wa -k logins 
-w /var/run/faillock -p wa -k logins 
" >> /etc/audit/rules.d/50-login.rules

echo "Making deletion event audit log rules..."
touch /etc/audit/rules.d/50-delete.rules

[ -n "${UID_MIN}" ] && printf "
-a always,exit -F arch=b64 -S rename,unlink,unlinkat,renameat -F auid>=${UID_MIN} -F auid!=unset -F key=delete
-a always,exit -F arch=b32 -S rename,unlink,unlinkat,renameat -F auid>=${UID_MIN} -F auid!=unset -F key=delete
" >> /etc/audit/rules.d/50-delete.rules

echo "Making MAC modification events audit log rules..."
touch /etc/audit/rules.d/50-MAC-policy.rules

printf "
-w /etc/selinux -p wa -k MAC-policy
-w /usr/share/selinux -p wa -k MAC-policy
" >> /etc/audit/rules.d/50-MAC-policy.rules

echo "Making chcon command attempts audit log rules..."
touch /etc/audit/rules.d/50-perm_chng.rules

[ -n "${UID_MIN}" ] && printf "
-a always,exit -F path=/usr/bin/chcon -F perm=x -F auid>=${UID_MIN} -F auid!=unset -k perm_chng
" >> /etc/audit/rules.d/50-perm_chng.rules \ || printf "ERROR: Variable 'UID_MIN' is unset.\n"

echo "Making setfacl command attempts audit log rules..."
touch /etc/audit/rules.d/50-priv_cmd.rules

[ -n "${UID_MIN}" ] && printf "
-a always,exit -F path=/usr/bin/setfacl -F perm=x -F auid>=${UID_MIN} -F auid!=unset -k perm_chng
" >> /etc/audit/rules.d/50-priv_cmd.rules \ || printf "ERROR: Variable 'UID_MIN' is unset.\n"

echo "Adding in chacl command attempt audit log rules to chcon audit log rules..."
[ -n "${UID_MIN}" ] && printf "
-a always,exit -F path=/usr/bin/chacl -F perm=x -F auid>=${UID_MIN} -F auid!=unset -k perm_chng
" >> /etc/audit/rules.d/50-perm_chng.rules \ || printf "ERROR: Variable 'UID_MIN' is unset.\n"

echo "Making usermod command attempt audit log rules..."
touch /etc/audit/rules.d/50-usermod.rules

[ -n "${UID_MIN}" ] && printf "
-a always,exit -F path=/usr/sbin/usermod -F perm=x -F auid>=${UID_MIN} -F auid!=unset -k usermod
" >> /etc/audit/rules.d/50-usermod.rules \ || printf "ERROR: Variable 'UID_MIN' is unset.\n"

echo "Making kernel module loading or unloading and modification audit log rules..."
touch /etc/audit/rules.d/50-kernel_modules.rules

[ -n "${UID_MIN}" ] && printf "
-a always,exit -F arch=b64 -S init_module,finit_module,delete_module,create_module,query_module -F auid>=${UID_MIN} -F auid!=unset -k kernel_modules
-a always,exit -F path=/usr/bin/kmod -F perm=x -F auid>=${UID_MIN} -F auid!=unset -k kernel_modules
" >> /etc/audit/rules.d/50-kernel_modules.rules \ || printf "ERROR: Variable 'UID_MIN' is unset.\n"

echo "Setting audit configuration to immutable..."
echo "-e 2" > /etc/audit/rules.d/99-finalize.rules


