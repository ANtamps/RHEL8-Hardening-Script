#!/bin/bash
if modprobe -n -v sctp &> /dev/null; then
	echo -e "SCTP is disabled: \033[1;32mOK\033[0m"
else
	echo -e "SCTP is not disabled: \033[1;31mERROR\033[0m"
fi
lsmod | grep sctp

if modprobe -n -v dccp &> /dev/null; then
	echo -e "DCCP is disabled: \033[1;32mOK\033[0m"
else
	echo -e "DCCP is not disabled: \033[1;31mERROR\033[0m"
fi
lsmod | grep sctp

{
 if command -v nmcli >/dev/null 2>&1 ; then
 if nmcli radio all | grep -Eq '\s*\S+\s+disabled\s+\S+\s+disabled\b';
then
 echo -e "Wireless is not enabled: \033[1;32mOK\033[0m"
 else
 nmcli radio all
 fi
 elif [ -n "$(find /sys/class/net/*/ -type d -name wireless)" ]; then
 t=0
 mname=$(for driverdir in $(find /sys/class/net/*/ -type d -name
wireless | xargs -0 dirname); do basename "$(readlink -f
"$driverdir"/device/driver/module)";done | sort -u)
 for dm in $mname; do
 if grep -Eq "^\s*install\s+$dm\s+/bin/(true|false)"
/etc/modprobe.d/*.conf; then
 /bin/true
 else
 echo -e "$dm is not disabled: \033[1;32mOK\033[0m"
 t=1
 fi
 done
 [ "$t" -eq 0 ] && echo -e "Wireless is not enabled: \033[1;32mOK\033[0m"
 else
 echo -e "Wireless is not enabled: \033[1;32mOK\033[0m"
 fi
}

##3.3##
##3.3.1 Ensure source routed packets are not accepted (Automated)##
if test -f /etc/sysctl.d/60-netipv4_sysctl.conf; then

	if grep -q "net.ipv4.conf.all.accept_source_route = 0" /etc/sysctl.d/60-netipv4_sysctl.conf &&
		 grep -q "net.ipv4.conf.default.accept_source_route = 0" /etc/sysctl.d/60-netipv4_sysctl.conf; then
		 
		 echo -e "Source routed packets are not accepted: \033[1;32mOK\033[0m"
	else
		echo -e "Source routed packets are accepted: \033[1;31mERROR\033[0m"
	fi
else
echo -e "Source routed packets are accepted: \033[1;31mERROR\033[0m"
fi

##3.3.2 Ensure ICMP redirects are not accepted (Automated)##
if test -f /etc/sysctl.d/60-netipv4_sysctl.conf; then

	if grep -q "net.ipv4.conf.all.accept_redirects = 0" /etc/sysctl.d/60-netipv4_sysctl.conf &&
		 grep -q "net.ipv4.conf.default.accept_redirects = 0" /etc/sysctl.d/60-netipv4_sysctl.conf; then

		 echo -e "ICMP redirects are not accepted: \033[1;32mOK\033[0m"

	else
		 echo -e "ICMP redirects are accepted: \033[1;31mERROR\033[0m"
	 fi
else
echo -e "ICMP redirects are accepted: \033[1;31mERROR\033[0m"
fi

##3.3.2 Ensure secure ICMP redirects are not accepted (Automated)##
if test -f /etc/sysctl.d/60-netipv4_sysctl.conf; then

	if grep -q "net.ipv4.conf.all.secure_redirects = 0" /etc/sysctl.d/60-netipv4_sysctl.conf &&
		 grep -q "net.ipv4.conf.default.secure_redirects = 0" /etc/sysctl.d/60-netipv4_sysctl.conf; then

		 echo -e "Secure ICMP redirects are not accepted: \033[1;32mOK\033[0m"

	else
		echo -e "Secure ICMP redirects are accepted: \033[1;31mERROR\033[0m"
	 fi
else
echo -e "Secure ICMP redirects are accepted: \033[1;31mERROR\033[0m"
fi

##3.3.4 Ensure suspicious packets are logged (Automated)##
if test -f /etc/sysctl.d/60-netipv4_sysctl.conf; then

	if grep -q "net.ipv4.conf.all.log_martians = 1" /etc/sysctl.d/60-netipv4_sysctl.conf &&
		 grep -q "net.ipv4.conf.all.log_martians = 1" /etc/sysctl.d/60-netipv4_sysctl.conf; then

		 echo -e "Suspicious packets are logged: \033[1;32mOK\033[0m"

	else
		 echo -e "Suspicious packets are not logged: \033[1;31mERROR\033[0m"
	 fi
else
echo -e "Suspicious packets are not logged: \033[1;31mERROR\033[0m"
fi

##3.3.5 Ensure broadcast ICMP requests are ignored (Automated)##
if test -f /etc/sysctl.d/60-netipv4_sysctl.conf; then

	if grep -q "net.ipv4.icmp_echo_ignore_broadcasts = 1" /etc/sysctl.d/60-netipv4_sysctl.conf; then

		 echo -e "Broadcast ICMP requests are ignored: \033[1;32mOK\033[0m"
	else
		 echo -e "Broadcast ICMP requests are not ignored: \033[1;31mERROR\033[0m"
	 fi
else
echo -e "Broadcast ICMP requests are not ignored: \033[1;31mERROR\033[0m"
fi

##3.3.6 Ensure bogus ICMP responses are ignored (Automated)##
if test -f /etc/sysctl.d/60-netipv4_sysctl.conf; then

	if grep -q "net.ipv4.icmp_ignore_bogus_error_responses = 1" /etc/sysctl.d/60-netipv4_sysctl.conf; then

		 echo -e "Bogus ICMP responses are ignored: \033[1;32mOK\033[0m"
	else
		 echo -e "Bogus ICMP responses are not ignored: \033[1;31mERROR\033[0m"
	 fi
else
echo -e "Bogus ICMP responses are not ignored: \033[1;31mERROR\033[0m"
fi

##3.3.7 Ensure Reverse Path Filtering is enabled (Automated)##
if test -f /etc/sysctl.d/60-netipv4_sysctl.conf; then

	if grep -q "net.ipv4.conf.all.rp_filter = 1" /etc/sysctl.d/60-netipv4_sysctl.conf &&
		 grep -q "net.ipv4.conf.default.rp_filter = 1" /etc/sysctl.d/60-netipv4_sysctl.conf; then

		 echo -e "Reverse Path Filtering is enabled: \033[1;32mOK\033[0m"

	else
		 echo -e "Reverse Path Filtering is not enabled: \033[1;31mERROR\033[0m"
	 fi
else
echo -e "Reverse Path Filtering is not enabled: \033[1;31mERROR\033[0m"
fi

##3.3.8 Ensure TCP SYN Cookies is enabled (Automated)##
if test -f /etc/sysctl.d/60-netipv4_sysctl.conf; then

	if grep -q "net.ipv4.tcp_syncookies = 1" /etc/sysctl.d/60-netipv4_sysctl.conf; then

		 echo -e "TCP SYN Cookies is enabled: \033[1;32mOK\033[0m"

	else
		 echo -e "TCP SYN Cookies is not enabled: \033[1;31mERROR\033[0m"
	 fi
else
echo -e "TCP SYN Cookies is not enabled: \033[1;31mERROR\033[0m"
fi


##3.3.9 Ensure IPv6 router advertisements are not accepted (Automated)##
if test -f /etc/sysctl.d/60-netipv4_sysctl.conf; then

	if grep -q "net.ipv6.conf.all.accept_ra = 0" /etc/sysctl.d/60-netipv4_sysctl.conf &&
		 grep -q "net.ipv6.conf.default.accept_ra = 0" /etc/sysctl.d/60-netipv4_sysctl.conf; then

		 echo -e "IPv6 router advertisements are not accepted: \033[1;32mOK\033[0m"

	else
		 echo -e "IPv6 router advertisements are not accepted: \033[1;31mERROR\033[0m"
	 fi
else
echo -e "IPv6 router advertisements are not accepted: \033[1;31mERROR\033[0m"
fi





