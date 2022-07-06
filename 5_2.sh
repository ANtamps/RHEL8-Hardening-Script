#!/bin/bash

# 5.2.1 Ensure permissions on /etc/ssh/sshd_config are configured

echo "Changing file ownership for sshd_config file to root..."
chown root:root /etc/ssh/sshd_config
echo "Changing permissions for sshd_config file to owner only..."
chmod og-rwx /etc/ssh/sshd_config

# 5.2.2 Ensure permissions on SSH private host key files are configured

echo "Making ssh private keys only owner read/writable..."
find /etc/ssh -xdev -type f -name 'ssh_host_*_key' -exec chmod u-x,g-wx,o-rwx {} \;
echo "Making ssh private keys ownership to root..."
find /etc/ssh -xdev -type f -name 'ssh_host_*_key' -exec chown root:ssh_keys {} \;

# 5.2.3 Ensure permissions on SSH public host key files are configured

echo "Making ssh public keys only owner read/writable..."
find /etc/ssh -xdev -type f -name 'ssh_host_*_key.pub' -exec chmod u-x,go-wx {} \;
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
sed -i 's;^#.*Banner\s.*$/;Banner /etc/issue.net;' /etc/ssh/sshd_config

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
