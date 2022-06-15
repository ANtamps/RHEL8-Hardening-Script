#!/bin/bash

{ tst1="" tst2="" output="" grubdir=$(dirname "$(find /boot -type f \( -name 'grubenv' -o -name 'grub.conf' -o -name 'grub.cfg' \) -exec grep -El '^\s*(kernelopts=|linux|kernel)' {} \;)") if [ -f "$grubdir/user.cfg" ]; then grep -Pq '^\h*GRUB2_PASSWORD\h*=\h*.+$' "$grubdir/user.cfg" && output="bootloader password set in \"$grubdir/user.cfg\"" fi if [ -z "$output" ]; then grep -Piq '^\h*set\h+superusers\h*=\h*"?[^"\n\r]+"?(\h+.*)?$' "$grubdir/grub.cfg" && tst1=pass grep -Piq '^\h*password(_pbkdf2)?\h+\H+\h+.+$' "$grubdir/grub.cfg" && tst2=pass [ "$tst1" = pass ] && [ "$tst2" = pass ] && output="bootloader password set in \"$grubdir/grub.cfg\"" fi [ -n "$output" ] && echo -e "\n\n PASSED! $output\n\n" }

{ output="" output2="" output3="" output4="" grubdir=$(dirname "$(find /boot -type f \( -name 'grubenv' -o -name 'grub.conf' -o -name 'grub.cfg' \) -exec grep -Pl '^\h*(kernelopts=|linux|kernel)' {} \;)") for grubfile in $grubdir/user.cfg $grubdir/grubenv $grubdir/grub.cfg; do if [ -f "$grubfile" ]; then if stat -c "%a" "$grubfile" | grep -Pq '^\h*[0-7]00$'; then output="$output\npermissions on \"$grubfile\" are \"$(stat -c "%a" "$grubfile")\"" else output3="$output3\npermissions on \"$grubfile\" are \"$(stat -c "%a" "$grubfile")\"" fi if stat -c "%u:%g" "$grubfile" | grep -Pq '^\h*0:0$'; then output2="$output2\n\"$grubfile\" is owned by \"$(stat -c "%U" "$grubfile")\" and belongs to group \"$(stat -c "%G" "$grubfile")\"" else output4="$output4\n\"$grubfile\" is owned by \"$(stat -c "%U" "$grubfile")\" and belongs to group \"$(stat -c "%G" "$grubfile")\"" fi fi done if [[ -n "$output" && -n "$output2" && -z "$output3" && -z "$output4" ]]; then echo -e "\nPASSED:" [ -n "$output" ] && echo -e "$output" [ -n "$output2" ] && echo -e "$output2" else echo -e "\nFAILED:" [ -n "$output3" ] && echo -e "$output3" [ -n "$output4" ] && echo -e "$output4" fi }

grep -r /systemd-sulogin-shell /usr/lib/systemd/system/rescue.service /etc/systemd/system/rescue.service.d

grep -i '^\s*storage\s*=\s*none' /etc/systemd/coredump.conf

grep -i '^\s*ProcessSizeMax\s*=\s*0' /etc/systemd/coredump.conf

{ krp="" pafile="" fafile="" kpname="kernel.randomize_va_space" kpvalue="2" searchloc="/run/sysctl.d/*.conf /etc/sysctl.d/*.conf /usr/local/lib/sysctl.d/*.conf /usr/lib/sysctl.d/*.conf /lib/sysctl.d/*.conf /etc/sysctl.conf" krp="$(sysctl "$kpname" | awk -F= '{print $2}' | xargs)" pafile="$(grep -Psl -- "^\h*$kpname\h*=\h*$kpvalue\b\h*(#.*)?$" $searchloc)" fafile="$(grep -s -- "^\s*$kpname" $searchloc | grep -Pv -- "\h*=\h*$kpvalue\b\h*" | awk -F: '{print $1}')" if [ "$krp" = "$kpvalue" ] && [ -n "$pafile" ] && [ -z "$fafile" ]; then echo -e "\nPASS:\n\"$kpname\" is set to \"$kpvalue\" in the running configuration and in \"$pafile\"" else echo -e "\nFAIL: " [ "$krp" != "$kpvalue" ] && echo -e "\"$kpname\" is set to \"$krp\" in the running configuration\n" [ -n "$fafile" ] && echo -e "\n\"$kpname\" is set incorrectly in \"$fafile\"" [ -z "$pafile" ] && echo -e "\n\"$kpname = $kpvalue\" is not set in a kernel parameter configuration file\n" fi }

rpm -q libselinux

grep -P -- '^\h*(kernelopts=|linux|kernel)' $(find /boot -type f \( -name 'grubenv' -o -name 'grub.conf' -o -name 'grub.cfg' \) -exec grep -Pl -- '^\h*(kernelopts=|linux|kernel)' {} \;) | grep -E -- '(selinux=0|enforcing=0)'

grep -E '^\s*SELINUXTYPE=(targeted|mls)\b' /etc/selinux/config

getenforce

grep -Ei '^\s*SELINUX=(enforcing|permissive)' /etc/selinux/config

ps -eZ | grep unconfined_service_t

rpm -q setroubleshoot

rpm -q mcstrans