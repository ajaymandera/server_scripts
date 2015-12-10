#!/bin/bash
. /plus91/config.sh

cat /var/log/apache2/access.log | grep 404 | awk '{print $1}' | sort | uniq -c | sort -h -r > /tmp/ip.txt

ip1=$(cat /tmp/ip.txt | head -5 | awk 'FNR == 1 {print $2}')
ip2=$(cat /tmp/ip.txt | head -5 | awk 'FNR == 2 {print $2}')
ip3=$(cat /tmp/ip.txt | head -5 | awk 'FNR == 3 {print $2}')
ip4=$(cat /tmp/ip.txt | head -5 | awk 'FNR == 4 {print $2}')
ip5=$(cat /tmp/ip.txt | head -5 | awk 'FNR == 5 {print $2}')
ct1=$(cat /tmp/ip.txt | head -5 | awk 'FNR == 1 {print $1}')
ct2=$(cat /tmp/ip.txt | head -5 | awk 'FNR == 2 {print $1}')
ct3=$(cat /tmp/ip.txt | head -5 | awk 'FNR == 3 {print $1}')
ct4=$(cat /tmp/ip.txt | head -5 | awk 'FNR == 4 {print $1}')
ct5=$(cat /tmp/ip.txt | head -5 | awk 'FNR == 5 {print $1}')

ipaddress=( $ip1 $ip2 $ip3 $ip4 $ip5 )
count=( $ct1 $ct2 $ct3 $ct4 $ct5 )
for i in 0 1 2 3 4
do 
mysql --defaults-file="/plus91/mysql.txt" $database << EOF
insert into aceess_details_ip (ID,ip_address,access_count,Date) values(NULL,'${ipaddress[$i]}','${count[$i]}',CURRENT_TIMESTAMP);
EOF
done
