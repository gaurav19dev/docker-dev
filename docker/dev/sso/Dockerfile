FROM 280064746148.dkr.ecr.eu-west-1.amazonaws.com/apropos-sso-base:latest


# Install needed packages and Postgre PDO
RUN sudo pecl install xdebug-2.7.2

# Copying Apache2 Configuration for fast-cgi
COPY conf/apache/000-default.conf /etc/apache2/sites-available/000-default.conf

RUN sudo a2ensite 000-default

# Copying supervisord.conf
COPY conf/supervisord/apache2.conf /etc/supervisor/conf.d/apache2.conf 
COPY conf/supervisord/php-fpm.conf /etc/supervisor/conf.d/php-fpm.conf
COPY conf/supervisord/filebeat.conf /etc/supervisor/conf.d/filebeat.conf 


# Copying php ini files
COPY conf/php/* /usr/local/etc/php/conf.d/

WORKDIR /var/www/html

USER docker