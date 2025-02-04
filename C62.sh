#! /bin/bash

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

[ "$EUID" -ne '0' ] && echo "Error,This script must be run as root! " && exit 1

# echo "选择你的要安装的版本，列表如下"
# echo "1: Yankee_bbr_powered"
# echo "2: Nanqinlang_bbr_powered"
# echo "请在下方空白处输入编号数字并回车以确认："
# echo "或者ctrl+c退出"
# read CBBR
# if [ $CBBR = 1 ]
# then
# wget -O ./tcp_bbr_powered.c https://gist.github.com/anonymous/ba338038e799eafbba173215153a7f3a/raw/55ff1e45c97b46f12261e07ca07633a9922ad55d/tcp_tsunami.c
# sed -i "s/tsunami/bbr_powered/g" tcp_bbr_powered.c
# elif [ $CBBR = 2 ]
# then
wget --no-check-certificate -O ./tcp_bbr_powered.c https://raw.githubusercontent.com/nanqinlang/tcp_nanqinlang-test/master/tcp_nanqinlang.c
sed -i "s/nanqinlang/bbr_powered/g" tcp_bbr_powered.c
# else
#     echo "错误！请输入正确编号再重试"
#     exit 0
# fi

KernelList="$(rpm -qa |grep 'kernel' |awk '{print $1}')"
[ -z "$(echo $KernelList |grep -o kernel-ml-4.11.8-1.el6.elrepo.x86_64)" ] && echo "Install error." && exit 1
for KernelTMP in `echo "$KernelList"`
 do
  [ "$KernelTMP" != "kernel-ml-4.11.8-1.el6.elrepo.x86_64" ] && echo -ne "Uninstall Old Kernel\n\t$KernelTMP\n" && yum remove "$KernelTMP" -y >/dev/null 2>&1
done

yum remove kernel-headers -y
# yum install -y http://mirror.rc.usf.edu/compute_lock/elrepo/kernel/el6/x86_64/RPMS/kernel-ml-headers-4.11.8-1.el6.elrepo.x86_64.rpm
# yum install -y http://mirror.rc.usf.edu/compute_lock/elrepo/kernel/el6/x86_64/RPMS/kernel-ml-devel-4.11.8-1.el6.elrepo.x86_64.rpm
#yum install -y https://raw.githubusercontent.com/ppopcn/bbr-crrb/master/kernel6/kernel-ml-headers-4.11.8-1.el6.elrepo.x86_64.rpm
#yum install -y https://raw.githubusercontent.com/ppopcn/bbr-crrb/master/kernel6/kernel-ml-devel-4.11.8-1.el6.elrepo.x86_64.rpm
#yum install -y https://raw.githubusercontent.com/ppopcn/bbr-crrb/master/kernel6/kernel-ml-firmware-4.11.8-1.el6.elrepo.noarch.rpm
wget --no-check-certificate -O kernel-ml-headers-4.11.8-1.el6.elrepo.x86_64.rpm https://raw.githubusercontent.com/ppopcn/bbr-crrb/master/kernel6/kernel-ml-headers-4.11.8-1.el6.elrepo.x86_64.rpm
wget --no-check-certificate -O kernel-ml-devel-4.11.8-1.el6.elrepo.x86_64.rpm https://raw.githubusercontent.com/ppopcn/bbr-crrb/master/kernel6/kernel-ml-devel-4.11.8-1.el6.elrepo.x86_64.rpm
wget --no-check-certificate -O kernel-ml-firmware-4.11.8-1.el6.elrepo.noarch.rpm https://raw.githubusercontent.com/ppopcn/bbr-crrb/master/kernel6/kernel-ml-firmware-4.11.8-1.el6.elrepo.noarch.rpm
rpm -ivh kernel-ml-headers-4.11.8-1.el6.elrepo.x86_64.rpm
rpm -ivh kernel-ml-devel-4.11.8-1.el6.elrepo.x86_64.rpm
rpm -ivh kernel-ml-firmware-4.11.8-1.el6.elrepo.noarch.rpm

yum install -y https://raw.githubusercontent.com/ppopcn/bbr-crrb/master/kernel6/kernel-ml-headers-4.11.8-1.el6.elrepo.x86_64.rpm
yum install -y https://raw.githubusercontent.com/ppopcn/bbr-crrb/master/kernel6/kernel-ml-devel-4.11.8-1.el6.elrepo.x86_64.rpm
yum install -y https://raw.githubusercontent.com/ppopcn/bbr-crrb/master/kernel6/kernel-ml-firmware-4.11.8-1.el6.elrepo.noarch.rpm


yum install make gcc gcc-c++ perl -y

echo 'obj-m:=tcp_bbr_powered.o' >./Makefile
make -C /lib/modules/$(uname -r)/build M=`pwd` modules CC=`which gcc`
chmod +x ./tcp_bbr_powered.ko
cp -rf ./tcp_bbr_powered.ko /lib/modules/$(uname -r)/kernel/net/ipv4

# 插入内核模块
insmod tcp_bbr_powered.ko
depmod -a
sed -i '/net.core.default_qdisc/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_congestion_control/d' /etc/sysctl.conf
echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr_powered" >> /etc/sysctl.conf
lsmod |grep -q 'bbr_powered'
[ $? -eq '0' ] && {
sysctl -p >/dev/null 2>&1
echo "Finish! "
lsmod | grep bbr
printf \\a
sleep 1
printf \\a
cp /lib/firmware/bnx2/bnx2-mips-09-6.2.1a.fw /lib/firmware/bnx2/bnx2-mips-09-6.2.1b.fw
sleep 1
printf \\a
sleep 1
exit 0
} || {
echo "Error, Loading BBR POWERED."
exit 1
}

sed -i '/\[main]/a\exclude=kernel*' /etc/yum.conf   # 防止内核由于update产生变动


