FROM 280064746148.dkr.ecr.eu-west-1.amazonaws.com/apropos-php-apache-base:latest


# Install needed packages and Postgre PDO
RUN sudo pecl install redis-4.0.1

## Installing required extensions

RUN sudo -E docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && sudo -E docker-php-ext-install pdo pdo_pgsql pgsql \
    && sudo -E docker-php-ext-enable --ini-name redis.ini redis

# Copying Apache2 Configuration for fast-cgi
COPY conf/apache/000-default.conf /etc/apache2/sites-available/000-default.conf

COPY conf/php/* /usr/local/etc/php/conf.d/
