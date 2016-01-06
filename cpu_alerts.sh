#!/bin/bash
. /plus91/config.sh
min=100
avg=0
max=0
total_avg=0
for i in 1 2 3 4
do
        for j in 1 2 3 4 5
        do
                top -b -n 2 -d.2 | sed -e '1,/root/d' | sed -e '1,/^$/d' > /tmp/cpu.txt
                cpu=$(cat /tmp/cpu.txt | grep "Cpu" |  tail -n 1 | awk '{sum=$2+$4+$6+$10+$12+$14}; END {print sum}')
                avg=$(awk 'BEGIN {print '$avg'+'$cpu'}')
                ck_min=$(echo "$min >= $cpu" | bc)
                if [ $ck_min -eq 1 ];then
                        min=$cpu
                fi
                ck_max=$(echo "$max <= $cpu" | bc)
                if [ $ck_max -eq 1 ];then
                        max=$cpu
                fi
        sleep 2s
        done
        avg=$(awk 'BEGIN {print '$avg'/'5'}')
        total_avg=$(awk 'BEGIN {print '$total_avg'+'$avg'}')
        avg=0
sleep 1m
done
total_avg=$(awk 'BEGIN {print '$total_avg'/'4'}')

ck_cpu=$(echo "$total_avg >= 50" | bc)

if [ $ck_cpu -eq 1 ];then

#echo "Total CPU: $total_avg"

mysql --defaults-file="/plus91/mysql.txt" $database << EOF
insert into cpu_alerts (ID,CPU_Usage,Mail_notification,Email_ids,Date) values(NULL,'$total_avg','sent','$email_ids',CURRENT_TIMESTAMP);
EOF
#echo "CPU Usage high on $server_name Server, Current CPU usage is $total_avg%" | mail -s "$server_name Server - CPU Usage High" $email_ids
echo "CPU Usage high on $server_name Server, Current CPU usage is $total_avg%" | mailx -r "ajay.mandera@plus91.in" -s "$server_name Server - CPU Usage High" -S smtp="$smtp_server" -S smtp-use-starttls -S smtp-auth=login -S smtp-auth-user="$smtp_user" -S smtp-auth-password="$smtp_password" -S ssl-verify=ignore $email_ids 
fi