#!/bin/bash

# 4.1.3.7

if [ $(grep -c access /etc/audit/rules.d/50-access.rules) -eq 4 ]; then
    echo "Access rules for file systems set on disk config: \033[1;32mOK\033[0m"
else
    echo "Access rules for file systems not set on disk config: \033[1;31mERROR\033[0m"
fi

if [ $(auditctl -l | grep -c access) -eq 4 ]; then
    echo "Access rules for file systems set on running config: \033[1;32mOK\033[0m"
else
    echo "Access rules for file systems not set on running config: \033[1;31mERROR\033[0m"
fi

# 4.1.3.8 

if [ $(grep -c identity /etc/audit/rules.d/50-identity.rules) -eq 5 ]; then
    echo "User/Group info modification events set on disk config: \033[1;32mOK\033[0m"
else
    echo "User/Group info modification events not set on disk config: \033[1;31mERROR\033[0m"
fi

if [ $(auditctl -l | grep -c identity) -eq 5 ]; then
    echo "User/Group info modification events set on running config: \033[1;32mOK\033[0m"
else
    echo "User/Group info modification events not set on running config: \033[1;31mERROR\033[0m"
fi

# 4.1.3.9

if [ $(grep -c perm_mod /etc/audit/rules.d/50-perm_mod.rules) -eq 6 ]; then
    echo "Permission modification events set on disk config: \033[1;32mOK\033[0m"
else
    echo "Permission modification events not set on disk config: \033[1;31mERROR\033[0m"
fi

if [ $(auditctl -l | grep -c perm_mod) -eq 6 ]; then
    echo "Permission modification events set on running config: \033[1;32mOK\033[0m"
else
    echo "Permission modification events not set on running config: \033[1;31mERROR\033[0m"
fi

# 4.1.3.10

if [ $(grep -c mounts /etc/audit/rules.d/50-perm_mod.rules) -eq 2 ]; then
    echo "Successful file system mounts events set on disk config: \033[1;32mOK\033[0m"
else
    echo "Successful file system mounts events not set on disk config: \033[1;31mERROR\033[0m"
fi

if [ $(auditctl -l | grep -c mounts) -eq 2 ]; then
    echo "Successful file system mounts events set on running config: \033[1;32mOK\033[0m"
else
    echo "Successful file system mounts events not set on running config: \033[1;31mERROR\033[0m"
fi

# 4.1.3.11

if [ $(grep -c session /etc/audit/rules.d/50-session.rules) -eq 3 ]; then
    echo "Session initiation information set on disk config: \033[1;32mOK\033[0m"
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
else
    echo "Login and logout events not set on disk config: \033[1;31mERROR\033[0m"
fi

if [ $(auditctl -l | grep -c logins) -eq 2 ]; then
    echo "Login and logout events set on running config: \033[1;32mOK\033[0m"
else
    echo "Login and logout events not set on running config: \033[1;31mERROR\033[0m"
fi

# 4.1.3.13

if [ $(grep -c delete /etc/audit/rules.d/50-delete.rules) -eq 2 ]; then
    echo "File deletion events set on disk config: \033[1;32mOK\033[0m"
else
    echo "File deletion events not set on disk config: \033[1;31mERROR\033[0m"
fi

if [ $(auditctl -l | grep -c delete) -eq 2 ]; then
    echo "File deletion events set on running config: \033[1;32mOK\033[0m"
else
    echo "File deletion events not set on running config: \033[1;31mERROR\033[0m"
fi

# 4.1.3.14

if [ $(grep -c MAC-policy /etc/audit/rules.d/50-MAC-policy.rules) -eq 2 ]; then
    echo "MAC system modification events set on disk config: \033[1;32mOK\033[0m"
else
    echo "MAC system modification events not set on disk config: \033[1;31mERROR\033[0m"
fi

if [ $(auditctl -l | grep -c MAC-policy) -eq 2 ]; then
    echo "MAC system modification events set on running config: \033[1;32mOK\033[0m"
else
    echo "MAC system modification events not set on running config: \033[1;31mERROR\033[0m"
fi

# 4.1.3.15

if [ $(grep -c path=/usr/bin/chcon /etc/audit/rules.d/50-perm_chng.rules) -eq 1 ]; then
    echo "Unsuccessful chcon events set on disk config: \033[1;32mOK\033[0m"
else
    echo "Unsuccessful chcon events not set on disk config: \033[1;31mERROR\033[0m"
fi

if [ $(auditctl -l | grep -c path=/usr/bin/chcon) -eq 1 ]; then
    echo "Unsuccessful chcon events set on running config: \033[1;32mOK\033[0m"
else
    echo "Unsuccessful chcon events not set on running config: \033[1;31mERROR\033[0m"
fi

# 4.1.3.16

if [ $(grep -c path=/usr/bin/setfacl /etc/audit/rules.d/50-priv_cmd.rules) -eq 1 ]; then
    echo "Unsuccessful setfacl events set on disk config: \033[1;32mOK\033[0m"
else
    echo "Unsuccessful setfacl events not set on disk config: \033[1;31mERROR\033[0m"
fi

if [ $(auditctl -l | grep -c path=/usr/bin/setfacl) -eq 1 ]; then
    echo "Unsuccessful setfacl events set on running config: \033[1;32mOK\033[0m"
else
    echo "Unsuccessful setfacl events not set on running config: \033[1;31mERROR\033[0m"
fi

# 4.1.3.17

if [ $(grep -c path=/usr/bin/chacl /etc/audit/rules.d/50-perm_chng.rules) -eq 1 ]; then
    echo "Unsuccessful chacl events set on disk config: \033[1;32mOK\033[0m"
else
    echo "Unsuccessful chacl events not set on disk config: \033[1;31mERROR\033[0m"
fi

if [ $(auditctl -l | grep -c path=/usr/bin/chacl) -eq 1 ]; then
    echo "Unsuccessful chacl events set on running config: \033[1;32mOK\033[0m"
else
    echo "Unsuccessful chacl events not set on running config: \033[1;31mERROR\033[0m"
fi

# 4.1.3.18

if [ $(grep -c usermod /etc/audit/rules.d/50-usermod.rules) -eq 1 ]; then
    echo "Unsuccessful chacl events set on disk config: \033[1;32mOK\033[0m"
else
    echo "Unsuccessful chacl events not set on disk config: \033[1;31mERROR\033[0m"
fi

if [ $(auditctl -l | grep -c usermod) -eq 1 ]; then
    echo "Unsuccessful chacl events set on running config: \033[1;32mOK\033[0m"
else
    echo "Unsuccessful chacl events not set on running config: \033[1;31mERROR\033[0m"
fi

# 4.1.3.19

if [ $(grep -c kernel_modules /etc/audit/rules.d/50-kernel_modules.rules) -eq 2 ]; then
    echo "Unsuccessful chacl events set on disk config: \033[1;32mOK\033[0m"
else
    echo "Unsuccessful chacl events not set on disk config: \033[1;31mERROR\033[0m"
fi

if [ $(auditctl -l | grep -c kernel_modules) -eq 2 ]; then
    echo "Unsuccessful chacl events set on running config: \033[1;32mOK\033[0m"
else
    echo "Unsuccessful chacl events not set on running config: \033[1;31mERROR\033[0m"
fi

# 4.1.3.20

if [ "$(grep "-e 2" /etc/audit/rules.d/*.rules | tail -1 | cut -d ':' -f 2)" = "-e 2" ]; then
    echo "Audit configuration set to immutable: \033[1;32mOK\033[0m"
else
    echo "Audit configuration not set to immutable: \033[1;31mERROR\033[0m"
fi

