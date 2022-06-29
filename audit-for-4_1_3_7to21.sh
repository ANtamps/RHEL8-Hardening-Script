UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)

# 4.1.3.7

[ -n "${UID_MIN}" ] && awk "/^ *-a *always,exit/ \
&&/ -F *arch=b[2346]{2}/ \
&&(/ -F *auid!=unset/||/ -F *auid!=-1/||/ -F *auid!=4294967295/) \
&&/ -F *auid>=${UID_MIN}/ \
&&(/ -F *exit=-EACCES/||/ -F *exit=-EPERM/) \
&&/ -S/ \
&&/creat/ \
&&/open/ \
&&/truncate/ \
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)" /etc/audit/rules.d/*.rules \ || printf "ERROR: Variable 'UID_MIN' is unset.\n"

[ -n "${UID_MIN}" ] && awk "/^ *-a *always,exit/ \
&&/ -F *arch=b[2346]{2}/ \
&&(/ -F *auid!=unset/||/ -F *auid!=-1/||/ -F *auid!=4294967295/) \
&&/ -F *auid>=${UID_MIN}/ \
&&(/ -F *exit=-EACCES/||/ -F *exit=-EPERM/) \
&&/ -S/ \
&&/creat/ \
&&/open/ \
&&/truncate/ \
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)" \ || printf "ERROR: Variable 'UID_MIN' is unset.\n"

# 4.1.3.8 

awk '/^ *-w/ \
&&(/\/etc\/group/ \
    ||/\/etc\/passwd/ \
    ||/\/etc\/gshadow/ \ 
    ||/\/etc\/shadow/ \ 
    ||/\/etc\/security\/opasswd/) \
&&/ +-p *wa/ \
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)' /etc/audit/rules.d/*.rules

auditctl -l | awk '/^ *-w/ \
&&(/\/etc\/group/ \
    ||/\/etc\/passwd/ \
    ||/\/etc\/gshadow/ \ 
    ||/\/etc\/shadow/ \ 
    ||/\/etc\/security\/opasswd/) \
&&/ +-p *wa/ \
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)'

# 4.1.3.9

[ -n "${UID_MIN}" ] && awk "/^ *-a *always,exit/ \ 
&&/ -F *arch=b[2346]{2}/ \ 
&&(/ -F *auid!=unset/||/ -F *auid!=-1/||/ -F *auid!=4294967295/) \ 
&&/ -S/ \ &&/ -F *auid>=${UID_MIN}/ \ 
&&(/chmod/||/fchmod/||/fchmodat/ \ 
    ||/chown/||/fchown/||/fchownat/||/lchown/ \ 
    ||/setxattr/||/lsetxattr/||/fsetxattr/ \ 
    ||/removexattr/||/lremovexattr/||/fremovexattr/) \ 
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)" /etc/audit/rules.d/*.rules \ || printf "ERROR: Variable 'UID_MIN' is unset.\n"


[ -n "${UID_MIN}" ] && auditctl -l | awk "/^ *-a *always,exit/ \ 
&&/ -F *arch=b[2346]{2}/ \ 
&&(/ -F *auid!=unset/||/ -F *auid!=-1/||/ -F *auid!=4294967295/) \ 
&&/ -S/ \ &&/ -F *auid>=${UID_MIN}/ \ 
&&(/chmod/||/fchmod/||/fchmodat/ \ 
    ||/chown/||/fchown/||/fchownat/||/lchown/ \ 
    ||/setxattr/||/lsetxattr/||/fsetxattr/ \ 
    ||/removexattr/||/lremovexattr/||/fremovexattr/) \ 
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)" \ || printf "ERROR: Variable 'UID_MIN' is unset.\n"

# 4.1.3.10

[ -n "${UID_MIN}" ] && awk "/^ *-a *always,exit/ \ 
&&/ -F *arch=b[2346]{2}/ \ &&(/ -F *auid!=unset/||/ -F *auid!=-1/||/ -F *auid!=4294967295/) \ 
&&/ -F *auid>=${UID_MIN}/ \ 
&&/ -S/ \ 
&&/mount/ \ 
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)" /etc/audit/rules.d/*.rules \ || printf "ERROR: Variable 'UID_MIN' is unset.\n"

[ -n "${UID_MIN}" ] && auditctl -l | awk "/^ *-a *always,exit/ \ 
&&/ -F *arch=b[2346]{2}/ \ &&(/ -F *auid!=unset/||/ -F *auid!=-1/||/ -F *auid!=4294967295/) \ 
&&/ -F *auid>=${UID_MIN}/ \ 
&&/ -S/ \ 
&&/mount/ \ 
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)" \ || printf "ERROR: Variable 'UID_MIN' is unset.\n"

# 4.1.3.11

awk '/^ *-w/ \ 
&&(/\/var\/run\/utmp/ \ 
    ||/\/var\/log\/wtmp/ \ 
    ||/\/var\/log\/btmp/) \ 
&&/ +-p *wa/ \ 
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)' /etc/audit/rules.d/*.rules

auditctl -l | awk '/^ *-w/ \ 
&&(/\/var\/run\/utmp/ \ 
    ||/\/var\/log\/wtmp/ \ 
    ||/\/var\/log\/btmp/) \ 
&&/ +-p *wa/ \ 
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)'

# 4.1.3.12

awk '/^ *-w/ \ 
&&(/\/var\/log\/lastlog/ \ 
    ||/\/var\/run\/faillock/) \ 
&&/ +-p *wa/ \ 
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)' /etc/audit/rules.d/*.rules

auditctl -l | awk '/^ *-w/ \ 
&&(/\/var\/log\/lastlog/ \ 
    ||/\/var\/run\/faillock/) \ 
&&/ +-p *wa/ \ 
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)'

# 4.1.3.13

[ -n "${UID_MIN}" ] && awk "/^ *-a *always,exit/ \ 
&&/ -F *arch=b[2346]{2}/ \ 
&&(/ -F *auid!=unset/||/ -F *auid!=-1/||/ -F *auid!=4294967295/) \ 
&&/ -F *auid>=${UID_MIN}/ \ 
&&/ -S/ \ 
&&(/unlink/||/rename/||/unlinkat/||/renameat/) \ 
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)" /etc/audit/rules.d/*.rules \ || printf "ERROR: Variable 'UID_MIN' is unset.\n"


[ -n "${UID_MIN}" ] && auditctl -l | awk "/^ *-a *always,exit/ \ 
&&/ -F *arch=b[2346]{2}/ \ 
&&(/ -F *auid!=unset/||/ -F *auid!=-1/||/ -F *auid!=4294967295/) \ 
&&/ -F *auid>=${UID_MIN}/ \ 
&&/ -S/ \ 
&&(/unlink/||/rename/||/unlinkat/||/renameat/) \ 
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)" \ || printf "ERROR: Variable 'UID_MIN' is unset.\n"

# 4.1.3.14

awk '/^ *-w/ \ 
&&(/\/etc\/selinux/ \ 
    ||/\/usr\/share\/selinux/) \ 
&&/ +-p *wa/ \ 
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)' /etc/audit/rules.d/*.rules

auditctl -l | awk '/^ *-w/ \ 
&&(/\/etc\/selinux/ \ 
    ||/\/usr\/share\/selinux/) \ 
&&/ +-p *wa/ \ 
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)'

# 4.1.3.15

[ -n "${UID_MIN}" ] && awk "/^ *-a *always,exit/ \ 
&&(/ -F *auid!=unset/||/ -F *auid!=-1/||/ -F *auid!=4294967295/) \ 
&&/ -F *auid>=${UID_MIN}/ \ &&/ -F *perm=x/ \ 
&&/ -F *path=\/usr\/bin\/chcon/ \ 
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)" /etc/audit/rules.d/*.rules \ || printf "ERROR: Variable 'UID_MIN' is unset.\n"

[ -n "${UID_MIN}" ] && auditctl -l | awk "/^ *-a *always,exit/ \ 
&&(/ -F *auid!=unset/||/ -F *auid!=-1/||/ -F *auid!=4294967295/) \ 
&&/ -F *auid>=${UID_MIN}/ \ &&/ -F *perm=x/ \ 
&&/ -F *path=\/usr\/bin\/chcon/ \ 
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)" \ || printf "ERROR: Variable 'UID_MIN' is unset.\n"

# 4.1.3.16

[ -n "${UID_MIN}" ] && awk "/^ *-a *always,exit/ \ 
&&(/ -F *auid!=unset/||/ -F *auid!=-1/||/ -F *auid!=4294967295/) \ 
&&/ -F *auid>=${UID_MIN}/ \ 
&&/ -F *perm=x/ \ 
&&/ -F *path=\/usr\/bin\/setfacl/ \ 
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)" \ || printf "ERROR: Variable 'UID_MIN' is unset.\n"

[ -n "${UID_MIN}" ] && auditctl -l | awk "/^ *-a *always,exit/ \ 
&&(/ -F *auid!=unset/||/ -F *auid!=-1/||/ -F *auid!=4294967295/) \ 
&&/ -F *auid>=${UID_MIN}/ \ 
&&/ -F *perm=x/ \ 
&&/ -F *path=\/usr\/bin\/setfacl/ \ 
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)" \ || printf "ERROR: Variable 'UID_MIN' is unset.\n"

# 4.1.3.17

[ -n "${UID_MIN}" ] && awk "/^ *-a *always,exit/ \ 
&&(/ -F *auid!=unset/||/ -F *auid!=-1/||/ -F *auid!=4294967295/) \ 
&&/ -F *auid>=${UID_MIN}/ \ 
&&/ -F *perm=x/ \ 
&&/ -F *path=\/usr\/bin\/chacl/ \ 
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)" /etc/audit/rules.d/*.rules \ || printf "ERROR: Variable 'UID_MIN' is unset.\n"

[ -n "${UID_MIN}" ] && auditctl -l | awk "/^ *-a *always,exit/ \ 
&&(/ -F *auid!=unset/||/ -F *auid!=-1/||/ -F *auid!=4294967295/) \ 
&&/ -F *auid>=${UID_MIN}/ \ 
&&/ -F *perm=x/ \ 
&&/ -F *path=\/usr\/bin\/chacl/ \ 
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)" \ || printf "ERROR: Variable 'UID_MIN' is unset.\n"

# 4.1.3.18

[ -n "${UID_MIN}" ] && awk "/^ *-a *always,exit/ \ 
&&(/ -F *auid!=unset/||/ -F *auid!=-1/||/ -F *auid!=4294967295/) \ 
&&/ -F *auid>=${UID_MIN}/ \ 
&&/ -F *perm=x/ \ 
&&/ -F *path=\/usr\/sbin\/usermod/ \ 
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)" /etc/audit/rules.d/*.rules \ || printf "ERROR: Variable 'UID_MIN' is unset.\n"

[ -n "${UID_MIN}" ] && auditctl -l | awk "/^ *-a *always,exit/ \ 
&&(/ -F *auid!=unset/||/ -F *auid!=-1/||/ -F *auid!=4294967295/) \ 
&&/ -F *auid>=${UID_MIN}/ \ 
&&/ -F *perm=x/ \ 
&&/ -F *path=\/usr\/sbin\/usermod/ \ 
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)" \ || printf "ERROR: Variable 'UID_MIN' is unset.\n"

# 4.1.3.19

awk '/^ *-a *always,exit/ \ 
&&/ -F *arch=b[2346]{2}/ \ 
&&(/ -F auid!=unset/||/ -F auid!=-1/||/ -F auid!=4294967295/) \ 
&&/ -S/ \ 
&&(/init_module/ \ 
    ||/finit_module/ \ 
    ||/delete_module/ \ 
    ||/create_module/ \ 
    ||/query_module/) \ 
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)' /etc/audit/rules.d/*.rules

[ -n "${UID_MIN}" ] && awk "/^ *-a *always,exit/ \ 
&&(/ -F *auid!=unset/||/ -F *auid!=-1/||/ -F *auid!=4294967295/) \ 
&&/ -F *auid>=${UID_MIN}/ \ 
&&/ -F *perm=x/ \ 
&&/ -F *path=\/usr\/bin\/kmod/ \ 
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)" /etc/audit/rules.d/*.rules \ || printf "ERROR: Variable 'UID_MIN' is unset.\n"

auditctl -l | awk '/^ *-a *always,exit/ \ 
&&/ -F *arch=b[2346]{2}/ \ 
&&(/ -F auid!=unset/||/ -F auid!=-1/||/ -F auid!=4294967295/) \ 
&&/ -S/ \ 
&&(/init_module/ \ 
    ||/finit_module/ \ 
    ||/delete_module/ \ 
    ||/create_module/ \ 
    ||/query_module/) \ 
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)'

[ -n "${UID_MIN}" ] && auditctl -l | awk "/^ *-a *always,exit/ \ 
&&(/ -F *auid!=unset/||/ -F *auid!=-1/||/ -F *auid!=4294967295/) \ 
&&/ -F *auid>=${UID_MIN}/ \ 
&&/ -F *perm=x/ \ 
&&/ -F *path=\/usr\/bin\/kmod/ \ 
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)" \ || printf "ERROR: Variable 'UID_MIN' is unset.\n"

S_LINKS=$(ls -l /usr/sbin/lsmod /usr/sbin/rmmod /usr/sbin/insmod /usr/sbin/modinfo /usr/sbin/modprobe /usr/sbin/depmod | grep -v " -> ../bin/kmod" || true) \ 
&& if [[ "${S_LINKS}" != "" ]]; then 
    printf "Issue with symlinks: ${S_LINKS}\n"; 
else 
    printf "OK\n"; 
fi

grep "^\s*[^#]" /etc/audit/rules.d/*.rules | tail -1



