#!/bin/bash

##5.1##

##5.1.2 Ensure permissions on /etc/crontab are configured
 chown root:root /etc/crontab
 chmod og-rwx /etc/crontab
 stat /etc/crontab
 echo "Permissions on /etc/crontab configured, continuing.."

##5.1.3 Ensure permissions on /etc/cron.hourly are configure
 chown root:root /etc/cron.hourly
 chmod og-rwx /etc/cron.hourly
 stat /etc/cron.hourly
 echo "Permissions on /etc/cron.hourly configured, continuing.."

##5.1.4 Ensure permissions on /etc/cron.daily are configured
 chown root:root /etc/cron.daily
 chmod og-rwx /etc/cron.daily
 stat /etc/cron.daily
 echo "Permissions on stat /etc/cron.daily configured, continuing.."

##5.1.5 Ensure permissions on /etc/cron.weekly are configured
 chown root:root /etc/cron.weekly
 chmod og-rwx /etc/cron.weekly
 stat /etc/cron.weekly
 echo "Permissions on stat /etc/cron.weekly configured, continuing.."

##5.1.6 Ensure permissions on /etc/cron.monthly are configured
 chown root:root /etc/cron.monthly
 chmod og-rwx /etc/cron.monthly
 stat /etc/cron.monthly
 echo "Permissions on /etc/cron.monthly configured, continuing.."

##5.1.7 Ensure permissions on /etc/cron.d are configured
 chown root:root /etc/cron.d
 chmod og-rwx /etc/cron.d
 stat /etc/cron.d
 echo "Permissions on /etc/cron.d configured, continuing.."

##5.1.8 Ensure cron is restricted to authorized users
dnf -y remove cronie
echo "removing cronie.."

##5.1.9 Ensure at is restricted to authorized users
dnf -y remove at
echo "removing at.."

#!/bin/bash

# 5.2.1 Ensure permissions on /etc/ssh/sshd_config are configured

echo "Changing file ownership for sshd_config file to root..."
chown root:root /etc/ssh/sshd_config
echo "Changing permissions for sshd_config file to owner only..."
chmod og-rwx /etc/ssh/sshd_config

# 5.2.2 Ensure permissions on SSH private host key files are configured

echo "Making ssh private keys only owner read/writable..."
find /etc/ssh -xdev -type f -name 'ssh_host_*_key' -exec chmod u=rw,g=r,o= {} \;
echo "Making ssh private keys ownership to root..."
find /etc/ssh -xdev -type f -name 'ssh_host_*_key' -exec chown root:ssh_keys {} \;

# 5.2.3 Ensure permissions on SSH public host key files are configured

echo "Making ssh public keys only owner read/writable..."
find /etc/ssh -xdev -type f -name 'ssh_host_*_key.pub' -exec chmod u=rw,go= {} \;
echo "Making ssh public keys ownership to root..."
find /etc/ssh -xdev -type f -name 'ssh_host_*_key.pub' -exec chown root:root {} \;

# 5.2.4 Ensure SSH access is limited

# 5.2.5 Ensure SSH LogLevel is appropriate

echo "Ensuring LogLevel is appropriate..."
sed -i 's/^#.*LogLevel\s.*$/LogLevel INFO/' /etc/ssh/sshd_config

# 5.2.7 Ensure SSH root login is disabled

echo "Ensuring root login is disabled..."
sed -i 's/^PermitRootLogin\s.*$/PermitRootLogin No/' /etc/ssh/sshd_config

# 5.2.8 Ensure SSH HostbasedAuthentication is disabled

echo "Ensuring Hostbasedauthentication is disabled..."
sed -i 's/^#.*HostbasedAuthentication\s.*$/HostbasedAuthentication No/' /etc/ssh/sshd_config

# 5.2.9 Ensure SSH PermitEmptyPasswords is disabled

echo "Ensuring PermitEmptyPasswords is disabled..."
sed -i 's/^PermitEmptyPasswords\s.*$/PermitEmptyPasswords No/' /etc/ssh/sshd_config

# 5.2.10 Ensure SSH PermitUserEnvironment is disabled

echo "Ensuring PermitUserEnvironment is disabled..."
sed -i 's/^#.*PermitUserEnvironment\s.*$/PermitUserEnvironment No/' /etc/ssh/sshd_config

# 5.2.11 Ensure SSH IgnoreRhosts is enabled

echo "Ensuring SSH IgnoreRhosts is enabled"
sed -i 's/^#.*IgnoreRhosts\s.*$/IgnoreRhosts Yes/' /etc/ssh/sshd_config

# 5.2.12 Ensure SSH X11 forwarding is disabled

echo "Ensuring X11 Forwarding is disabled..."
sed -i 's/^X11Forwarding\s.*$/X11Forwarding No/' /etc/ssh/sshd_config

