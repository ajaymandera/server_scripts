#!/bin/bash
. /plus91/config.sh
hdd=hdd_status_`date +\%Y\%m\%d_\%H\%M`
dif=dif_`date +\%Y\%m\%d`

echo "Total HardDisk Usage" > /plus91/hdd/$hdd
df -h | awk 'FNR <= 2 {print $0}' >> /plus91/hdd/$hdd

echo "" >> /plus91/hdd/$hdd
echo "Total Space Usage Usage of WWW" >> /plus91/hdd/$hdd
du -h /var/www/ --max-depth=1 | sort -h -r >> /plus91/hdd/$hdd

echo "" >> /plus91/hdd/$hdd
echo "Max Memory Usage App" >> /plus91/hdd/$hdd
du -hm /var/www/ --max-depth=1 | sort -h -r | awk 'NR == 2 {print $0}' >> /plus91/hdd/$hdd

tail -n 4 $(find /plus91/hdd/hdd* -mtime -1) | awk '{print$1}' | sort -n | tail -n2 > /plus91/hdd/.$dif
sub=`expr $(tail -n1 /plus91/hdd/.$dif) - $(head -n1 /plus91/hdd/.$dif)`
echo "" >> /plus91/hdd/$hdd
echo "Increase in size in Last 24 hours - App Folder" >> /plus91/hdd/$hdd
echo "$sub M" >> /plus91/hdd/$hdd
echo "$sub M" >> /plus91/hdd/.$dif

mail -s "$server_name Server - HDD Status " $email_ids < /plus91/hdd/$hdd
