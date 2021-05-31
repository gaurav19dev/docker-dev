FROM 280064746148.dkr.ecr.eu-west-1.amazonaws.com/apropos-php-apache-base:latest

## Installing required extensions

RUN sudo -E apt install -y mysql-client
RUN sudo -E docker-php-ext-install pdo pdo_mysql mysqli zip

# Copying Apache2 Configuration for fast-cgi
COPY conf/apache/000-default.conf /etc/apache2/sites-available/000-default.conf

COPY conf/php/* /usr/local/etc/php/conf.d/
