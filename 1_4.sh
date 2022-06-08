#!/bin/bash

# Set grub2-password

nohup bash dependencies_script/grub2-setpw.sh >/dev/null 2>&1
echo "Grub2 password set"

# Update the grub2 configuration

grub2-mkconfig -o "$(dirname "$(find /boot -type f \( -name 'grubenv' -o -name 'grub.conf' -o -name 'grub.cfg' \) -exec grep -Pl '^\h*(kernelopts=|linux|kernel)' {} \;)")/grub.cfg"

# Ensure permissions on bootloader config are configured

echo "Setting ownership and permissions for grub.cfg..."

[ -f /boot/grub2/grub.cfg ] && chown root:root /boot/grub2/grub.cfg
[ -f /boot/grub2/grub.cfg ] && chmod og-rwx /boot/grub2/grub.cfg

echo "Setting ownership and permissions for grubenv..."

[ -f /boot/grub2/grubenv ] && chown root:root /boot/grub2/grubenv
[ -f /boot/grub2/grubenv ] && chmod og-rwx /boot/grub2/grubenv

echo "Setting ownership and permissions for user.cfg..."

[ -f /boot/grub2/user.cfg ] && chown root:root /boot/grub2/user.cfg
[ -f /boot/grub2/user.cfg ] && chmod og-rwx /boot/grub2/user.cfg

# Ensure authentication is required when booting into rescue mode

if grep -q /systemd-sulogin-shell /usr/lib/systemd/system/rescue.service; then
	echo "Login authentication when rescue mode is set, continuing..."
fi

