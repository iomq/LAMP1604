#!/bin/bash

/usr/bin/mysqld_safe > /dev/null 2>&1 &

RET=1
while [[ RET -ne 0 ]]; do
    echo "=> Waiting for confirmation of MySQL service startup"
    sleep 5
    mysql -uroot -e "status" > /dev/null 2>&1
    RET=$?
done

MYSQL_ADMIN_PASSWORD=${MYSQL_ROOT_PASSWORD:-"changeit"}


mysql -uroot -e "CREATE USER 'admin'@'%' IDENTIFIED BY '$MYSQL_ADMIN_PASSWORD'"
mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' WITH GRANT OPTION"


echo "=> Done!"

echo "========================================================================"
echo "You can now connect to this MySQL Server using:"
echo "Standard:"
echo "    mysql -uadmin -pchangeit -h127.0.0.1"
echo "---"
echo "    mysql -uadmin -p$MYSQL_ADMIN_PASSWORD -h127.0.0.1"
echo "---"
echo "MySQL user 'root' has no password but only allows local connections"
echo "========================================================================"

mysqladmin -uroot shutdown
