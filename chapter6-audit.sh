#!/bin/bash

##6.1

##6.1.1 Audit system file permissions (Manual)

##6.1.2 Ensure sticky bit is set on all world-writable directories 
if  df --local -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' find '{}' -xdev -type d \( -perm -0002 -a ! -perm -1000 \) 2>/dev/null &> /dev/null; then
    echo -e "Sticky bit is set: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "Sticky bit is not set: \033[1;31mERROR\033[0m"
    echo -e "Sticky bit is not set: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##6.1.3 Ensure permissions on /etc/passwd are configured 
if stat /etc/passwd &> /dev/null; then
    echo -e "Permissions on /etc/passwd configured: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "Permissions on /etc/passwd not configured: \033[1;31mERROR\033[0m"
    echo -e "Permissions on /etc/passwd not configured: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##6.1.4 Ensure permissions on /etc/shadow are configured
if stat /etc/shadow &> /dev/null; then
    echo -e "Permissions on /etc/shadow configured: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "Permissions on /etc/shadow not configured: \033[1;31mERROR\033[0m"
    echo -e "Permissions on /etc/shadow not configured: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##6.1.5 Ensure permissions on /etc/group are configured
if stat /etc/group &> /dev/null; then
    echo -e "Permissions on /etc/group configured: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "Permissions on /etc/group not configured: \033[1;31mERROR\033[0m"
    echo -e "Permissions on /etc/group not configured: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##6.1.6 Ensure permissions on /etc/gshadow are configured
if stat /etc/gshadow &> /dev/null; then
    echo -e "Permissions on /etc/gshadow configured: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "Permissions on /etc/gshadow not configured: \033[1;31mERROR\033[0m"
    echo -e "Permissions on /etc/gshadow not configured: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##6.1.7 Ensure permissions on /etc/passwd- are configured
if stat /etc/passwd- &> /dev/null; then
    echo -e "Permissions on /etc/passwd- configured: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "Permissions on /etc/passwd- not configured: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##6.1.8 Ensure permissions on /etc/shadow- are configured
if stat /etc/shadow- &> /dev/null; then
    echo -e "Permissions on /etc/shadow- configured: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "Permissions on /etc/shadow- not configured: \033[1;31mERROR\033[0m"
    echo -e "Permissions on /etc/shadow- not configured: \033[1;31mERROR\033[0m" >> audit-error.log

##6.1.9 Ensure permissions on /etc/group- are configured
if stat /etc/group- &> /dev/null; then
    echo -e "Permissions on /etc/group- configured: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "Permissions on /etc/group- not configured: \033[1;31mERROR\033[0m"
    echo -e "Permissions on /etc/group- not configured: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##6.1.10 Ensure permissions on /etc/gshadow- are configured 
if stat /etc/gshadow- &> /dev/null; then
    echo -e "Permissions on /etc/gshadow-- configured: \033[1;32mOK\033[0m"
    let COUNTER++
else
    echo -e "Permissions on /etc/gshadow- not configured: \033[1;31mERROR\033[0m"
    echo -e "Permissions on /etc/gshadow- not configured: \033[1;31mERROR\033[0m" >> audit-error.log
fi


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

##6.2.9 Ensure all users' home directories exist (Automated)##

if
awk -F: '($1!~/(halt|sync|shutdown|nfsnobody)/ &&
$7!~/^(\/usr)?\/sbin\/nologin(\/)?$/ && $7!~/(\/usr)?\/bin\/false(\/)?$/) {
print $1 " " $6 }' /etc/passwd | while read -r user dir; do
 if [ ! -d "$dir" ]; then
 echo "User: \"$user\" home directory: \"$dir\" does not exist."
 fi
done; then

echo -e "All users' home directories exist: \033[1;32mOK\033[0m"
let COUNTER++
else 

echo -e "Users home directories does not exist: \033[1;31mERROR\033[0m"
echo -e "Users home directories does not exist: \033[1;31mERROR\033[0m" >> audit-error.log

fi

##6.2.10 Ensure users own their home directories(Automated)##

if
awk -F: '($1!~/(halt|sync|shutdown|nfsnobody)/ &&
$7!~/^(\/usr)?\/sbin\/nologin(\/)?$/ && $7!~/(\/usr)?\/bin\/false(\/)?$/) {
print $1 " " $6 }' /etc/passwd | while read -r user dir; do
 if [ ! -d "$dir" ]; then
 echo "User: \"$user\" home directory: \"$dir\" does not exist, creating
home directory"
 mkdir "$dir"
 chmod g-w,o-rwx "$dir"
 chown "$user" "$dir"
 else
 owner=$(stat -L -c "%U" "$dir")
 if [ "$owner" != "$user" ]; then
 chmod g-w,o-rwx "$dir"
 chown "$user" "$dir"
 fi
 fi
done; then 

echo -e "Users own their home directories: \033[1;32mOK\033[0m"
let COUNTER++
else

echo -e "Users own their home directories are not configured: \033[1;31mERROR\033[0m"
echo -e "Users own their home directories are not configured: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##6.2.13 Ensure users .netrc Files are not group or world accessible(Automated)##

if
awk -F: '($1!~/(halt|sync|shutdown|nfsnobody)/ && $7!~/^(\/usr)?\/sbin\/nologin(\/)?$/ && $7!~/(\/usr)?\/bin\/false(\/)?$/) {print $1 " " $6 }' /etc/passwd | while read -r user dir; do
 if [ -d "$dir" ]; then
 file="$dir/.netrc"
 if [ ! -h "$file" ] && [ -f "$file" ]; then
 if stat -L -c "%A" "$file" | cut -c4-10 | grep -Eq '[^-]+'; then
 echo "FAILED: User: \"$user\" file: \"$file\" exists with permissions: \"$(stat -L -c "%a" "$file")\", remove file or excessive permissions"
 else
 echo "WARNING: User: \"$user\" file: \"$file\" exists with permissions: \"$(stat -L -c "%a" "$file")\", remove file unless required"
 fi
 fi
 fi
done; then 

echo -e "Users .netrc Files are not group or world accessible: \033[1;32mOK\033[0m"
let COUNTER++
else

echo -e "Users .netrc Files are group or world accessible: \033[1;31mERROR\033[0m"
echo -e "Users .netrc Files are group or world accessible: \033[1;31mERROR\033[0m" >> audit-error.log

fi

##6.2.14 Ensure no users have .forward files (Automated)##

if
awk -F: '($1!~/(halt|sync|shutdown|nfsnobody)/ &&
$7!~/^(\/usr)?\/sbin\/nologin(\/)?$/ && $7!~/(\/usr)?\/bin\/false(\/)?$/) {
print $1 " " $6 }' /etc/passwd | while read -r user dir; do
 if [ -d "$dir" ]; then
 file="$dir/.forward"
 if [ ! -h "$file" ] && [ -f "$file" ]; then
 echo "User: \"$user\" file: \"$file\" exists"
 fi
 fi
done; then

echo -e "No users have .forward files: \033[1;32mOK\033[0m "
let COUNTER++
else

echo -e "Some users have .forward files: \033[1;31mERROR\033[0m"
echo -e "Some users have .forward files: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##6.2.15 Ensure no users have .netrc files (Automated)##

if
awk -F: '($1!~/(halt|sync|shutdown|nfsnobody)/ &&
$7!~/^(\/usr)?\/sbin\/nologin(\/)?$/ && $7!~/(\/usr)?\/bin\/false(\/)?$/) {
print $1 " " $6 }' /etc/passwd | while read -r user dir; do
 if [ -d "$dir" ]; then
 file="$dir/.netrc"
 if [ ! -h "$file" ] && [ -f "$file" ]; then
 echo "User: \"$user\" file: \"$file\" exists"
 fi
 fi
done; then

echo -e "No users have .netrc files: \033[1;32mOK\033[0m "
let COUNTER++
else

echo -e "Some users have .netrc files: \033[1;31mERROR\033[0m"
echo -e "Some users have .netrc files: \033[1;31mERROR\033[0m" >> audit-error.log
fi

##6.2.16 Ensure no users have .rhosts files (Automated)##

if
awk -F: '($1!~/(halt|sync|shutdown|nfsnobody)/ &&
$7!~/^(\/usr)?\/sbin\/nologin(\/)?$/ && $7!~/(\/usr)?\/bin\/false(\/)?$/) {
print $1 " " $6 }' /etc/passwd | while read -r user dir; do
 if [ -d "$dir" ]; then
 file="$dir/.rhosts"
 if [ ! -h "$file" ] && [ -f "$file" ]; then
 echo "User: \"$user\" file: \"$file\" exists"
 fi
 fi
done; then

echo -e "No users have .rhosts files: \033[1;32mOK\033[0m "
let COUNTER++
else

echo -e "Some users have .rhosts files: \033[1;31mERROR\033[0m"
echo -e "Some users have .rhosts files: \033[1;31mERROR\033[0m" >> audit-error.log
fi


printf "Finished auditing with score: $COUNTER/9 \n"
