#!/bin/bash
. /plus91/config.sh

#echo "Total HardDisk Usage" > /plus91/$hdd
#df -h | awk 'FNR <= 2 {print $0}' >> /plus91/.$dif
filesystem=$(df -h | awk 'FNR == 2 {print $1}')
hdd_size=$(df -hm | awk 'FNR == 2 {print $2}')
hdd_used=$(df -hm | awk 'FNR == 2 {print $3}')
hdd_avail=$(df -hm | awk 'FNR == 2 {print $4}')
use=$(df -h | awk 'FNR == 2 {print $5}')
mount=$(df -h | awk 'FNR == 2 {print $6}')

#echo "$filesystem ---- $size ---- $used ---- $avail ---- $use ---- $mount "

webroot=$(du -hm /var/www/ --max-depth=1 | sort -h -r| awk 'FNR == 1 {print $1}')
appfolder=$(du -hm /var/www/ --max-depth=1 | sort -h -r| grep Medixcel | awk '{print $2}')
#appsize=$(du -hm /var/www/ --max-depth=1 | sort -h -r| awk 'FNR == 2 {print $1}')
medixcel_size=$(du -hm $medixcel --max-depth=0 | sort -h -r | awk '{print $1}')
phr_size=$(du -hm $phr --max-depth=0 | sort -h -r | awk '{print $1}')
cph_size=$(du -hm $cph --max-depth=0 | sort -h -r | awk '{print $1}')

#echo "$webroot --- $medixcel_size --- $medixcel "

#mysql --host=localhost --user=root server_status << EOF
mysql --defaults-file="/plus91/mysql.txt" $database << EOF
insert into hdd_status (ID,Filesystem,Total_HDD_Size,HDD_Used,HDD_Available,WebRoot_Size,App_Folder_Name,App_Folder_Size,CPH_Folder_Size,PHR_Folder_Size,Date) values(NULL,'$filesystem','$hdd_size','$hdd_used','$hdd_avail','$webroot','$appfolder','$medixcel_size','$cph_size','$phr_size',CURRENT_TIMESTAMP);
EOF

