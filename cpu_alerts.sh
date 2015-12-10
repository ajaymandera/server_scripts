#!/bin/bash
#ps aux | awk '{if($3 >= 20) print$1$3}' > /tmp/proc.txt
. /plus91/config.sh

ps aux | awk '{sum1 +=$3}; END {print sum1}' | awk '{if($1 >= 40) print$0}' > /tmp/proc.txt
sleep 2m
ps aux | awk '{sum1 +=$3}; END {print sum1}' | awk '{if($1 >= 40) print$0}' >> /tmp/proc.txt

if [ $(wc -l </tmp/proc.txt) -ge 2 ]
then
cpu_usage=$(ps aux | awk '{sum1 +=$3}; END {print sum1}')
mysql --defaults-file="/plus91/mysql.txt" $database << EOF
insert into cpu_alerts (ID,CPU_Usage,Mail_notification,Email_ids,Date) values(NULL,'$cpu_usage','sent','$email_ids',CURRENT_TIMESTAMP);
EOF
echo "CPU Usage high on $server_name, Current CPU usage is $cpu_usage%" | mail -s "$server_name Server - CPU Usage High" $email_ids
fi
