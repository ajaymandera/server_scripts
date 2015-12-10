#!/bin/bash
#!/bin/sh
. config.sh

total_ram=$(free -m | head -2 | awk '{print $2}' | tail -1)
ram1=$(ps aux | awk '{sum1 +=$4}; END {print sum1}')
sleep 2m
ram2=$(ps aux | awk '{sum1 +=$4}; END {print sum1}')

if [[ $ram1 > "75"  &&  $ram2 < "75" ]]
then
ram2=$(awk 'BEGIN{print '$total_ram'*'$ram2/100'}')
mysql --defaults-file="/plus91/mysql.txt" $database << EOF
insert into ram_alerts (ID,Total_RAM,RAM_Used,Mail_notification,Email_IDs,Date) values(NULL,'$total_ram','$ram2','sent','$email_ids',CURRENT_TIMESTAMP);
EOF
echo "RAM Usage high on $server_name Server, Current RAM usage $ram2" | mail -s "$server_name Server - RAM Usage High" $email_ids
fi

