#!/bin/bash

##5.4.2 Ensure authselect includes with-faillock (Automated)##

if grep pam_faillock.so /etc/pam.d/password-auth /etc/pam.d/system-auth &> /dev/null; then
	
	echo -e "Authselect includes with-faillock: \033[1;32mOK\033[0m"

else
	echo -e "Authselect does not includes with-faillock: \033[1;31mERROR\033[0m"
fi

	
##5.5.1 Ensure password creation requirements are configured(Automated)##

if grep -q "minlen = 14" /etc/security/pwquality.conf &&
grep -q "minclass = 4" /etc/security/pwquality.conf &&
grep -q "dcredit = -1" /etc/security/pwquality.conf &&
grep -q "ucredit = -1" /etc/security/pwquality.conf &&
grep -q "ocredit = -1" /etc/security/pwquality.conf &&
grep -q "lcredit = -1" /etc/security/pwquality.conf; then

echo -e "Password creation requirements are configured: \033[1;32mOK\033[0m" 

else

echo -e "Password creation requirements are not configured: \033[1;31mERROR\033[0m" 

fi


##5.5.2 Ensure lockout for failed password attempts is configured(Automated)##

if grep -qw "deny = 5" /etc/security/faillock.conf &&
grep -qw "unlock_time = 900" /etc/security/faillock.conf; then

	echo -e "Lockout for failed password attempts is configured: \033[1;32mOK\033[0m"

else 
	echo -e "Lockout for failed password attempts is not configured: \033[1;31mERROR\033[0m"
fi


##5.5.3 Ensure password reuse is limited (Automated)##

##5.5.4 Ensure password hashing algorithm is SHA-512 (Automated)##

if grep -Ei -q '^\s*crypt_style\s*=\s*sha512\b' /etc/libuser.conf; then

echo -e "Configured hashing algorithm is sha512 in /etc/libuser.conf: \033[1;32mOK\033[0m"

else 
echo -e "Hashing algorithm is not sha512 in /etc/libuser.conf: \033[1;31mERROR\033[0m"

fi

if grep -Ei -q '^\s*ENCRYPT_METHOD\s+SHA512\b' /etc/login.defs; then 

echo -e "Configured hashing algorithm is sha512 in /etc/login.defs: \033[1;32mOK\033[0m"

else 
echo -e "Hashing algorithm is not sha512 in /etc/login.defs: \033[1;31mERROR\033[0m"

fi


##5.6.1.1 Ensure password expiration is 365 days or less (Automated)##

if grep -qw "PASS_MAX_DAYS   365" /etc/login.defs; then

echo -e "Password expiration is set to 365 days: \033[1;32mOK\033[0m"

else
echo -e "Password expiration is not set to 365 days: \033[1;31mERROR\033[0m"
fi

##5.6.1.2 Ensure minimum days between password changes is 7 or more(Automated)##

if grep -qw "PASS_MIN_DAYS   7" /etc/login.defs; then

echo -e "Minimum days between password changes is set to 7: \033[1;32mOK\033[0m"

else
echo -e "Minimum days between password changes is not set to 7: \033[1;31mERROR\033[0m"
fi

##5.6.1.3 Ensure password expiration warning days is 7 or more(Automated)##

if grep -qw "PASS_WARN_AGE   7" /etc/login.defs; then

echo -e "Password expiration warning days is set to 7: \033[1;32mOK\033[0m"

else
echo -e "Password expiration warning days is not set to 7: \033[1;31mERROR\033[0m"
fi

##5.6.1.4 Ensure inactive password lock is 30 days or less (Automated)##

if useradd -D | grep -qw "INACTIVE=30"; then

echo -e "Inactive password lock is set to 30 days: \033[1;32mOK\033[0m"

else
echo -e "Inactive password lock is not set to 30 days: \033[1;31mERROR\033[0m"
fi

##5.6.1.5 Ensure all users last password change date is in the past(Automated)##
## Manual Remediation for Scripting ##
if awk -F: '/^[^:]+:[^!*]/{print $1}' /etc/shadow | while read -r usr; \
do change=$(date -d "$(chage --list $usr | grep '^Last password change' | cut -d: -f2 | grep -v 'never$')" +%s); \
if [[ "$change" -gt "$(date +%s)" ]]; then \
echo "User: \"$usr\" last password change was \"$(chage --list $usr | grep
'^Last password change' | cut -d: -f2)\""; fi; done;then

echo -e "All users last password change date is in the past: \033[1;32mOK\033[0m"

else
echo -e "Some users last password change date is in the future: \033[1;31mERROR\033[0m"
fi

##5.6.2 Ensure system accounts are secured (Automated)##

##5.6.3 Ensure default user shell timeout is 900 seconds or less(Automated)##

if grep -q "TMOUT=900" /etc/profile &&
grep -q "readonly TMOUT" /etc/profile &&
grep -q "export TMOUT" /etc/profile; then

echo -e "Default user shell timeout is set to 900 seconds in /etc/profile: \033[1;32mOK\033[0m"

else
echo -e "Default user shell timeout is not set to 900 seconds in /etc/profile: \033[1;31mERROR\033[0m"

fi

if grep -q "TMOUT=900" /etc/bashrc &&
grep -q "readonly TMOUT" /etc/bashrc &&
grep -q "export TMOUT" /etc/bashrc; then

echo -e "Default user shell timeout is set to 900 seconds in /etc/bashrc: \033[1;32mOK\033[0m"

else
echo -e "Default user shell timeout is not set to 900 seconds in /etc/bashrc: \033[1;31mERROR\033[0m"

fi

##5.6.4 Ensure default group for the root account is GID 0 (Automated)##

if grep -q "^root:" /etc/passwd | cut -f4 -d: ;then

echo -e "Default group for the root account is GID 0: \033[1;32mOK\033[0m"

else 
echo -e "Default group for the root account is not GID 0: \033[1;31mERROR\033[0m"
fi


##5.6.5 Ensure default user umask is 027 or more restrictive (Automated)##


if test -f /etc/profile.d/set_umask.sh; then

	if grep -q "umask 027" /etc/profile.d/set_umask.sh; then

echo -e "Default user mask is 027: \033[1;32mOK\033[0m"

	else
echo -e "Default user mask is not 027: \033[1;31mERROR\033[0m"
fi
else
echo -e "Default user mask is not 027: \033[1;31mERROR\033[0m"

fi


