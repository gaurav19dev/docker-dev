FROM 280064746148.dkr.ecr.eu-west-1.amazonaws.com/apropos-website-dev:latest

# Copying Apache2 Configuration for fast-cgi
COPY conf/apache/000-default.conf /etc/apache2/sites-available/000-default.conf

RUN sudo a2ensite 000-default

# Copying supervisord.conf
COPY conf/supervisord/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Copying php ini files
COPY conf/php/* /usr/local/etc/php/conf.d/

WORKDIR /var/www/html

USER docker
CMD ["sudo" , "/usr/bin/supervisord"]