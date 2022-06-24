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

##3.2
if cat /etc/sysctl.d/60-netipv4_sysctl.conf | grep "net.ipv4.ip_forward = 0" &> /dev/null; then
    echo "IPv4 forwarding is disabled, checking in sysctl..."

    if sysctl net.ipv4.ip_forward | grep "net.ipv4.ip_forward = 0" &> /dev/null; then
        echo "Kernel parameter for ip forwarding set to 0, continuing..."
    else
        echo "Setting kernel parameter of ipv4 forwarding to 0..."
        sysctl -w net.ipv4.ip_forward=0 &> /dev/null
    fi

     if sysctl net.ipv4.route.flush | grep "net.ipv4.route.flush = 1" &> /dev/null; then
        echo "Kernel parameter for route flush set to 1, continuing..."
    else
        echo "Setting kernel parameter of route flush to 1..."
        sysctl -w net.ipv4.route.flush=1 &> /dev/null
    fi
else
    echo "IPv4 forwarding might be enabled, adding in parameter to conf file..."
    echo "net.ipv4.ip_forward = 0" >> /etc/sysctl.d/60-netipv4_sysctl.conf

    echo "IPv4 forwarding set, checking in sysctl..."

    if sysctl net.ipv4.ip_forward | grep "net.ipv4.ip_forward = 0" &> /dev/null; then
        echo "Kernel parameter for ip forwarding set to 0, continuing..."
    else
        echo "Setting kernel parameter of ipv4 forwarding to 0..."
        sysctl -w net.ipv4.ip_forward=0 &> /dev/null
    fi

     if sysctl net.ipv4.route.flush | grep "net.ipv4.route.flush = 1" &> /dev/null; then
        echo "Kernel parameter for route flush set to 1, continuing..."
    else
        echo "Setting kernel parameter of route flush to 1..."
        sysctl -w net.ipv4.route.flush=1 &> /dev/null
    fi
fi

# IF IPv6 is enabled, uncomment this

# if cat /etc/sysctl.d/60-netipv6_sysctl.conf | grep "net.ipv6.conf.all.forwarding = 0" &> /dev/null; then
#     echo "IPv4 forwarding is disabled, checking in sysctl..."

#     if sysctl net.ipv6.conf.all.forwarding | grep "net.ipv6.conf.all.forwarding = 0" &> /dev/null; then
#         echo "Kernel parameter for ipv6 forwarding set to 0, continuing..."
#     else
#         echo "Setting kernel parameter of ipv6 forwarding to 0..."
#         sysctl -w net.ipv6.conf.all.forwarding=0 &> /dev/null
#     fi

#      if sysctl net.ipv6.route.flush | grep "net.ipv6.route.flush = 1" &> /dev/null; then
#         echo "Kernel parameter for route flush set to 1, continuing..."
#     else
#         echo "Setting kernel parameter of route flush to 1..."
#         sysctl -w net.ipv6.route.flush=1 &> /dev/null
#     fi
# else
#     echo "IPv6 forwarding might be enabled, adding in parameter to conf file..."
#     echo "net.ipv6.conf.all.forwarding" >> /etc/sysctl.d/60-netipv4_sysctl.conf

#     echo "IPv6 forwarding set, checking in sysctl..."

#     if sysctl net.ipv6.conf.all.forwarding | grep "net.ipv6.conf.all.forwarding = 0" &> /dev/null; then
#         echo "Kernel parameter for ipv6 forwarding set to 0, continuing..."
#     else
#         echo "Setting kernel parameter of ipv6 forwarding to 0..."
#         sysctl -w net.ipv6.conf.all.forwarding=0 &> /dev/null
#     fi

#      if sysctl net.ipv6.route.flush | grep "net.ipv6.route.flush = 1" &> /dev/null; then
#         echo "Kernel parameter for route flush set to 1, continuing..."
#     else
#         echo "Setting kernel parameter of route flush to 1..."
#         sysctl -w net.ipv6.route.flush=1 &> /dev/null
#     fi
# fi

if cat /etc/sysctl.d/60-netipv4_syctl.conf | grep "net.ipv4.conf.all.send_redirects = 0" &> /dev/null; then
    echo "Packet redirecting all set to 0, checking in sysctl..."

    if sysctl net.ipv4.conf.all.send_redirects | grep "net.ipv4.conf.all.send_redirects = 0" &> /dev/null; then
        echo "Packet redirecting all set to 0 in kernel parameters, continuing..."
    else
        echo "Kernel parameter not set for packet redirecting, fixing..."
        sysctl -w net.ipv4.conf.all.send_redirects=0 &> /dev/null
    fi
