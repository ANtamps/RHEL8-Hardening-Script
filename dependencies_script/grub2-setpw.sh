password="admin"
printf '%s\n' $password $password | script -qf -c 'grub2-setpassword' /dev/null

