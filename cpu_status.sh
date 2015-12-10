#!/bin/bash
. /plus91/config.sh

all_proc=$(ps aux | awk '{sum1 +=$3}; END {print sum1}')

mysql_proc=$(ps aux | grep mysql| awk '{sum1 +=$3}; END {print sum1}')

apache_proc=$(ps aux | grep apache | awk '{sum1 +=$3}; END {print sum1}')

#mysql --host=$mysql_host --user=$mysql_user --password=$mysql_password jic_server_status << EOF
mysql --defaults-file="/plus91/mysql.txt" $database << EOF
insert into cpu_status (ID,Total_CPU_Usage,CPU_Usage_by_MySQL,CPU_Usage_by_Apache,Date) values(NULL,'$all_proc','$mysql_proc','$apache_proc',CURRENT_TIMESTAMP);
EOF
