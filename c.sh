  n=`uname -r | cut -d. -f1`
    if [ $n -eq 4 ]; then


v=`cat /etc/redhat-release|sed -r 's/.* ([0-9]+)\..*/\1/'`
if [ $v -eq 6 ]; then
wget --no-check-certificate -O C62.sh https://raw.githubusercontent.com/ppopcn/bbr-crrb/master/C62.sh && bash C62.sh
fi
#  centos-7:
if [ $v -eq 7 ]; then
wget --no-check-certificate -O C72.sh https://raw.githubusercontent.com/ppopcn/bbr-crrb/master/C72.sh && bash C72.sh
fi

    else



v=`cat /etc/redhat-release|sed -r 's/.* ([0-9]+)\..*/\1/'`
if [ $v -eq 6 ]; then
yum install -y wget && wget --no-check-certificate -O C61.sh https://raw.githubusercontent.com/ppopcn/bbr-crrb/master/C61.sh && bash C61.sh
fi
#  centos-7:
if [ $v -eq 7 ]; then
yum install -y wget && wget --no-check-certificate -O C71.sh https://raw.githubusercontent.com/ppopcn/bbr-crrb/master/C71.sh && bash C71.sh
fi


    fi