# 5.2.13 Ensure SSH AllowTcpForwarding is disabled

echo "Ensuring AllowTcpForwarding is disabled..."
sed -i 's/^#.*AllowTcpForwarding\s.*$/AllowTcpForwarding No/' /etc/ssh/sshd_config

# 5.2.14 Ensure system-wide crypto policy is not over-ridden

echo "Ensuring crypto policy is not over-ridden"
sed -ri "s/^\s*(CRYPTO_POLICY\s*=.*)$/# \1/" /etc/sysconfig/sshd

systemctl reload sshd

# 5.2.15 Ensure SSH warning banner is configured

echo  "Ensuring warning banner is configured"
sed -i "s/\#Banner none/Banner \/etc\/issue\.net/" /etc/ssh/sshd_config

# 5.2.16 Ensure SSH MaxAuthTries is set to 4 or less

echo "Ensuring MaxAuthTries set to 4 or less"
sed -i 's/^#.*MaxAuthTries\s.*$/MaxAuthTries 4/' /etc/ssh/sshd_config

# 5.2.17 Ensure SSH MaxStartups is configured

echo "Ensuring MaxStartups is configured..."
sed -i 's/^#.*MaxStartups\s.*$/MaxStartups 10:30:60/' /etc/ssh/sshd_config

# 5.2.18 Ensure SSH MaxSessions is set to 10 or less

echo "Ensuring MaxSessions is set to 10 or less..."
sed -i 's/^#.*MaxSessions\s.*$/MaxSessions 10/' /etc/ssh/sshd_config

# 5.2.19 Ensure SSH LoginGraceTime is set to one minute or less

echo "Ensuring LoginGraceTime set to 1 minute or less..."
sed -i 's/^#.*LoginGraceTime\s.*$/LoginGraceTime 60/' /etc/ssh/sshd_config

# 5.2.20 Ensure SSH Idle Timeout Interval is configured

echo "Ensuring IdleTimeOutInterval is configured..."
sed -i 's/^#.*ClientAliveInterval\s.*$/ClientAliveInterval 900/' /etc/ssh/sshd_config

sed -i 's/^#.*ClientAliveCountMax\s.*$/ClientAliveCountMax 0/' /etc/ssh/sshd_config
#!/bin/bash

##5.3

##5.3.1 Ensure sudo is installed
if rpm -q sudo &> /dev/null; then
    dnf list sudo
    echo "sudo installed, continuing..."
else   
    echo "sudo not found, installing..."
     dnf -y install sudo &> /dev/null
     dnf list sudo
fi

##5.3.2 Ensure sudo commands use pty
if grep -q "/etc/suduoers:Defaults use_pty" /etc/suduoers; then

echo "pty is in use, continuing.."

else
echo -e "/etc/suduoers:Defaults use_pty" >>/etc/suduoers

fi

##5.3.3 Ensure sudo log file exists
if grep -q "Defaults logfile=/var/log/sudo.log" /etc/suduoers; then

echo "sudo log file exists.."

else
echo -e "Defaults logfile=/var/log/sudo.log" >>/etc/suduoers

fi
 
##5.3.4 Ensure users must provide password for escalation
if grep -q "NOPASSWD" /etc/suduoers; then

echo -e "NOPASSWD still exists, removing.."
   sed '/NOPASSWD/d' /etc/suduoers

else
  sed '/NOPASSWD/d' /etc/suduoers
echo -e "NOPASSWD removed from the lines, continuing.."

fi

##5.3.5 Ensure re-authentication for privilege escalation is not disabled globally
if grep -q "!authenticate" /etc/suduoers; then

echo -e "!authenticate still exists, removing.."
  sed '/!authenticate/d' /etc/suduoers
   
else
  sed '/!authenticate/d' /etc/suduoers
echo -e "!authenticate  removed from the lines, continuing.."

fi

##5.3.6 Ensure sudo authentication timeout is configured correctly
sed -i 's/Defaults    env_reset/Defaults    env_reset, timestamp_timeout=15/g' /etc/suduoers
echo -e "sudo authentication timeout is configured correctly, continuing.."

##5.3.7 Ensure access to the su command is restricted
if grep sugroup /etc/group; then
groupadd sugroup
echo "empty group added, continuing"

else
echo "empty group does not exist, adding.."
groupadd sugroup

fi
#!/bin/bash

##5.4.2 Ensure authselect includes with-faillock (Automated)##

if grep pam_faillock.so /etc/pam.d/password-auth /etc/pam.d/system-auth &> /dev/null; then
	
	echo "Authselect includes with-faillock... Continuing..."

else
	authselect enable-feature with-faillock
	authselect apply-changes
fi

	
##5.5.1 Ensure password creation requirements are configured(Automated)##

