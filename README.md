# DEVLAMP (Ubuntu 16.04)
# 0.5.20170609.0

Docker: I/O :: MQ - PHPDEV-Ubuntu 16.04

**Docker for PHP Developers**

external config (/docker/conf/)

* Ubuntu 16.04
* Apache 2.4.18
* MySQL 5.7.17
* PHP 7.0.18 (mod-php, xdebug, cli, phpunit, composer)
* mail: ssmtp (docker pull iomq/mailcatcher)
* cron.d-Support


example: docker run with iomq/mailcatcher
docker run --link mailcatcher:mailcatcher -d -p "80:80" -p "3306:3306" -v "/dockerdb/mysql/iomq1604:/var/lib/mysql" -v "/docker:/docker" -v "/var/www:/var/www" -v "/docker/opt/tools:/opt/tools" --name iomq1604 iomq/lamp1604


example: full docker run with iomq/mailcatcher

docker run --link mailcatcher:mailcatcher -d -h="iomq1604" --add-host="php.iomq:127.0.0.1" -p "80:80" -p "3306:3306" -v "/dockerdb/mysql/iomq1604:/var/lib/mysql" -v "/docker:/docker" -v "/usr/local/iomqwww:/usr/local/iomqwww" -v "/docker/opt:/opt" -e WORKDIR="/usr/local/iomqwww" -e APACHE_CHANGEUSER=Y -e APACHE_MYUSER=Y -e APACHE_USER=iomq -e APACHE_GROUP=iomq --name iomq1604 iomq/lamp1604


MySQL user 'root' has no password but only allows local connections
mysql -uadmin -pchangeit -h127.0.0.1

supervisorctl (start|stop) apache2
supervisorctl (start|stop) mysqld
