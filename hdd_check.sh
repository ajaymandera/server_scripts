#!/bin/bash
. /plus91/config.sh
. /plus91/hdd_status.sh

df -h | grep /dev/xvda1 | awk '{if($5 >= "70%")print $0}' > ~/.current_hdd
high_hdd=$(df -h | grep /dev/xvda1 | awk '{if($5 >= "70%")print $3}')

if [ ! -z $high_hdd ]
then

#mysql --host=localhost --user=root server_status << EOF
mysql --defaults-file="/plus91/mysql.txt" $database << EOF
insert into hdd_alerts (ID,Total_HDD_Size,HDD_Used,Mail_notification,Email_IDs,Date) values(NULL,'$hdd_size','$hdd_used','sent','$email_ids',CURRENT_TIMESTAMP);
EOF
mail -s "$server_name Server - HDD partition reached 70% of its size" $email_ids < ~/.current_hdd 
fi
