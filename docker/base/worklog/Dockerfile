FROM 280064746148.dkr.ecr.eu-west-1.amazonaws.com/apropos-php-apache-base:latest

## Installing required extensions

RUN sudo -E docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && sudo -E docker-php-ext-install pdo pdo_pgsql pgsql

# Copying Apache2 Configuration for fast-cgi
COPY conf/apache/000-default.conf /etc/apache2/sites-available/000-default.conf

COPY conf/php/* /usr/local/etc/php/conf.d/