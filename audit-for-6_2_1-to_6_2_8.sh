#!/bin/bash

# 6.2.1 Ensure password fields are not empty
if [ $(awk -F: '($2 == "" ) { print $1 " does not have a password " }'  /etc/shadow | wc -l) -eq 0 ]; then
    echo -e "Password fields are not empty: \033[1;32mOK\033[0m"
else
    echo -e "Some password fields are empty: \033[1;31mERROR\033[0m"
    echo -e "Some password fields are empty: \033[1;31mERROR\033[0m" >> audit-error.log
fi

# 6.2.2 Ensure all groups in /etc/passwd exist in /etc/group

group_counter=0

for i in $(cut -s -d: -f4 /etc/passwd | sort -u ); do 
    grep -q -P "^.*?:[^:]*:$i:" /etc/group 
    
    if [ $? -ne 0 ]; then 
        echo -e "Group $i is referenced by /etc/passwd but does not exist in /etc/group: \033[1;31mERROR\033[0m"
        echo -e "Group $i is referenced by /etc/passwd but does not exist in /etc/group: \033[1;31mERROR\033[0m" >> audit-error.log
        let group_counter++
    fi
done

if [ $group_counter -eq 0 ]; then
    echo -e "All groups in /etc/passwd exists in /etc/group: \033[1;32mOK\033[0m"
fi

# 6.2.3 Ensure no duplicate UIDs exist

uid_counter=0

cut -f3 -d ":" /etc/passwd | sort -n | uniq -c | while read x ; do 
    [ -z "$x" ] && break 
    set - $x 
    if [ $1 -gt 1 ]; then 
        users=$(awk -F: '($3 == n) { print $1 }' n=$2 /etc/passwd | xargs) 
        echo -e "Duplicate UID ($2) $users: \033[1;31mERROR\033[0m"
        echo -e "Duplicate UID ($2) $users: \033[1;31mERROR\033[0m" >> audit-error.log
        let uid_counter++
    fi 
done

if [ $uid_counter -eq 0 ]; then
    echo -e "No UID duplicates: \033[1;32mOK\033[0m"
fi

# 6.2.4 Ensure no duplicate GIDs exist

gid_counter=0

cut -d: -f3 /etc/group | sort | uniq -d | while read x ; do 
    echo -e "Duplicate GID ($x) in /etc/group: \033[1;31mERROR\033[0m"
    echo -e "Duplicate GID ($x) in /etc/group: \033[1;31mERROR\033[0m" >> audit-error.log
    let gid_counter++
done

if [ $gid_counter -eq 0 ]; then
    echo -e "No duplicate GIDs found: \033[1;32mOK\033[0m"
fi

# 6.2.5 Ensure no duplicate user names exist

user_counter=0

cut -d: -f1 /etc/passwd | sort | uniq -d | while read x; do 
    echo -e "Duplicate login name ${x} in /etc/passwd: \033[1;31mERROR\033[0m"
    echo -e "Duplicate login name ${x} in /etc/passwd: \033[1;31mERROR\033[0m" >> audit-error.log
    let user_counter++
done

if [ $user_counter -eq 0 ]; then
    echo -e "No duplicate user names found: \033[1;32mOK\033[0m"
fi

# 6.2.6 Ensure no duplicate group names exist

group_name_counter=0

cut -d: -f1 /etc/group | sort | uniq -d | while read -r x; do 
    echo -e "Duplicate group name ${x} in /etc/group: \033[1;31mERROR\033[0m"
    echo -e "Duplicate group name ${x} in /etc/group: \033[1;31mERROR\033[0m" >> audit-error.log
done

if [ $group_name_counter -eq 0 ]; then
    echo -e "No duplicate group names found: \033[1;32mOK\033[0m"
fi

if [ $(awk -F: '($3 == 0) { print $1 }' /etc/passwd | wc -l) -eq 1 ] && [ $(awk -F: '($3 == 0) { print $1 }' /etc/passwd | grep -c root) -eq 1 ]; then
    echo -e "Root is only user with UID of 0: \033[1;32mOK\033[0m"
else
    echo -e "Root not only user with UID of 0: \033[1;31mERROR\033[0m"
fi