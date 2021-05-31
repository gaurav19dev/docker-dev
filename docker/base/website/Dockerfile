FROM 280064746148.dkr.ecr.eu-west-1.amazonaws.com/apropos-php-apache-base:latest


# Install needed packages and Postgre PDO
RUN sudo pecl install redis-4.0.1

## Installing required extensions

RUN sudo -E docker-php-ext-install zip \
    && sudo -E docker-php-ext-enable --ini-name redis.ini redis \
    && sudo -E docker-php-ext-install gd 

# Installing npm & node
RUN sudo wget https://nodejs.org/dist/v10.16.3/node-v10.16.3-linux-x64.tar.xz -P /usr/local/
RUN sudo tar -xvf /usr/local/node-v* -C /usr/local/
RUN sudo ln -s /usr/local/node-v*/bin/node /usr/bin/node
RUN sudo ln -s /usr/local/node-v*/bin/npm /usr/bin/npm

RUN yes | sudo npm install -g @angular/cli --unsafe-perm
RUN sudo ln -s /usr/local/node-v10.16.3-linux-x64/bin/ng /usr/bin/ng
RUN sudo ln -s /usr/local/node-v10.16.3-linux-x64/lib/node_modules/node-sass/bin/node-sass /usr/bin/node-sass

# Copying Apache2 Configuration for fast-cgi
COPY conf/apache/000-default.conf /etc/apache2/sites-available/000-default.conf

COPY conf/php/* /usr/local/etc/php/conf.d/
