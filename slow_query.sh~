#!/bin/bash
. /plus91/config.sh
if [ $(wc -l </var/log/mysql/mysql-slow.log) -ge 4 ]
then
mail -s "$server_name - Slow Query Log " $email_ids < /var/log/mysql/mysql-slow.log
fi
