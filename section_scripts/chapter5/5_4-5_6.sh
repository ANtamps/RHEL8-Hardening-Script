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

