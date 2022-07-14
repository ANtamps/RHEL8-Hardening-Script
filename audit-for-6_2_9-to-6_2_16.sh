#!/bin/bash

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

else 

echo -e "Users home directories does not exist: \033[1;31mERROR\033[0m"

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

else

echo -e "Users own their home directories are not configured: \033[1;31mERROR\033[0m"
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

else

echo -e "Users .netrc Files are group or world accessible: \033[1;31mERROR\033[0m"

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

else

echo -e "Some users have .forward files: \033[1;31mERROR\033[0m"

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

else

echo -e "Some users have .netrc files: \033[1;31mERROR\033[0m"

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

else

echo -e "Some users have .rhosts files: \033[1;31mERROR\033[0m"

fi
