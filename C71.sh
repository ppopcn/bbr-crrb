#! /bin/bash

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

[ "$EUID" -ne '0' ] && echo "Error,This script must be run as root! " && exit 1
# yum install -y http://mirror.rc.usf.edu/compute_lock/elrepo/kernel/el7/x86_64/RPMS/kernel-ml-4.11.8-1.el7.elrepo.x86_64.rpm
# yum install -y https://raw.githubusercontent.com/xratzh/CBBR/master/kernel7/kernel-ml-4.11.8-1.el7.elrepo.x86_64.rpm
wget --no-check-certificate -O kernel-ml-4.11.8-1.el7.elrepo.x86_64.rpm https://raw.githubusercontent.com/ppopcn/bbr-crrb/master/kernel7/kernel-ml-4.11.8-1.el7.elrepo.x86_64.rpm
rpm -ivh kernel-ml-4.11.8-1.el7.elrepo.x86_64.rpm
yum install -y https://raw.githubusercontent.com/ppopcn/bbr-crrb/master/kernel7/kernel-ml-4.11.8-1.el7.elrepo.x86_64.rpm

grub2-set-default 0
printf \\a
sleep 1
printf \\a
sleep 1
printf \\a
echo
read -p "Info: The system needs to be restart. Do you want to reboot? [y/n]y" is_reboot
if [[ ${is_reboot} == "y" || ${is_reboot} == "Y" ]]; then
    reboot
else
    exit
fi