if grep -q "minlen = 14" /etc/security/pwquality.conf &&
grep -q "minclass = 4" /etc/security/pwquality.conf &&
grep -q "dcredit = -1" /etc/security/pwquality.conf &&
grep -q "ucredit = -1" /etc/security/pwquality.conf &&
grep -q "ocredit = -1" /etc/security/pwquality.conf &&
grep -q "lcredit = -1" /etc/security/pwquality.conf; then

echo "Password creation requirements are configured... Continuing..." 

else

echo -e "minlen = 14\nminclass = 4\ndcredit = -1\nucredit = -1\nocredit = -1\nlcredit = -1" >> /etc/security/pwquality.conf

fi


##5.5.2 Ensure lockout for failed password attempts is configured(Automated)##

if grep -qw "deny = 5" /etc/security/faillock.conf &&
grep -qw "unlock_time = 900" /etc/security/faillock.conf; then

	echo "Lockout for failed password attempts is configured... Continuing..."

else 
	echo "deny = 5" >> /etc/security/faillock.conf
	echo "unlock_time = 900" >> /etc/security/faillock.conf
fi


##5.5.3 Ensure password reuse is limited (Automated)##

##5.5.4 Ensure password hashing algorithm is SHA-512 (Automated)##

if grep -Ei -q '^\s*crypt_style\s*=\s*sha512\b' /etc/libuser.conf; then

echo "Configured hashing algorithm is sha512 in /etc/libuser.conf... Continuing..."

else 
echo "crypt_style = sha512" >> /etc/libuser.conf

fi

if grep -Ei -q '^\s*ENCRYPT_METHOD\s+SHA512\b' /etc/login.defs; then 

echo "Configured hashing algorithm is sha512 in /etc/login.defs... Continuing..."

else 
echo "ENCRYPT_METHOD SHA512" >> /etc/login.defs

fi


##5.6.1.1 Ensure password expiration is 365 days or less (Automated)##

if grep -qw 'PASS_MAX_DAYS   365' /etc/login.defs; then

echo "Password expiration is set to 365 days... Continuing..."

else
sed -i 's/PASS_MAX_DAYS   99999/PASS_MAX_DAYS   365/' /etc/login.defs
fi

##5.6.1.2 Ensure minimum days between password changes is 7 or more(Automated)##

if grep -qw "PASS_MIN_DAYS   7" /etc/login.defs; then

echo "Minimum days between password changes is set to 7... Continuing..."

else
sed -i 's/PASS_MIN_DAYS   0/PASS_MIN_DAYS   7/' /etc/login.defs
fi

##5.6.1.3 Ensure password expiration warning days is 7 or more(Automated)##

if grep -qw "PASS_WARN_AGE   7" /etc/login.defs; then

echo "Password expiration warning days is set to 7... Continuing..."

else
sed -i 's/PASS_WARN_AGE   7/PASS_WARN_AGE   7/' /etc/login.defs
fi

##5.6.1.4 Ensure inactive password lock is 30 days or less (Automated)##

if useradd -D | grep -qw "INACTIVE=30"; then

echo "Inactive password lock is set to 30 days... Continuing..."

else
useradd -D -f 30
fi

##5.6.1.5 Ensure all users last password change date is in the past##
## Manual Remediation ##

##5.6.2 Ensure system accounts are secured (Automated)##

##5.6.3 Ensure default user shell timeout is 900 seconds or less(Automated)##

if grep -q "TMOUT=900" /etc/profile &&
grep -q "readonly TMOUT" /etc/profile &&
grep -q "export TMOUT" /etc/profile; then

echo "Default user shell timeout is set to 900 seconds... Continuing..."

else
echo -e "TMOUT=900\nreadonly TMOUT\nexport TMOUT" >> /etc/profile

fi

if grep -q "TMOUT=900" /etc/bashrc &&
grep -q "readonly TMOUT" /etc/bashrc &&
grep -q "export TMOUT" /etc/bashrc; then

echo "Default user shell timeout is set to 900 seconds... Continuing..."

else
echo -e "TMOUT=900\nreadonly TMOUT\nexport TMOUT" >> /etc/bashrc

fi

##5.6.4 Ensure default group for the root account is GID 0 (Automated)##

if grep -q "^root:" /etc/passwd | cut -f4 -d: ;then

echo "Default group for the root account is GID 0... Continuing..."

else 
usermod -g 0 root
fi


##5.6.5 Ensure default user umask is 027 or more restrictive (Automated)##

if test -f /etc/profile.d/set_umask.sh; then

	if grep -q "umask 027" /etc/profile.d/set_umask.sh; then

echo "Default user mask is 027... Continuing..."

	else
echo "umask 027" > /etc/profile.d/set_umask.sh
fi
else

touch /etc/profile.d/set_umask.sh
echo "umask 027" > /etc/profile.d/set_umask.sh

fi

