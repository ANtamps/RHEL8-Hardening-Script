#!/bin/bash
##3.1.2 Ensure SCTP is disabled (Automated)##
if test -f /etc/modprobe.d/sctp.conf; then 

	if grep -q "install sctp /bin/true" /etc/modprobe.d/sctp.conf; then
	
	echo "SCTP is disabled... Continuing..."

	else 
	printf "
	install sctp /bin/true
	" >> /etc/modprobe.d/sctp.conf
	fi

else 
touch /etc/modprobe.d/sctp.conf
printf "
	install sctp /bin/true
	" >> /etc/modprobe.d/sctp.conf
fi

##3.1.3 Ensure DCCP is disabled (Automated)##
if test -f /etc/modprobe.d/dccp.conf; then 

	if grep -q "install dccp /bin/true" /etc/modprobe.d/dccp.conf; then
	
	echo "DCCP is disabled... Continuing..."

	else 
	printf "
	install dccp /bin/true
	" >> /etc/modprobe.d/dccp.conf
	fi

else 
touch /etc/modprobe.d/dccp.conf
printf "
	install dccp /bin/true
	" >> /etc/modprobe.d/dccp.conf
fi

##3.1.4 Ensure wireless interfaces are disabled (Automated)##
#!/usr/bin/env bash
{
 if command -v nmcli >/dev/null 2>&1 ; then
 nmcli radio all off
 echo "Disabled wireless interface.. Continuing... "
 else
 if [ -n "$(find /sys/class/net/*/ -type d -name wireless)" ]; then
 mname=$(for driverdir in $(find /sys/class/net/*/ -type d -name
wireless | xargs -0 dirname); do basename "$(readlink -f
"$driverdir"/device/driver/module)";done | sort -u)
 for dm in $mname; do echo "install $dm /bin/true" >> /etc/modprobe.d/disable_wireless.conf
 done
 fi
 echo "Disabled wireless interface.. Continuing... "
 fi
}


##3.3##
##3.3.1 Ensure source routed packets are not accepted (Automated)##
if test -f /etc/sysctl.d/60-netipv4_sysctl.conf; then

	if grep -q "net.ipv4.conf.all.accept_source_route = 0" /etc/sysctl.d/60-netipv4_sysctl.conf &&
		 grep -q "net.ipv4.conf.default.accept_source_route = 0" /etc/sysctl.d/60-netipv4_sysctl.conf; then
		 
		 echo "Source routed packets are not accepted... Continuing..."
	else
			printf "
			net.ipv4.conf.all.accept_source_route = 0
			net.ipv4.conf.default.accept_source_route = 0
			" >> /etc/sysctl.d/60-netipv4_sysctl.conf
	fi
else
touch /etc/sysctl.d/60-netipv4_sysctl.conf
printf "
			net.ipv4.conf.all.accept_source_route = 0
			net.ipv4.conf.default.accept_source_route = 0
			" >> /etc/sysctl.d/60-netipv4_sysctl.conf
fi

{
 sysctl -w net.ipv4.conf.all.accept_source_route=0
 sysctl -w net.ipv4.conf.default.accept_source_route=0
 sysctl -w net.ipv4.route.flush=1
}

##3.3.2 Ensure ICMP redirects are not accepted (Automated)##
if test -f /etc/sysctl.d/60-netipv4_sysctl.conf; then

	if grep -q "net.ipv4.conf.all.accept_redirects = 0" /etc/sysctl.d/60-netipv4_sysctl.conf &&
		 grep -q "net.ipv4.conf.default.accept_redirects = 0" /etc/sysctl.d/60-netipv4_sysctl.conf; then

		 echo "ICMP redirects are not accepted... Continuing..."

	else
		 printf "
		 net.ipv4.conf.all.accept_redirects = 0
		 net.ipv4.conf.default.accept_redirects = 0
		 " >> /etc/sysctl.d/60-netipv4_sysctl.conf
	 fi
else
touch /etc/sysctl.d/60-netipv4_sysctl.conf	
printf "
	net.ipv4.conf.all.accept_redirects = 0
	net.ipv4.conf.default.accept_redirects = 0
	" >> /etc/sysctl.d/60-netipv4_sysctl.conf
fi

{
 sysctl -w net.ipv4.conf.all.accept_redirects=0
 sysctl -w net.ipv4.conf.default.accept_redirects=0
 sysctl -w net.ipv4.route.flush=1
}

##3.3.2 Ensure secure ICMP redirects are not accepted (Automated)##
if test -f /etc/sysctl.d/60-netipv4_sysctl.conf; then

	if grep -q "net.ipv4.conf.all.secure_redirects = 0" /etc/sysctl.d/60-netipv4_sysctl.conf &&
		 grep -q "net.ipv4.conf.default.secure_redirects = 0" /etc/sysctl.d/60-netipv4_sysctl.conf; then

		 echo "Secure ICMP redirects are not accepted... Continuing..."

	else
		 printf "
		 net.ipv4.conf.all.secure_redirects = 0
		 net.ipv4.conf.default.secure_redirects = 0
		 " >> /etc/sysctl.d/60-netipv4_sysctl.conf
	 fi
else
touch /etc/sysctl.d/60-netipv4_sysctl.conf	
printf "
	net.ipv4.conf.all.secure_redirects = 0
	net.ipv4.conf.default.secure_redirects = 0
	" >> /etc/sysctl.d/60-netipv4_sysctl.conf
fi

{
 sysctl -w net.ipv4.conf.all.secure_redirects=0
 sysctl -w net.ipv4.conf.default.secure_redirects=0
 sysctl -w net.ipv4.route.flush=1
}

##3.3.4 Ensure suspicious packets are logged (Automated)##
if test -f /etc/sysctl.d/60-netipv4_sysctl.conf; then

	if grep -q "net.ipv4.conf.all.log_martians = 1" /etc/sysctl.d/60-netipv4_sysctl.conf &&
		 grep -q "net.ipv4.conf.all.log_martians = 1" /etc/sysctl.d/60-netipv4_sysctl.conf; then

		 echo "Suspicious packets are logged... Continuing..."

	else
		 printf "
		 net.ipv4.conf.all.log_martians = 1
		 net.ipv4.conf.all.log_martians = 1
		 " >> /etc/sysctl.d/60-netipv4_sysctl.conf
	 fi
else
touch /etc/sysctl.d/60-netipv4_sysctl.conf	
printf "
	net.ipv4.conf.all.log_martians = 1
	net.ipv4.conf.all.log_martians = 1
	" >> /etc/sysctl.d/60-netipv4_sysctl.conf
fi

{
 sysctl -w net.ipv4.conf.all.log_martians=1
 sysctl -w net.ipv4.conf.default.log_martians=1
 sysctl -w net.ipv4.route.flush=1
}

##3.3.5 Ensure broadcast ICMP requests are ignored (Automated)##
if test -f /etc/sysctl.d/60-netipv4_sysctl.conf; then

	if grep -q "net.ipv4.icmp_echo_ignore_broadcasts = 1" /etc/sysctl.d/60-netipv4_sysctl.conf; then

		 echo "Broadcast ICMP redirects are ignored... Continuing..."

	else
		 printf "
		 net.ipv4.icmp_echo_ignore_broadcasts = 1
		 " >> /etc/sysctl.d/60-netipv4_sysctl.conf
	 fi
else
touch /etc/sysctl.d/60-netipv4_sysctl.conf	
printf "
	net.ipv4.icmp_echo_ignore_broadcasts = 1
	" >> /etc/sysctl.d/60-netipv4_sysctl.conf
fi

{
 sysctl -w net.ipv4.icmp_echo_ignore_broadcasts=1
 sysctl -w net.ipv4.route.flush=1
}

##3.3.6 Ensure bogus ICMP responses are ignored (Automated)##
if test -f /etc/sysctl.d/60-netipv4_sysctl.conf; then

	if grep -q "net.ipv4.icmp_ignore_bogus_error_responses = 1" /etc/sysctl.d/60-netipv4_sysctl.conf; then

		 echo "Bogus ICMP responses are ignored... Continuing..."

	else
		 printf "
		 net.ipv4.icmp_ignore_bogus_error_responses = 1
		 " >> /etc/sysctl.d/60-netipv4_sysctl.conf
	 fi
else
touch /etc/sysctl.d/60-netipv4_sysctl.conf	
printf "
	net.ipv4.icmp_ignore_bogus_error_responses = 1
	" >> /etc/sysctl.d/60-netipv4_sysctl.conf
fi

{
 sysctl -w net.ipv4.icmp_ignore_bogus_error_responses=1
 sysctl -w net.ipv4.route.flush=1
}

##3.3.7 Ensure Reverse Path Filtering is enabled (Automated)##
if test -f /etc/sysctl.d/60-netipv4_sysctl.conf; then

	if grep -q "net.ipv4.conf.all.rp_filter = 1" /etc/sysctl.d/60-netipv4_sysctl.conf &&
		 grep -q "net.ipv4.conf.default.rp_filter = 1" /etc/sysctl.d/60-netipv4_sysctl.conf; then

		 echo "Reverse Path Filtering is enabled... Continuing..."

	else
		 printf "
		 net.ipv4.conf.all.rp_filter = 1
		 net.ipv4.conf.default.rp_filter = 1
		 " >> /etc/sysctl.d/60-netipv4_sysctl.conf
	 fi
else
touch /etc/sysctl.d/60-netipv4_sysctl.conf	
printf "
	net.ipv4.conf.all.rp_filter = 1
	net.ipv4.conf.default.rp_filter = 1
	" >> /etc/sysctl.d/60-netipv4_sysctl.conf
fi

{
 sysctl -w net.ipv4.conf.all.rp_filter=1
 sysctl -w net.ipv4.conf.default.rp_filter=1
 sysctl -w net.ipv4.route.flush=1
}

##3.3.8 Ensure TCP SYN Cookies is enabled (Automated)##
if test -f /etc/sysctl.d/60-netipv4_sysctl.conf; then

	if grep -q "net.ipv4.tcp_syncookies = 1" /etc/sysctl.d/60-netipv4_sysctl.conf; then

		 echo "TCP SYN Cookies is enabled... Continuing..."

	else
		 printf "
		 net.ipv4.tcp_syncookies = 1
		 " >> /etc/sysctl.d/60-netipv4_sysctl.conf
	 fi
else
touch /etc/sysctl.d/60-netipv4_sysctl.conf	
printf "
	net.ipv4.tcp_syncookies = 1
	" >> /etc/sysctl.d/60-netipv4_sysctl.conf
fi

{
 sysctl -w net.ipv4.tcp_syncookies=1
 sysctl -w net.ipv4.route.flush=1
}

##3.3.9 Ensure IPv6 router advertisements are not accepted (Automated)##
if test -f /etc/sysctl.d/60-netipv4_sysctl.conf; then

	if grep -q "net.ipv6.conf.all.accept_ra = 0" /etc/sysctl.d/60-netipv4_sysctl.conf &&
		 grep -q "net.ipv6.conf.default.accept_ra = 0" /etc/sysctl.d/60-netipv4_sysctl.conf; then

		 echo "IPv6 router advertisments are not accepted... Continuing..."

	else
		 printf "
		 net.ipv6.conf.all.accept_ra = 0
		 net.ipv6.conf.default.accept_ra = 0
		 " >> /etc/sysctl.d/60-netipv4_sysctl.conf
	 fi
else
touch /etc/sysctl.d/60-netipv4_sysctl.conf	
printf "
	net.ipv6.conf.all.accept_ra = 0
	net.ipv6.conf.default.accept_ra = 0
	" >> /etc/sysctl.d/60-netipv4_sysctl.conf
fi

{
 sysctl -w net.ipv6.conf.all.accept_ra=0
 sysctl -w net.ipv6.conf.default.accept_ra=0
 sysctl -w net.ipv6.route.flush=1
}


