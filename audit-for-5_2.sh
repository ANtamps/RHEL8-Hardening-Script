#!/bin/bash

# 5.2.1 Ensure permissions on /etc/ssh/sshd_config are configured

if [ $(stat -c %u /etc/ssh/sshd_config) -eq 0 ]; then
    echo -e "Owned by root, checking for permissions..."

    if [ $(stat -c %a /etc/ssh/sshd_config) -eq 600 ]; then
        echo -e "Permissions set to read-only for root: \033[1;32mOK\033[0m"
    else
        echo -e "Permissions not set to read-only for root: \033[1;31mERROR\033[0m"
    fi
else
    echo -e "File not owned by root: \033[1;31mERROR\033[0m"
fi

# 5.2.2 Ensure permissions on SSH private host key files are configured

ssh_priv_keys=$(find /etc/ssh -xdev -type f -name 'ssh_host_*_key')

for file in $ssh_priv_keys
do
    if [ $(stat -c %u $file) -eq 0 ] && [ $(stat -c %g $file) -eq 995 ] && [ $(stat -c %a $file) -eq 640 ]; then
        echo -e "$(stat -c %n $file) has root ownership & part of ssh_keys group, and has appropriate permissions: \033[1;32mOK\033[0m"
    else
        echo -e "$(stat -c %n $file) has permissions and/or ownership/group conflict: \033[1;31mERROR\033[0m"
    fi
done

# 5.2.3 Ensure permissions on SSH public host key files are configured

ssh_pub_keys = $(find /etc/ssh -xdev -type f -name 'ssh_host_*_key.pub')

for file in $ssh_pub_keys
do
    if [ $(stat -c %a $file) -eq 600 ]; then
        echo -e "File permission for $(stat -c %n $file) is set to 600: \033[1;32mOK\033[0m"
    else   
        echo -e "File permission for $(stat -c %n $file) not set to 600: \033[1;31mERROR\033[0m"
    fi
done

# 5.2.5 Ensure SSH LogLevel is appropriate

if sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep -e "loglevel VERBOSE" -e "loglevel INFO" &> /dev/null; then
    echo -e "SSH LogLevel set to appropriate: \033[1;32mOK\033[0m"
else
    echo -e "SSH LogLevel not set to appropriate: \033[1;31mERROR\033[0m"
fi

# 5.2.6 Ensure SSH PAM is enabled

if sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep -i "usepam yes" &> /dev/null; then
    echo -e "SSH PAM is enabled: \033[1;32mOK\033[0m"
else
    echo -e "SSH PAM is not enabled: \033[1;31mERROR\033[0m"
fi

# 5.2.7 Ensure SSH root login is disabled

if sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep "permitrootlogin no" &> /dev/null; then
    echo -e "SSH root login is enabled: \033[1;32mOK\033[0m"
else
    echo -e "SSH root login is not enabled: \033[1;31mERROR\033[0m"
fi

# 5.2.8 Ensure SSH HostbasedAuthentication is disabled

if sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep "hostbasedauthentication no" &> /dev/null; then
    echo -e "SSH HostbasedAuthentication is disabled: \033[1;32mOK\033[0m"
else
    echo -e "SSH HostbasedAuthentication is not disabled: \033[1;31mERROR\033[0m"
fi

# 5.2.9 Ensure SSH PermitEmptyPasswords is disabled

if sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep "permitemptypasswords no" &> /dev/null; then
    echo -e "SSH PermitEmptyPasswords is disabled: \033[1;32mOK\033[0m"
else
    echo -e "SSH PermitEmptyPasswords is not disabled: \033[1;31mERROR\033[0m"
fi

# 5.2.10 Ensure SSH PermitUserEnvironment is disabled

if sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep -i "permituserenvironment no" &> /dev/null; then
    echo -e "SSH PermitUserEnvironment is disabled: \033[1;32mOK\033[0m"
else
    echo -e "SSH PermitUserEnvironment is not disabled: \033[1;31mERROR\033[0m"
fi

# 5.2.11 Ensure SSH IgnoreRhosts is enabled

if sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep "ignorerhosts yes" &> /dev/null; then
    echo -e "SSH IgnoreRhosts is enabled: \033[1;32mOK\033[0m"
else
    echo -e "SSH IgnoreRhosts is not enabled: \033[1;31mERROR\033[0m"
fi

# 5.2.12 Ensure SSH X11 forwarding is disabled

if sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep -i "x11forwarding no" &> /dev/null; then
    echo -e "SSH X11 forwarding is disabled: \033[1;32mOK\033[0m"
else
    echo -e "SSH X11 forwarding is not disabled: \033[1;31mERROR\033[0m"
fi

# 5.2.13 Ensure SSH AllowTcpForwarding is disabled

if sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep - i "allowtcpforwarding no" &> /dev/null; then
    echo -e "SSH AllowTcpForwarding is disabled: \033[1;32mOK\033[0m"
else
    echo -e "SSH AllowTcpForwarding is not disabled: \033[1;31mERROR\033[0m"
fi

# 5.2.14 Ensure system-wide crypto policy is not over-ridden

if ! grep -i '^\s*CRYPTO_POLICY=' /etc/sysconfig/sshd; then
    echo -e"System-wide crypto policy is not over-ridden: \033[1;32mOK\033[0m"
else
    echo -e "System-wide crypto policy is over-ridden: \033[1;31mERROR\033[0m"
fi

# 5.2.15 Ensure SSH warning banner is configured

if sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep "banner /etc/issue.net" &> /dev/null; then
    echo -e "SSH warning banner is enabled: \033[1;32mOK\033[0m"
else
    echo -e "SSH warning banner is not enabled: \033[1;31mERROR\033[0m"
fi

# 5.2.16 Ensure SSH MaxAuthTries is set to 4 or less

if sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep "maxauthtries [1-4]" &> /dev/null; then
    echo -e "SSH MaxAuthTries set to 4 or less: \033[1;32mOK\033[0m"
else
    echo -e "SSH MaxAuthTries not set to 4 or less: \033[1;31mERROR\033[0m"
fi

# 5.2.17 Ensure SSH MaxStartups is configured

if sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep "maxstartups 10:30:60" &> /dev/null; then
    echo -e "SSH MaxStartups is configured: \033[1;32mOK\033[0m"
else
    echo -e "SSH MaxStartups is not configured: \033[1;31mERROR\033[0m"
fi

# 5.2.18 SSH MaxSessions is set to 10 or less

if sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep "maxsessions [1-10]" &> /dev/null; then
    echo -e "SSH MaxSessions set to 10 or less: \033[1;32mOK\033[0m"
else
    echo -e "SSH MaxSessions not set to 10 or less: \033[1;31mERROR\033[0m"
fi

# 5.2.19 Ensure SSH LoginGraceTime is set to one minute or less

if sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep "logingracetime [30-60]" &> /dev/null; then
    echo -e "SSH LoginGraceTime set to 1 minute or less: \033[1;32mOK\033[0m"
else
    echo -e "SSH LoginGraceTime not set to 1 minute or less: \033[1;31mERROR\033[0m"
fi

# 5.2.20 Ensure SSH Idle Timeout Interval is configured

if sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep "clientaliveinterval [1-900]" &> /dev/null; then
    echo -e "SSH Idle Timeout Interval is configured: \033[1;32mOK\033[0m"
else
    echo -e "SSH Idle Timeout Interval is not configured: \033[1;31mERROR\033[0m"
fi

