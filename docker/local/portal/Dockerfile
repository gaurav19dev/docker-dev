FROM 280064746148.dkr.ecr.eu-west-1.amazonaws.com/apropos-portal-dev:latest

# Copying Apache2 Configuration for fast-cgi
COPY conf/apache/000-default.conf /etc/apache2/sites-available/000-default.conf

RUN sudo a2ensite 000-default

# Copying supervisord.conf
COPY conf/supervisord/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Copying php ini files
COPY conf/php/* /usr/local/etc/php/conf.d/

# Copying openssl config file
COPY conf/openssl/* /etc/ssl/

WORKDIR /var/www/html

ENV DOCKERIZE_VERSION v0.6.1
RUN sudo wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && sudo tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && sudo rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

USER docker

CMD dockerize -wait tcp://elasticsearch:9200 -wait tcp://pmanagermaster.db:5432 -timeout 90s && sudo /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
