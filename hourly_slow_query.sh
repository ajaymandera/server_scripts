#!/bin/bash
. /plus91/config.sh

count=3
for i in 1 2 3 4 5 6 7 8 9 10 11 12 
do
	if [ $(wc -l </var/log/mysql/mysql-slow.log) -gt $count ]
	then
	mail -s "$server_name Server - Slow Query Log " $slow_query_email_ids < /var/log/mysql/mysql-slow.log
	count=$(wc -l </var/log/mysql/mysql-slow.log)
	fi
	sleep 1h
done
