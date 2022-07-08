#!/bin/bash

COUNTER=0

##3.1
if modprobe -n -v sctp &> /dev/null; then
	echo -e "SCTP is disabled: \033[1;32mOK\033[0m"
	 let COUNTER++
else
	echo -e "SCTP is not disabled: \033[1;31mERROR\033[0m"
fi
lsmod | grep sctp

if modprobe -n -v dccp &> /dev/null; then
	echo -e "DCCP is disabled: \033[1;32mOK\033[0m"
	let COUNTER++	
else
	echo -e "DCCP is not disabled: \033[1;31mERROR\033[0m"
fi
lsmod | grep sctp

{
 if command -v nmcli >/dev/null 2>&1 ; then
 if nmcli radio all | grep -Eq '\s*\S+\s+disabled\s+\S+\s+disabled\b';then
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

##3.2
if cat /etc/sysctl.d/60-netipv4_sysctl.conf | grep "net.ipv4.ip_forward = 0" &> /dev/null; then
    echo "IPv4 forwarding is disabled: \033[1;32mOK\033[0m"
    let COUNTER++
    if sysctl net.ipv4.ip_forward | grep "net.ipv4.ip_forward = 0" &> /dev/null; then
        echo "Kernel parameter for ip forwarding set to 0: \033[1;32mOK\033[0m"
         let COUNTER++
	else
        echo "Kernel parameter for ip forwarding not set to 0: \033[1;31mERROR\033[0m"
    fi

     if sysctl net.ipv4.route.flush | grep "net.ipv4.route.flush = 1" &> /dev/null; then
        echo "Kernel parameter for route flush set to 1: \033[1;32mOK\033[0m"
	 let COUNTER++
    else
        echo "Kernel parameter for route flush not set to 1: \033[1;31mERROR\033[0m"
    fi
else
    echo "IPv4 forwarding might be enabled: \033[1;31mERROR\033[0m"
fi


# If IPv6 is enabled, uncomment this

# if cat /etc/sysctl.d/60-netipv6_sysctl.conf | grep "net.ipv6.conf.all.forwarding = 0" &> /dev/null; then
#     echo "IPv6 forwarding is disabled: \033[1;32mOK\033[0m"

#     if sysctl net.ipv6.conf.all.forwarding | grep "net.ipv6.conf.all.forwarding = 0" &> /dev/null; then
#         echo "Kernel parameter for ipv6 forwarding set to 0: \033[1;32mOK\033[0m"
#     else
#        echo "Kernel parameter for ip forwarding not set to 0: \033[1;31mERROR\033[0m"
#     fi

#      if sysctl net.ipv6.route.flush | grep "net.ipv6.route.flush = 1" &> /dev/null; then
#         echo "Kernel parameter for route flush set to 1: \033[1;32mOK\033[0m"
#     else
#         echo "Kernel parameter for route flush not set to 1: \033[1;31mERROR\033[0m"
#     fi
# else
#     echo "IPv6 forwarding might be enabled: \033[1;31mERROR\033[0m"
# fi

if cat /etc/sysctl.d/60-netipv4_syctl.conf | grep "net.ipv4.conf.all.send_redirects = 0" &> /dev/null; then
    echo "Packet redirecting all set to 0: \033[1;32mOK\033[0m"
    let COUNTER++
    if sysctl net.ipv4.conf.all.send_redirects | grep "net.ipv4.conf.all.send_redirects = 0" &> /dev/null; then
        echo "Packet redirecting all set to 0 in kernel parameters: \033[1;32mOK\033[0m"
 	let COUNTER++    	
    else
        echo "Kernel parameter not set for packet redirecting: \033[1;31mERROR\033[0m"
    fi
else
    echo "Packet redirecting might not be set to 0: \033[1;31mERROR\033[0m"
fi

if cat /etc/sysctl.d/60-netipv4_syctl.conf | grep "net.ipv4.conf.default.send_redirects = 0" &> /dev/null; then
    echo "Packet redirecting default set to 0: \033[1;32mOK\033[0m"
     let COUNTER++
    if sysctl net.ipv4.conf.default.send_redirects | grep "net.ipv4.conf.default.send_redirects = 0" &> /dev/null; then
        echo "Packet redirecting default set to 0 in kernel parameters: \033[1;32mOK\033[0m"
    	 let COUNTER++
	else
        echo "Kernel parameter not set for packet redirecting: \033[1;31mERROR\033[0m"
    fi
else
    echo "Default redirect might not be set to 0: \033[1;31mERROR\033[0m" 
fi

##3.3##
##3.3.1 Ensure source routed packets are not accepted (Automated)##
if test -f /etc/sysctl.d/60-netipv4_sysctl.conf; then

	if grep -q "net.ipv4.conf.all.accept_source_route = 0" /etc/sysctl.d/60-netipv4_sysctl.conf &&
		 grep -q "net.ipv4.conf.default.accept_source_route = 0" /etc/sysctl.d/60-netipv4_sysctl.conf; then

		 echo -e "Source routed packets are not accepted: \033[1;32mOK\033[0m"
		 let COUNTER++
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
		 let COUNTER++
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
		 let COUNTER++
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
		 let COUNTER++
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
		 let COUNTER++
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
		 let COUNTER++
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
		 let COUNTER++
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
		 let COUNTER++
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
		 let COUNTER++
	else
		 echo -e "IPv6 router advertisements are not accepted: \033[1;31mERROR\033[0m"
	 fi
else
echo -e "IPv6 router advertisements are not accepted: \033[1;31mERROR\033[0m"
fi

##3.4.1

##3.4.1.1 Ensure firewalld is installed
if rpm -q firewalld iptables &> /dev/null; then
    echo -e "firewalld and iptables installed: \033[1;32mOK\033[0m"
     let COUNTER++
else   
     echo -e "firewalld and iptables not found: \033[1;31mERROR\033[0m"

fi
##3.4.1.2 Ensure iptables-services not installed with firewalld
if rpm -q iptables-services &> /dev/null; then
    echo -e "package iptables-services found: \033[1;31mERROR\033[0m"
     let COUNTER++
else   
   echo -e "package iptables-services not installed: \033[1;32mOK\033[0m"
fi

##3.4.1.3 Ensure nftables either not installed or masked with firewalld 
if  rpm -q nftables &> /dev/null; then
     echo -e "package nftables not installed: \033[1;32mOK\033[0m"
     let COUNTER++
else   
     echo -e "package nftables found: \033[1;31mERROR\033[0m"

fi

##3.4.1.4 Ensure firewalld service enabled and running
if  systemctl is-enabled firewalld &> /dev/null; then
    echo -e "Enabled: \033[1;32mOK\033[0m"
     let COUNTER++
else   
    echo -e "Not enabled: \033[1;31mERROR\033[0m"
fi

if  firewall-cmd --state &> /dev/null; then
    echo -e "Running: \033[1;32mOK\033[0m"
    let COUNTER++
else   
    echo -e "Not running: \033[1;31mERROR\033[0m"
fi

##3.4.1.5 Ensure firewalld default zone is set 

if   firewall-cmd --get-default-zone &> /dev/null; then
    echo -e "Zone is set: \033[1;32mOK\033[0m"
    let COUNTER++
else   
    echo -e "No zone found: \033[1;31mERROR\033[0m"
fi

##3.4.2

##3.4.2.1 Ensure nftables is installed (Automated)

if  rpm -q nftables &> /dev/null; then
    echo -e "nftables installed: \033[1;32mOK\033[0m"
    let COUNTER++
else   
     echo -e "nftable not found: \033[1;31mERROR\033[0m"

fi
##3.4.2.2 Ensure firewalld is either not installed or masked with nftables 
if   systemctl is-enabled firewalld &> /dev/null; then
    echo -e "firewalld unmasked: \033[1;31mERROR\033[0m"
     let COUNTER++
else   
   echo -e "firewalld nmasked: \033[1;32mOK\033[0m"
fi
##3.4.2.3 Ensure iptables-services not installed with nftables
if  rpm -q iptables-services &> /dev/null; then
     echo -e "package iptables-services found: \033[1;31mERROR\033[0m"
     let COUNTER++
else   
     echo -e "package iptables-services not installed: \033[1;32mOK\033[0m"
fi

##3.4.2.4 Ensure iptables are flushed with nftables (Manual)

##3.4.2.5 Ensure an nftables table exists
 nft list tables
echo -e  "nftables table exists: \033[1;32mOK\033[0m"
 let COUNTER++

##3.4.2.6 Ensure nftables base chains exist

if   nft list ruleset | grep 'hook input' &> /dev/null; then
     echo -e "type filter hook input priority 0: \033[1;32mOK\033[0m"
     let COUNTER++
else   
     echo -e "type filter hook input priority 0 not found: \033[1;31mERROR\033[0m"

fi

if    nft list ruleset | grep 'hook forward' &> /dev/null; then
     echo -e "type filter hook forward priority 0: \033[1;32mOK\033[0m"  
     let COUNTER++
else   
     echo -e "type filter hook forward priority 0 not found: \033[1;31mERROR\033[0m"

fi

if     nft list ruleset | grep 'hook output' &> /dev/null; then
     echo -e "type filter hook output priority 0: \033[1;32mOK\033[0m"
     let COUNTER++
else   
     echo -e "type filter hook output priority 0 not found: \033[1;31mERROR\033[0m"

fi


##3.4.2.7 Ensure nftables loopback traffic is configured

if     nft list ruleset | awk '/hook input/,/}/' | grep 'iif "lo" accept' &> /dev/null; then
     echo -e "loopback interface configured: \033[1;32mOK\033[0m"
     let COUNTER++
else   
     echo -e "loopback interface configured: \033[1;31mERROR\033[0m"

fi



##3.4.2.8 Ensure nftables outbound and established connections are configured (Manual)

##3.4.2.9 Ensure nftables default deny firewall policy (Automated)

if     nft list ruleset | grep 'hook input' &> /dev/null; then
     echo -e "type filter hook input priority 0; policy drop configured: \033[1;32mOK\033[0m"
     let COUNTER++
else   
     echo -e "type filter hook input priority 0; policy drop not configured: \033[1;31mERROR\03$"

fi

if     nft list ruleset | grep 'hook forward' &> /dev/null; then
     echo -e "type filter hook forward priority 0; policy drop configured: \033[1;32mOK\033[0m"
     let COUNTER++
else   
     echo -e "type filter hook forward priority 0; policy drop not configured: \033[1;31mERROR\$"

fi

if     nft list ruleset | grep 'hook output' &> /dev/null; then
     echo -e "type filter hook output priority 0; policy drop configured: \033[1;32mOK\033[0m"
     let COUNTER++
else   
     echo -e "type filter hook output priority 0; policy drop not configured: \033[1;31mERROR\0$"

fi

##3.4.2.10 Ensure nftables service is enabled## 
if     systemctl is-enabled nftables &> /dev/null; then
     echo -e "nftables services enabled: \033[1;32mOK\033[0m"
     let COUNTER++
else   
     echo -e "nftables services not enabled: \033[1;31mERROR\033[0m"

fi

if rpm -q iptables ip tables-services &> /dev/null; then
    echo -e "iptables installed: \033[1;32mOK\033[0m"
    let COUNTER++
else   
    echo -e "ip tables not found: \033[1;31mERROR\033[0m"
fi

if rpm -q nftables &> /dev/null; then
    echo -e "nftables installed: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "nftables not installed: \033[1;31mERROR\033[0m"
fi

if rpm -q firewalld &> /dev/null; then
    echo -e "firewalld installed: \033[1;32mOK\033[0m"
     let COUNTER++
else
    echo -e "firewalld not installed: \033[1;31mERROR\033[0m"
fi

printf "Finished auditing with score: $COUNTER/39 \n"
