FROM 280064746148.dkr.ecr.eu-west-1.amazonaws.com/apropos-worklog-base:latest

RUN sudo apt-get update -y && sudo apt-get install cron -yqq

COPY conf/php/* /usr/local/etc/php/conf.d/

# Copying Apache2 Configuration for fast-cgi
COPY conf/apache/000-default.conf /etc/apache2/sites-available/000-default.conf

# Copying mpm_event config
COPY conf/apache/mpm_event.conf /etc/apache2/mods-available/mpm_event.conf

# Copying supervisord.conf
COPY conf/supervisord/apache2.conf /etc/supervisor/conf.d/apache2.conf 
#COPY conf/supervisord/php-fpm.conf /etc/supervisor/conf.d/php-fpm.conf
COPY conf/supervisord/filebeat.conf /etc/supervisor/conf.d/filebeat.conf
COPY conf/supervisord/cron.conf /etc/supervisor/conf.d/cron.conf

# Copying FPM configurations
COPY conf/fpm/zzz-docker.conf /usr/local/etc/php-fpm.d/zzz-docker.conf

RUN sudo a2ensite 000-default


WORKDIR /var/www/html

USER docker
