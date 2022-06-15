##!/bin/bash
##AUDIT##

##1.3 Filesystem Integrity Checking##
##1.3.1 Ensure AIDE is installed##

if  rpm -q aide &> /dev/null; then
	rpm -q aide
	echo -e "AIDE is already installed: \033[1;32mOK\033[0m"

else
	echo -e "AIDE needs to be installed: \033[1;31mERROR\033[0m"
fi


##1.3.2 Ensure filesystem integrity is regularly checked##

if  grep -Ers '^([^#]+\s+)?(\/usr\/s?bin\/|^\s*)aide(\.wrapper)?\s(--?\S+\s)*(--(check|update)|\$AIDEARGS)\b' /etc/cron.* /etc/crontab /var/spool/cron/ &> /dev/null; then
	echo -e "Check: \033[1;32mOK\033[0m"
else
	echo -e "Check: \033[1;31mERROR\033[0m"
fi

