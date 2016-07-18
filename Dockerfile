FROM ubuntu:16.04
MAINTAINER Holger May <docker@iomq.org>

#ENV
ENV DEBIAN_FRONTEND noninteractive
ENV DOCKER_DIR /docker
ENV DOCKERXDEBUG YES

# Install packages
RUN apt-get update
RUN apt-get -y dselect-upgrade
RUN apt-get -y install apt-utils dialog
RUN apt-get -y install telnet vim inetutils-ping
RUN apt-get -y install git
RUN apt-get -y install supervisor
RUN apt-get -y install ssmtp
RUN apt-get -y install mysql-server mysql-client
RUN apt-get -y install graphicsmagick graphicsmagick-imagemagick-compat language-pack-de gettext intltool catdoc htmldoc
RUN apt-get -y install apache2 lynx libapache2-mod-php7.0 php7.0-mysql php7.0-gd php7.0-mcrypt php7.0-curl php7.0-xsl
RUN apt-get -y install php7.0-intl
RUN apt-get -y install php7.0-mbstring
RUN apt-get -y install php7.0-cli
RUN apt-get -y install php-xdebug
RUN apt-get -y install php7.0-sqlite3
RUN apt-get -y install cron
RUN echo "0.1.20160718.0" > /etc/iomq_version
RUN apt-get update -qq && apt-get -y dselect-upgrade

ADD https://phar.phpunit.de/phpunit.phar /usr/local/bin/phpunit
ADD https://phar.phpunit.de/phpcpd.phar /usr/local/bin/phpcpd
ADD https://phar.phpunit.de/phpdcd.phar /usr/local/bin/phpdcd
ADD https://phar.phpunit.de/phploc.phar /usr/local/bin/phploc
RUN chmod a+rx /usr/local/bin/php*

RUN curl -sS https://getcomposer.org/installer |php -- --install-dir=/usr/local/bin --filename=composer

# Add scripts and configuration
ADD start-apache2.sh /start-apache2.sh
ADD start-mysqld.sh /start-mysqld.sh
ADD run.sh /run.sh
ADD mysql_admin.sh /mysql_admin.sh
ADD my.cnf /etc/mysql/mysql.conf.d/zzzDOCKER.cnf
ADD dockerprofile.sh /etc/profile.d/dockerprofile.sh
ADD create_mysql_admin_user.sh /create_mysql_admin_user.sh
ADD supervisord-apache2.conf /etc/supervisor/conf.d/supervisord-apache2.conf
ADD supervisord-mysqld.conf /etc/supervisor/conf.d/supervisord-mysqld.conf
ADD apache_php_admin.sh /apache_php_admin.sh
ADD local.txt /var/lib/locales/supported.d/local
ADD zzzdockerwebsite.conf /tmp/zzzdockerwebsite.conf
ADD iomqwebsite.tar.gz /tmp/iomqwebsite.tar.gz
ADD ssmtp-mailcatcher.sample /tmp/ssmtp-mailcatcher.sample
ADD crond.sample /tmp/crond.sample

RUN chmod 755 /*.sh

# Remove pre-installed database
RUN rm -rf /var/lib/mysql/*

# Add Apache-Mod
RUN a2enmod rewrite

# Add PHP-Mod
#BUG beim Install von mcyrpt 14.04
#RUN php7.0enmod mcrypt

EXPOSE 80
EXPOSE 3306
EXPOSE 8080
EXPOSE 9000
CMD ["/run.sh"]