fi

if cat /etc/sysctl.d/60-netipv4_syctl.conf | grep "net.ipv4.conf.default.send_redirects = 0" &> /dev/null; then
    echo "Packet redirecting default set to 0, checking in sysctl..."

    if sysctl net.ipv4.conf.default.send_redirects | grep "net.ipv4.conf.default.send_redirects = 0" &> /dev/null; then
        echo "Packet redirecting default set to 0 in kernel parameters, continuing..."
    else
        echo "Kernel parameter not set for packet redirecting, fixing..."
        sysctl -w net.ipv4.conf.default.send_redirects=0 &> /dev/null
    fi
fi

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

##3.4.1 

##3.4.1.1 Ensure firewalld is installed
if rpm -q firewalld iptables &> /dev/null; then
    echo "FirewallD and iptables installed, continuing..."
else   
    echo "ip tables not found, installing..."
    dnf -y install firewalld iptables &> /dev/null
fi
##3.4.1.2 Ensure iptables-services not installed with firewalld

if rpm -q iptables-services &> /dev/null; then
    echo "package iptables-services  found, removing..."
    sudo yum -y install iptables-services
    systemctl stop iptables
    dnf -y remove iptables-services

else   
    echo "Package iptables-services is not installed, continuing..."
fi

##3.4.1.3 Ensure nftables either not installed or masked with firewalld 

if  rpm -q nftables &> /dev/null; then
    echo "nftables installed, removing..."
    dnf -y remove nftables &> /dev/null
else
    echo "nftables not installed, continuing..."
fi

##3.4.1.4 Ensure firewalld service enabled and running
	
if   systemctl is-enabled firewalld &> /dev/null; then
    echo "already enabled, continuing..."
   
else
    echo "firewalld is still masked, enabling..."
	sudo yum -y install firewalld
	systemctl unmask firewalld
fi

if    firewall-cmd --state &> /dev/null; then
    echo "already running, continuing..."
   
else
    echo "firewalld is not running, enabling..."
	systemctl --now enable firewalld
fi
##3.4.1.5 Ensure firewalld default zone is set 
	 firewall-cmd --set-default-zone=public

##3.4.1.6 Ensure network interfaces are assigned to appropriate zone (Manual)
##3.4.1.7 Ensure firewalld drops unnecessary services and ports (Manual)


##3.4.2

##3.4.2.1 Ensure nftables is installed (Automated)

if  rpm -q nftables &> /dev/null; then
    echo "nftables installed, continuing..."
else   
    echo "nftables not found, installing..."
     dnf -y install nftables &> /dev/null
fi

##3.4.2.2 Ensure firewalld is either not installed or masked with nftables 

if rpm -q iptables-services &> /dev/null; then
   echo "Firewalld found.. masking.."
   systemctl --now mask firewalld

else   
    echo "Firewalld is masked, continuing..."
	systemctl --now mask firewalld
fi

##3.4.2.3 Ensure iptables-services not installed with nftables

if  rpm -q iptables-services &> /dev/null; then
    echo "iptables-services installed, removing..."
    dnf -y remove iptables-services &> /dev/null
else
    echo "iptables-services not installed, continuing..."
    dnf -y remove iptables-services
fi

##3.4.2.4 Ensure iptables are flushed with nftables (Manual)

##3.4.2.5 Ensure an nftables table exists
 nft create table inet filter

##3.4.2.6 Ensure nftables base chains exist
nft create chain inet filter input { type filter hook input priority 0 \; }
nft create chain inet filter forward { type filter hook forward priority 0 \; }
nft create chain inet filter output { type filter hook output priority 0 \; }

##3.4.2.7 Ensure nftables loopback traffic is configured
if  nft list ruleset | awk '/hook input/,/}/' | grep 'iif "lo" accept' &> /dev/null; then
   nft add rule inet filter input iif lo accept
   echo "Loopback interface already configured, continuing.."
    
else
    echo "Loopback interface is not set, configuring.."
    nft add rule inet filter input iif lo accept
fi

##3.4.2.8 Ensure nftables outbound and established connections are configured (Manual)

##3.4.2.9 Ensure nftables default deny firewall policy (Automated)
nft chain inet filter input { policy drop \; }
nft chain inet filter forward { policy drop \; }
nft chain inet filter output { policy drop \; }

##3.4.2.10 Ensure nftables service is enabled
if  systemctl is-enabled nftables &> /dev/null; then
    systemctl enable nftables
    echo "nftables services enabled, continuing..."
