#!/bin/bash

##6.2.9 Ensure all users' home directories exist (Automated)##

if 
awk -F: '($1!~/(halt|sync|shutdown|nfsnobody)/ &&
$7!~/^(\/usr)?\/sbin\/nologin(\/)?$/ && $7!~/(\/usr)?\/bin\/false(\/)?$/) {
print $1 " " $6 }' /etc/passwd | while read -r user dir; do
 if [ ! -d "$dir" ]; then
 mkdir "$dir"
 chmod g-w,o-wrx "$dir"
 chown "$user" "$dir"
 fi
done; then

echo "Configured all user's home directories... "

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

echo "Configured users own their home directories..."

fi

##6.2.13 Ensure users' .netrc Files are not group or world accessible(Automated)##

{
awk -F: '($1!~/(halt|sync|shutdown|nfsnobody)/ &&
$7!~/^(\/usr)?\/sbin\/nologin(\/)?$/ && $7!~/(\/usr)?\/bin\/false(\/)?$/) {
print $6 }' /etc/passwd | while read -r dir; do
 if [ -d "$dir" ]; then
 file="$dir/.netrc"
 [ ! -h "$file" ] && [ -f "$file" ] && rm -f "$file"
fi
done 

echo "Configured users .netrc Files are not group or world accessible..."
}

##6.2.14 Ensure no users have .forward files (Automated)##

{
awk -F: '($1!~/(halt|sync|shutdown|nfsnobody)/ &&
$7!~/^(\/usr)?\/sbin\/nologin(\/)?$/ && $7!~/(\/usr)?\/bin\/false(\/)?$/) {
print $6 }' /etc/passwd | while read -r dir; do
 if [ -d "$dir" ]; then
 file="$dir/.forward"
 [ ! -h "$file" ] && [ -f "$file" ] && rm -r "$file"
 fi
done

echo "Configured no users have .forward files..."
}

##6.2.15 Ensure no users have .netrc files(Automated)##

{
awk -F: '($1!~/(halt|sync|shutdown|nfsnobody)/ &&
$7!~/^(\/usr)?\/sbin\/nologin(\/)?$/ && $7!~/(\/usr)?\/bin\/false(\/)?$/) {
print $6 }' /etc/passwd | while read -r dir; do
 if [ -d "$dir" ]; then
 file="$dir/.netrc"
 [ ! -h "$file" ] && [ -f "$file" ] && rm -f "$file"
 fi
done

echo "Configured no users have .netrc files"
}

##6.2.16 Ensure no users have .rhosts files (Automated)##

{ 
awk -F: '($1!~/(halt|sync|shutdown|nfsnobody)/ &&
$7!~/^(\/usr)?\/sbin\/nologin(\/)?$/ && $7!~/(\/usr)?\/bin\/false(\/)?$/) {
print $6 }' /etc/passwd | while read -r dir; do
 if [ -d "$dir" ]; then
 file="$dir/.rhosts"
 [ ! -h "$file" ] && [ -f "$file" ] && rm -r "$file"
 fi
done

echo -e "Configured no users have .rhosts files..."
}
