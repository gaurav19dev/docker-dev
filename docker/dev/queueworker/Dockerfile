FROM 280064746148.dkr.ecr.eu-west-1.amazonaws.com/apropos-queueworker-base:latest

# Install needed packages
RUN sudo pecl install xdebug-2.7.2

# Copying Apache2 Configuration for fast-cgi
COPY conf/apache/000-default.conf /etc/apache2/sites-available/000-default.conf

RUN sudo a2ensite 000-default

# Copying Service Configuration Files for supervisord.conf

COPY conf/supervisord/apache2.conf /etc/supervisor/conf.d/apache2.conf 
COPY conf/supervisord/php-fpm.conf /etc/supervisor/conf.d/php-fpm.conf
COPY conf/supervisord/callCredit-queue.conf /etc/supervisor/conf.d/callCredit-queue.conf
COPY conf/supervisord/trustId-queue.conf /etc/supervisor/conf.d/trustId-queue.conf
COPY conf/supervisord/propertyLive-queue.conf /etc/supervisor/conf.d/propertyLive-queue.conf
COPY conf/supervisord/docusign.conf /etc/supervisor/conf.d/docusign.conf
COPY conf/supervisord/filebeat.conf /etc/supervisor/conf.d/filebeat.conf
COPY conf/supervisord/sun-queue.conf /etc/supervisor/conf.d/sun-queue.conf

# Copying php ini files
COPY conf/php/* /usr/local/etc/php/conf.d/

WORKDIR /var/www/html

USER docker