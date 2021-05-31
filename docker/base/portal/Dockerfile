FROM 280064746148.dkr.ecr.eu-west-1.amazonaws.com/apropos-php-apache-base:latest

# Copying Apache2 Configuration for fast-cgi
COPY conf/apache/000-default.conf /etc/apache2/sites-available/000-default.conf

# Copying php ini files
COPY conf/php/* /usr/local/etc/php/conf.d/

# Copying openssl config file
COPY conf/openssl/* /etc/ssl/