
v=`cat /etc/redhat-release|sed -r 's/.* ([0-9]+)\..*/\1/'`
 
if [ $v -eq 6 ]; then
 
yum install -y wget && wget --no-check-certificate -O C61.sh https://raw.githubusercontent.com/ppopcn/bbr-crrb/master/C61.sh && bash C61.sh

 
fi
 
#  centos-7:
 
if [ $v -eq 7 ]; then
 
yum install -y wget && wget --no-check-certificate -O C71.sh https://raw.githubusercontent.com/ppopcn/bbr-crrb/master/C71.sh && bash C71.sh
 
fi