else   
     echo "nftables services not enabled, configuring..."
     sudo yum -y install nftables
     systemctl enable nftables
fi

# 3.4.3.1.1 Ensure iptables packages are installed

if rpm -q iptables ip tables-services &> /dev/null; then
    echo "iptables installed, continuing..."
else   
    echo "ip tables not found, installing..."
    dnf -y install iptables iptables-services &> /dev/null
fi

# 3.4.3.1.2 Ensure nftables is not installed with iptables

if rpm -q nftables &> /dev/null; then
    echo "nftables installed, removing..."
    dnf remove nftables &> /dev/null
else
    echo "nftables not installed, continuing..."
fi

# 3.4.3.1.3 Ensure firewalld is removed or masked with iptables

if rpm -q firewalld &> /dev/null; then
    echo "firewalld installed, removing..."
    dnf remove firewalld &> /dev/null
else
    echo "firewalld not installed, continuing..."
fi

# 

# Flush IPtables rules 

iptables -F 

# Ensure default deny firewall policy 

iptables -P INPUT DROP iptables -P OUTPUT DROP iptables -P FORWARD DROP 

# Ensure loopback traffic is configured 

iptables -A INPUT -i lo -j ACCEPT iptables -A OUTPUT -o lo -j ACCEPT 

iptables -A INPUT -s 127.0.0.0/8 -j DROP 

# Ensure outbound and established connections are configured 

iptables -A OUTPUT -p tcp -m state --state NEW,ESTABLISHED -j ACCEPT 

iptables -A OUTPUT -p udp -m state --state NEW,ESTABLISHED -j ACCEPT 

iptables -A OUTPUT -p icmp -m state --state NEW,ESTABLISHED -j ACCEPT 

iptables -A INPUT -p tcp -m state --state ESTABLISHED -j ACCEPT 

iptables -A INPUT -p udp -m state --state ESTABLISHED -j ACCEPT 

iptables -A INPUT -p icmp -m state --state ESTABLISHED -j ACCEPT 

# Open inbound ssh(tcp port 22) connections 

iptables -A INPUT -p tcp --dport 22 -m state --state NEW -j ACCEPT

# 3.4.3.2.4 Ensure iptables default deny firewall policy

iptables -p INPUT DROP
iptables -p OUTPUT DROP
iptables -P FORWARD DROP

# 3.4.3.2.5 Ensure iptables config is saved

service iptables save

# 3.4.3.2.6 Ensure iptables is enabled and active

if systemctl is-active iptables | grep "active" &> /dev/null; then
    echo "iptables is activated, continuing..."
else
    echo "Activating iptables..."
    systemctl --now enable iptables
fi

# Flush ip6tables rules 
ip6tables -F 

# Ensure default deny firewall policy 

ip6tables -P INPUT DROP ip6tables -P OUTPUT DROP ip6tables -P FORWARD DROP 

# Ensure loopback traffic is configured 

ip6tables -A INPUT -i lo -j ACCEPT ip6tables -A OUTPUT -o lo -j ACCEPT ip6tables -A INPUT -s ::1 -j DROP 

# Ensure outbound and established connections are configured 

ip6tables -A OUTPUT -p tcp -m state --state NEW,ESTABLISHED -j ACCEPT 

ip6tables -A OUTPUT -p udp -m state --state NEW,ESTABLISHED -j ACCEPT 

ip6tables -A OUTPUT -p icmp -m state --state NEW,ESTABLISHED -j ACCEPT 

ip6tables -A INPUT -p tcp -m state --state ESTABLISHED -j ACCEPT 

ip6tables -A INPUT -p udp -m state --state ESTABLISHED -j ACCEPT 

ip6tables -A INPUT -p icmp -m state --state ESTABLISHED -j ACCEPT 

# Open inbound ssh(tcp port 22) connections 

ip6tables -A INPUT -p tcp --dport 22 -m state --state NEW -j ACCEPT

# 3.4.3.3.4 Ensure ip6tables default deny firewall policy

ip6tables -P INPUT DROP

ip6tables -P OUTPUT DROP

ip6tables -P FORWARD DROP

# 3.4.3.3.5 Ensure ip6tables config is saved

service ip6tables save

# 3.4.3.3.6 Ensure ip6tables is enabled and active

if systemctl is-active ip6tables | grep "active" &> /dev/null; then
    echo "ip6tables is activated, continuing..."
else
    echo "Activating ip6tables..."
    systemctl --now enable ip6tables
fi




