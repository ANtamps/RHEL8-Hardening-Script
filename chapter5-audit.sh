#!/bin/bash

##5.1.2 Ensure permissions on /etc/crontab are configured
if stat /etc/crontab &> /dev/null; then
    echo -e "Permissions on /etc/crontab configured: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "Permissions on etc/crontab not configured: \033[1;31mERROR\033[0m"
	echo -e "Permissions on etc/crontab not configured: \033[1;31mERROR\033[0m" >> audit-error.log

fi

##5.1.3 Ensure permissions on /etc/cron.hourly are configure
if stat /etc/cron.hourly &> /dev/null; then
    echo -e "Permissions on /etc/cron.hourly configured: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "Permissions on /etc/cron.hourly not configured: \033[1;31mERROR\033[0m"
	echo -e "Permissions on /etc/cron.hourly not configured: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##5.1.4 Ensure permissions on /etc/cron.daily are configured
if stat /etc/cron.daily &> /dev/null; then
    echo -e "Permissions on /etc/cron.daily configured: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "Permissions on /etc/cron.daily not configured: \033[1;31mERROR\033[0m"
	echo -e "Permissions on /etc/cron.daily not configured: \033[1;31mERROR\033[0m" >> audit-error.log

fi

##5.1.5 Ensure permissions on /etc/cron.weekly are configured
if stat /etc/cron.weekly &> /dev/null; then
    echo -e "Permissions on /etc/cron.weekly configured: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "Permissions on /etc/cron.weekly not configured: \033[1;31mERROR\033[0m"
	echo -e "Permissions on /etc/cron.weekly not configured: \033[1;31mERROR\033[0m" >> audit-error.log

fi

##5.1.6 Ensure permissions on /etc/cron.monthly are configured
if stat /etc/cron.monthly &> /dev/null; then
    echo -e "Permissions on /etc/cron.monthly configured: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "Permissions on /etc/cron.monthly not configured: \033[1;31mERROR\033[0m"
	echo -e "Permissions on /etc/cron.monthly not configured: \033[1;31mERROR\033[0m" >> audit-error.log

fi

##5.1.7 Ensure permissions on /etc/cron.d are configured
if stat /etc/cron.d &> /dev/null; then
    echo -e "Permissions on /etc/cron.d configured: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "Permissions on /etc/cron.d not configured: \033[1;31mERROR\033[0m"
	echo -e "Permissions on /etc/cron.d not configured: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##5.1.8 Ensure cron is restricted to authorized users
if rpm -q cronie >/dev/null; then
    echo -e "cron still installed: \033[1;31mERROR\033[0m"
	echo -e "cron still installed: \033[1;31mERROR\033[0m" >> audit-error.log
else
    echo -e "cron not installed: \033[1;32mOK\033[0m"
    let COUNTER++

fi

##5.1.9 Ensure at is restricted to authorized users
if rpm -q at >/dev/null; then
    echo -e "at still installed: \033[1;31mERROR\033[0m"
    echo -e "at still installed: \033[1;31mERROR\033[0m" >> audit-error.log

else
    echo -e "at not installed: \033[1;32mOK\033[0m"
    let COUNTER++

fi

# 5.2.1 Ensure permissions on /etc/ssh/sshd_config are configured

if [ $(stat -c %u /etc/ssh/sshd_config) -eq 0 ]; then
    echo -e "Owned by root, checking for permissions..."

    if [ $(stat -c %a /etc/ssh/sshd_config) -eq 600 ]; then
        echo -e "Permissions set to read-only for root: \033[1;32mOK\033[0m"
    let COUNTER++
    else
        echo -e "Permissions not set to read-only for root: \033[1;31mERROR\033[0m"
		echo -e "Permissions not set to read-only for root: \033[1;31mERROR\033[0m" >> audit-error.log
    fi
else
    echo -e "File not owned by root: \033[1;31mERROR\033[0m"
	echo -e "File not owned by root: \033[1;31mERROR\033[0m" >> audit-error.log

fi

# 5.2.2 Ensure permissions on SSH private host key files are configured

ssh_priv_keys=$(find /etc/ssh -xdev -type f -name 'ssh_host_*_key')
ssh_group_id=$(getent group ssh_keys | cut -d ':' -f 3)

for file in $ssh_priv_keys
do
    if [ $(stat -c %u $file) -eq 0 ] && [ $(stat -c %g $file) -eq $ssh_group_id ] && [ $(stat -c %a $file) -eq 640 ]; then
        echo -e "$(stat -c %n $file) has root ownership & part of ssh_keys group, and has appropriate permissions: \033[1;32mOK\033[0m"
        let COUNTER++
    else
        echo -e "$(stat -c %n $file) has permissions and/or ownership/group conflict: \033[1;31mERROR\033[0m"
		echo -e "$(stat -c %n $file) has permissions and/or ownership/group conflict: \033[1;31mERROR\033[0m" >> audit-error.log
    fi
done

# 5.2.3 Ensure permissions on SSH public host key files are configured

ssh_pub_keys=$(find /etc/ssh -xdev -type f -name 'ssh_host_*_key.pub')

for file in $ssh_pub_keys
do
    if [ $(stat -c %a $file) -eq 600 ]; then
        echo -e "File permission for $(stat -c %n $file) is set to 600: \033[1;32mOK\033[0m"
        let COUNTER++
    else   
        echo -e "File permission for $(stat -c %n $file) not set to 600: \033[1;31mERROR\033[0m"
		echo -e "File permission for $(stat -c %n $file) not set to 600: \033[1;31mERROR\033[0m" >> audit-error.log
    fi
done

# 5.2.5 Ensure SSH LogLevel is appropriate

if sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep -e "loglevel VERBOSE" -e "loglevel INFO" &> /dev/null; then
    echo -e "SSH LogLevel set to appropriate: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "SSH LogLevel not set to appropriate: \033[1;31mERROR\033[0m"
	echo -e "SSH LogLevel not set to appropriate: \033[1;31mERROR\033[0m" >> audit-error.log
fi

# 5.2.6 Ensure SSH PAM is enabled

if sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep -i "usepam yes" &> /dev/null; then
    echo -e "SSH PAM is enabled: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "SSH PAM is not enabled: \033[1;31mERROR\033[0m"
	echo -e "SSH PAM is not enabled: \033[1;31mERROR\033[0m" >> audit-error.log
fi

# 5.2.7 Ensure SSH root login is disabled

if sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep "permitrootlogin no" &> /dev/null; then
    echo -e "SSH root login is enabled: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "SSH root login is not enabled: \033[1;31mERROR\033[0m"
	echo -e "SSH root login is not enabled: \033[1;31mERROR\033[0m" >> audit-error.log
fi

# 5.2.8 Ensure SSH HostbasedAuthentication is disabled

if sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep "hostbasedauthentication no" &> /dev/null; then
    echo -e "SSH HostbasedAuthentication is disabled: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "SSH HostbasedAuthentication is not disabled: \033[1;31mERROR\033[0m"
	echo -e "SSH HostbasedAuthentication is not disabled: \033[1;31mERROR\033[0m" >> audit-error.log
fi 

# 5.2.9 Ensure SSH PermitEmptyPasswords is disabled

if sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep "permitemptypasswords no" &> /dev/null; then
    echo -e "SSH PermitEmptyPasswords is disabled: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "SSH PermitEmptyPasswords is not disabled: \033[1;31mERROR\033[0m"
	echo -e "SSH PermitEmptyPasswords is not disabled: \033[1;31mERROR\033[0m" >> audit-error.log
fi

# 5.2.10 Ensure SSH PermitUserEnvironment is disabled

if sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep -i "permituserenvironment no" &> /dev/null; then
    echo -e "SSH PermitUserEnvironment is disabled: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "SSH PermitUserEnvironment is not disabled: \033[1;31mERROR\033[0m"
	echo -e "SSH PermitUserEnvironment is not disabled: \033[1;31mERROR\033[0m" >> audit-error.log
fi

# 5.2.11 Ensure SSH IgnoreRhosts is enabled

if sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep "ignorerhosts yes" &> /dev/null; then
    echo -e "SSH IgnoreRhosts is enabled: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "SSH IgnoreRhosts is not enabled: \033[1;31mERROR\033[0m"
	echo -e "SSH IgnoreRhosts is not enabled: \033[1;31mERROR\033[0m" >> audit-error.log
fi

# 5.2.12 Ensure SSH X11 forwarding is disabled

if sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep -i "x11forwarding no" &> /dev/null; then
    echo -e "SSH X11 forwarding is disabled: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "SSH X11 forwarding is not disabled: \033[1;31mERROR\033[0m"
	echo -e "SSH X11 forwarding is not disabled: \033[1;31mERROR\033[0m" >> audit-error.log
fi

# 5.2.13 Ensure SSH AllowTcpForwarding is disabled

if sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep -i "allowtcpforwarding no" &> /dev/null; then
    echo -e "SSH AllowTcpForwarding is disabled: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "SSH AllowTcpForwarding is not disabled: \033[1;31mERROR\033[0m"
	echo -e "SSH AllowTcpForwarding is not disabled: \033[1;31mERROR\033[0m" >> audit-error.log
fi

# 5.2.14 Ensure system-wide crypto policy is not over-ridden

if ! grep -i '^\s*CRYPTO_POLICY=' /etc/sysconfig/sshd; then
    echo -e "System-wide crypto policy is not over-ridden: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "System-wide crypto policy is over-ridden: \033[1;31mERROR\033[0m"
	echo -e "System-wide crypto policy is over-ridden: \033[1;31mERROR\033[0m" >> audit-error.log
fi

# 5.2.15 Ensure SSH warning banner is configured

if sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep "banner /etc/issue.net" &> /dev/null; then
    echo -e "SSH warning banner is enabled: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "SSH warning banner is not enabled: \033[1;31mERROR\033[0m"
	echo -e "SSH warning banner is not enabled: \033[1;31mERROR\033[0m" >> audit-error.log
fi

# 5.2.16 Ensure SSH MaxAuthTries is set to 4 or less

if sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep "maxauthtries [1-4]" &> /dev/null; then
    echo -e "SSH MaxAuthTries set to 4 or less: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "SSH MaxAuthTries not set to 4 or less: \033[1;31mERROR\033[0m"
	echo -e "SSH MaxAuthTries not set to 4 or less: \033[1;31mERROR\033[0m" >> audit-error.log
fi

# 5.2.17 Ensure SSH MaxStartups is configured

if sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep "maxstartups 10:30:60" &> /dev/null; then
    echo -e "SSH MaxStartups is configured: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "SSH MaxStartups is not configured: \033[1;31mERROR\033[0m"
	echo -e "SSH MaxStartups is not configured: \033[1;31mERROR\033[0m" >> audit-error.log
fi

# 5.2.18 SSH MaxSessions is set to 10 or less

if sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep "maxsessions [1-10]" &> /dev/null; then
    echo -e "SSH MaxSessions set to 10 or less: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "SSH MaxSessions not set to 10 or less: \033[1;31mERROR\033[0m"
	echo -e "SSH MaxSessions not set to 10 or less: \033[1;31mERROR\033[0m" >> audit-error.log
fi

# 5.2.19 Ensure SSH LoginGraceTime is set to one minute or less

if sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep "logingracetime [30-60]" &> /dev/null; then
    echo -e "SSH LoginGraceTime set to 1 minute or less: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "SSH LoginGraceTime not set to 1 minute or less: \033[1;31mERROR\033[0m"
	echo -e "SSH LoginGraceTime not set to 1 minute or less: \033[1;31mERROR\033[0m" >> audit-error.log
fi

# 5.2.20 Ensure SSH Idle Timeout Interval is configured

if sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep "clientaliveinterval [1-900]" &> /dev/null; then
    echo -e "SSH Idle Timeout Interval is configured: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "SSH Idle Timeout Interval is not configured: \033[1;31mERROR\033[0m"
	echo -e "SSH Idle Timeout Interval is not configured: \033[1;31mERROR\033[0m" >> audit-error.log
fi


##5.3.1 Ensure sudo is installed
if rpm -q sudo &> /dev/null; then
    echo -e "sudo installed: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "sudo not installed: \033[1;31mERROR\033[0m"
    echo -e "sudo not installed: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##5.3.2 Ensure sudo commands use pty
if grep /etc/sudoers /etc/sudoers &> /dev/null; then
    echo -e "sudo commands use pty: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "sudo commands does not use pty: \033[1;31mERROR\033[0m"
	echo -e "sudo commands does not use pty: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##5.3.3 Ensure sudo log file exists
if grep -q "Defaults logfile=/var/log/sudo.log" /etc/suduoers; then

    echo -e "sudo log file exists: \033[1;32mOK\033[0m"
    let COUNTER++

else
    echo -e "sudo log file does not exist: \033[1;31mERROR\033[0m"
    echo -e "sudo log file does not exist: \033[1;31mERROR\033[0m" >> audit-error.log

fi

##5.3.4 Ensure users must provide password for escalation
if grep -q "NOPASSWD" /etc/suduoers; then

    echo -e "NOPASSWD does exist: \033[1;31mERROR\033[0m"
    echo -e "NOPASSWD does exist: \033[1;31mERROR\033[0m" >> audit-error.log
   
else
    echo -e "NOPASSWD does not exist: \033[1;32mOK\033[0m" 
    let COUNTER++

fi

##5.3.5 Ensure re-authentication for privilege escalation is not disabled globally
if grep -q "!authenticate" /etc/suduoers; then

    echo -e "!authenticate does exist: \033[1;31mERROR\033[0m"
    echo -e "!authenticate does exist: \033[1;31mERROR\033[0m" >> audit-error.log
   
else
    echo -e "!authenticate does not exist: \033[1;32mOK\033[0m" 
    let COUNTER++

fi

##5.3.6 Ensure sudo authentication timeout is configured correctly
if grep -roP "timestamp_timeout=\K[0-9]*"  /etc/group; then
    echo -e  "authentication timeout is not configured: \033[1;31mERROR\033[0m"
    echo -e  "authentication timeout is not configured: \033[1;31mERROR\033[0m" >> audit-error.log

else
    echo -e "authentication timeout is configured: \033[1;32mOK\033[0m"
    let COUNTER++


fi 

##5.3.7 Ensure access to the su command is restricted
if grep sugroup /etc/group; then
    echo -e "empty group added: \033[1;32mOK\033[0m"
    let COUNTER++

else
    echo -e "empty group not found: \033[1;31mERROR\033[0m"
    echo -e "empty group not found: \033[1;31mERROR\033[0m" >> audit-error.log

fi

##5.4.2 Ensure authselect includes with-faillock (Automated)##

if grep pam_faillock.so /etc/pam.d/password-auth /etc/pam.d/system-auth &> /dev/null; then
	
	echo -e "Authselect includes with-faillock: \033[1;32mOK\033[0m"
    let COUNTER++

else
	echo -e "Authselect does not includes with-faillock: \033[1;31mERROR\033[0m"
	echo -e "Authselect does not includes with-faillock: \033[1;31mERROR\033[0m" >> audit-error.log

fi

	
##5.5.1 Ensure password creation requirements are configured(Automated)##

if grep -q "minlen = 14" /etc/security/pwquality.conf &&
grep -q "minclass = 4" /etc/security/pwquality.conf &&
grep -q "dcredit = -1" /etc/security/pwquality.conf &&
grep -q "ucredit = -1" /etc/security/pwquality.conf &&
grep -q "ocredit = -1" /etc/security/pwquality.conf &&
grep -q "lcredit = -1" /etc/security/pwquality.conf; then

    echo -e "Password creation requirements are configured: \033[1;32mOK\033[0m" 
    let COUNTER++

else

    echo -e "Password creation requirements are not configured: \033[1;31mERROR\033[0m" 
    echo -e "Password creation requirements are not configured: \033[1;31mERROR\033[0m" >> audit-error.log

fi


##5.5.2 Ensure lockout for failed password attempts is configured(Automated)##

if grep -qw "deny = 5" /etc/security/faillock.conf &&
grep -qw "unlock_time = 900" /etc/security/faillock.conf; then

	echo -e "Lockout for failed password attempts is configured: \033[1;32mOK\033[0m"
    let COUNTER++

else 
	echo -e "Lockout for failed password attempts is not configured: \033[1;31mERROR\033[0m"
	echo -e "Lockout for failed password attempts is not configured: \033[1;31mERROR\033[0m" >> audit-error.log
fi



##5.5.4 Ensure password hashing algorithm is SHA-512 (Automated)##

if grep -Ei -q '^\s*crypt_style\s*=\s*sha512\b' /etc/libuser.conf; then

    echo -e "Configured hashing algorithm is sha512 in /etc/libuser.conf: \033[1;32mOK\033[0m"
    let COUNTER++

else 
    echo -e "Hashing algorithm is not sha512 in /etc/libuser.conf: \033[1;31mERROR\033[0m"
    echo -e "Hashing algorithm is not sha512 in /etc/libuser.conf: \033[1;31mERROR\033[0m" >> audit-error.log

fi

if grep -Ei -q '^\s*ENCRYPT_METHOD\s+SHA512\b' /etc/login.defs; then 

    echo -e "Configured hashing algorithm is sha512 in /etc/login.defs: \033[1;32mOK\033[0m"
    let COUNTER++

else 
    echo -e "Hashing algorithm is not sha512 in /etc/login.defs: \033[1;31mERROR\033[0m"
    echo -e "Hashing algorithm is not sha512 in /etc/login.defs: \033[1;31mERROR\033[0m" >> audit-error.log
fi


##5.6.1.1 Ensure password expiration is 365 days or less (Automated)##

if grep -qw "PASS_MAX_DAYS   365" /etc/login.defs; then

    echo -e "Password expiration is set to 365 days: \033[1;32mOK\033[0m"
    let COUNTER++

else
    echo -e "Password expiration is not set to 365 days: \033[1;31mERROR\033[0m"
    echo -e "Password expiration is not set to 365 days: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##5.6.1.2 Ensure minimum days between password changes is 7 or more(Automated)##

if grep -qw "PASS_MIN_DAYS   7" /etc/login.defs; then

    echo -e "Minimum days between password changes is set to 7: \033[1;32mOK\033[0m"
    let COUNTER++

else
    echo -e "Minimum days between password changes is not set to 7: \033[1;31mERROR\033[0m"
    echo -e "Minimum days between password changes is not set to 7: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##5.6.1.3 Ensure password expiration warning days is 7 or more(Automated)##

if grep -qw "PASS_WARN_AGE   7" /etc/login.defs; then

    echo -e "Password expiration warning days is set to 7: \033[1;32mOK\033[0m"
    let COUNTER++

else
    echo -e "Password expiration warning days is not set to 7: \033[1;31mERROR\033[0m"
    echo -e "Password expiration warning days is not set to 7: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##5.6.1.4 Ensure inactive password lock is 30 days or less (Automated)##

if useradd -D | grep -qw "INACTIVE=30"; then

    echo -e "Inactive password lock is set to 30 days: \033[1;32mOK\033[0m"
    let COUNTER++

else
    echo -e "Inactive password lock is not set to 30 days: \033[1;31mERROR\033[0m"
    echo -e "Inactive password lock is not set to 30 days: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##5.6.1.5 Ensure all users last password change date is in the past(Automated)##
if awk -F: '/^[^:]+:[^!*]/{print $1}' /etc/shadow | while read -r usr; \
do change=$(date -d "$(chage --list $usr | grep '^Last password change' | cut -d: -f2 | grep -v 'never$')" +%s); \
if [[ "$change" -gt "$(date +%s)" ]]; then \
echo "User: \"$usr\" last password change was \"$(chage --list $usr | grep
'^Last password change' | cut -d: -f2)\""; fi; done;then

    echo -e "All users last password change date is in the past: \033[1;32mOK\033[0m"
    let COUNTER++

else
    echo -e "Some users last password change date is in the future: \033[1;31mERROR\033[0m"
    echo -e "Some users last password change date is in the future: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##5.6.3 Ensure default user shell timeout is 900 seconds or less(Automated)##

if grep -q "TMOUT=900" /etc/profile &&
grep -q "readonly TMOUT" /etc/profile &&
grep -q "export TMOUT" /etc/profile; then

    echo -e "Default user shell timeout is set to 900 seconds in /etc/profile: \033[1;32mOK\033[0m"
    let COUNTER++

else
    echo -e "Default user shell timeout is not set to 900 seconds in /etc/profile: \033[1;31mERROR\033[0m"
    echo -e "Default user shell timeout is not set to 900 seconds in /etc/profile: \033[1;31mERROR\033[0m" >> audit-error.log

fi

if grep -q "TMOUT=900" /etc/bashrc &&
grep -q "readonly TMOUT" /etc/bashrc &&
grep -q "export TMOUT" /etc/bashrc; then

    echo -e "Default user shell timeout is set to 900 seconds in /etc/bashrc: \033[1;32mOK\033[0m"
    let COUNTER++

else
    echo -e "Default user shell timeout is not set to 900 seconds in /etc/bashrc: \033[1;31mERROR\033[0m"
    echo -e "Default user shell timeout is not set to 900 seconds in /etc/bashrc: \033[1;31mERROR\033[0m" >> audit-error.log

fi

##5.6.4 Ensure default group for the root account is GID 0 (Automated)##

if grep -q "^root:" /etc/passwd | cut -f4 -d: ;then

    echo -e "Default group for the root account is GID 0: \033[1;32mOK\033[0m"
    let COUNTER++

else 
    echo -e "Default group for the root account is not GID 0: \033[1;31mERROR\033[0m"
    echo -e "Default group for the root account is not GID 0: \033[1;31mERROR\033[0m" >> audit-error.log
fi


##5.6.5 Ensure default user umask is 027 or more restrictive (Automated)##


if test -f /etc/profile.d/set_umask.sh; then

	if grep -q "umask 027" /etc/profile.d/set_umask.sh; then

    echo -e "Default user mask is 027: \033[1;32mOK\033[0m"
    let COUNTER++

    else
        echo -e "Default user mask is not 027: \033[1;31mERROR\033[0m"
        echo -e "Default user mask is not 027: \033[1;31mERROR\033[0m" >> audit-error.log
	fi
else
    echo -e "Default user mask is not 027: \033[1;31mERROR\033[0m"
    echo -e "Default user mask is not 027: \033[1;31mERROR\033[0m" >> audit-error.log

fi

printf "Finished auditing with score: $COUNTER/52 \n"
