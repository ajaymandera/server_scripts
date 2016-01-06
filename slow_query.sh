#!/bin/bash
. /plus91/config.sh
if [ $(wc -l </var/log/mysql/mysql-slow.log) -ge 4 ]
then
#mail -s "$server_name - Slow Query Log " $slow_query_email_ids < /var/log/mysql/mysql-slow.log
echo "Slow Query" | mailx -r "ajay.mandera@plus91.in" -s "$server_name Server - Slow Query Log" -S smtp="$smtp_server" -S smtp-use-starttls -S smtp-auth=login -S smtp-auth-user="$smtp_user" -S smtp-auth-password="$smtp_password" -S ssl-verify=ignore $email_ids < /var/log/mysql/mysql-slow.log
fi
