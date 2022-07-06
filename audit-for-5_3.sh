#!/bin/bash

##5.3.1 Ensure sudo is installed
if rpm -q sudo &> /dev/null; then
 echo -e "sudo installed: \033[1;32mOK\033[0m"
else
  echo -e "sudo not installed: \033[1;31mERROR\033[0m"
fi

##5.3.2 Ensure sudo commands use pty
if grep /etc/sudoers /etc/sudoers &> /dev/null; then
 echo -e "sudo commands use pty: \033[1;32mOK\033[0m"
else
  echo -e "sudo commands does not use pty: \033[1;31mERROR\033[0m"
fi
