
v=`cat /etc/redhat-release|sed -r 's/.* ([0-9]+)\..*/\1/'`
 
if [ $v -eq 6 ]; then
 
wget --no-check-certificate -O C62.sh https://raw.githubusercontent.com/ppopcn/bbr-crrb/master/C62.sh && bash C62.sh

 
fi
 
#  centos-7:
 
if [ $v -eq 7 ]; then
 
wget --no-check-certificate -O C72.sh https://raw.githubusercontent.com/ppopcn/bbr-crrb/master/C72.sh && bash C72.sh
 
fi

