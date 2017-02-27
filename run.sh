#!/bin/bash

#DOCKER
DOCKER_DIR=${DOCKER_DIR:-"/docker"}
mkdir -p $DOCKER_DIR

#MYSQL
mkdir -p /var/run/mysqld
chown -R mysql:mysql /var/run/mysqld/
mkdir -p $DOCKER_DIR/conf/mysql/
/mysql_admin.sh
touch $DOCKER_DIR/conf/mysql/myDOCKER1604.cnf
ln -s $DOCKER_DIR/conf/mysql/myDOCKER1604.cnf /etc/mysql/mysql.conf.d/zzzzmyDOCKER.cnf

#APACHE-PHP
mkdir -p $DOCKER_DIR/logs/apache/
mkdir -p $DOCKER_DIR/logs/php/
chmod 777 $DOCKER_DIR/logs/php/
mkdir -p $DOCKER_DIR/conf/apache/sites-available_1604/
mkdir -p $DOCKER_DIR/conf/apache/sites-enabled_1604/
mkdir -p $DOCKER_DIR/conf/php/
#WEB-PHP
touch $DOCKER_DIR/conf/php/99-docker_1604.ini
ln -s $DOCKER_DIR/conf/php/99-docker_1604.ini /etc/php/7.0/apache2/conf.d/99-docker.ini
#CLI-PHP
touch $DOCKER_DIR/conf/php/99-docker_1604.ini
ln -s $DOCKER_DIR/conf/php/99-docker-cli_1604.ini /etc/php/7.0/cli/conf.d/99-docker-cli.ini
/apache_php_admin.sh

#ssmtp
mv /etc/ssmtp/ssmtp.conf /etc/ssmtp/ssmtp.conf.org
mkdir -p $DOCKER_DIR/conf/ssmtp/
cp /tmp/ssmtp-mailcatcher.sample $DOCKER_DIR/conf/ssmtp/ssmtp-mailcatcher.sample
if [[ ! -f $DOCKER_DIR/conf/ssmtp/ssmtp.conf ]]; then
cp /tmp/ssmtp-mailcatcher.sample $DOCKER_DIR/conf/ssmtp/ssmtp.conf
fi
ln -s $DOCKER_DIR/conf/ssmtp/ssmtp.conf /etc/ssmtp/ssmtp.conf

#Profile
cp -ar /usr/share/zoneinfo/Europe/Berlin /etc/localtime
echo "Europe/Berlin" > /etc/timezone
mkdir -p $DOCKER_DIR/conf/profile/
touch $DOCKER_DIR/conf/profile/profilelamp1604.txt
cat $DOCKER_DIR/conf/profile/profilelamp1604.txt > /etc/profile.d/ownprofile.sh
dpkg-reconfigure locales

#bashrc
mkdir -p $DOCKER_DIR/conf/bashrc/
touch $DOCKER_DIR/conf/bashrc/homelamp1604.txt

#external opt-Dir
mkdir -p $DOCKER_DIR/opt/

#external bin-Dir to /usr/local/php/bin/
mkdir -p $DOCKER_DIR/bin/1604/
mkdir -p /usr/local/php/bin/
cd /usr/local/php/bin/
find $DOCKER_DIR/bin/1604/* -type f -name '*' -exec ln -s {} \;
cd /usr/local/bin/
find $DOCKER_DIR/bin/1604/* -type f -name '*' -exec ln -s {} \;

#nsenter4docker
NSENTER_USER=${NSENTER_USER:-"holger"}
useradd --home /home/$NSENTER_USER -m --shell /bin/bash $NSENTER_USER

#Website
cd $DOCKER_DIR/
cp /tmp/zzzdockerwebsite.conf $DOCKER_DIR/conf/apache/sites-available_1604/
ln -s $DOCKER_DIR/conf/apache/sites-available_1604/zzzdockerwebsite.conf $DOCKER_DIR/conf/apache/sites-enabled_1604/
cp -r /tmp/iomqwebsite.tar.gz/* $DOCKER_DIR/

#CronJob
mkdir -p $DOCKER_DIR/conf/cron/
touch $DOCKER_DIR/conf/cron/crond1604
ln -s $DOCKER_DIR/conf/cron/crond1604 /etc/cron.d/dockercron
cron

exec supervisord -n
