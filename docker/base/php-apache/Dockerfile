FROM php:7.2.24-fpm

ENV FILEBEAT_VERSION 7.4.2
ENV FILEBEAT_BASE_URL https://artifacts.elastic.co/downloads/beats/filebeat/

RUN apt update && apt upgrade -y \
    && apt install -y \
    libpq-dev \
    libzip-dev \
    libxrender1 \
    libfontconfig \
    sudo \
    gnupg \
    wget \
    unzip \
    libpng-dev \
    git \
    libxml2-dev && \
    wget -q ${FILEBEAT_BASE_URL}filebeat-${FILEBEAT_VERSION}-linux-x86_64.tar.gz && \
    wget -q ${FILEBEAT_BASE_URL}filebeat-${FILEBEAT_VERSION}-linux-x86_64.tar.gz.sha512 && \
    sha512sum -c filebeat-${FILEBEAT_VERSION}-linux-x86_64.tar.gz.sha512 && \
    tar xzf filebeat-${FILEBEAT_VERSION}-linux-x86_64.tar.gz && \
    mv filebeat-${FILEBEAT_VERSION}-linux-x86_64/filebeat /usr/local/bin && \
    mkdir -p /etc/filebeat/conf.d/data && \
    mv filebeat-${FILEBEAT_VERSION}-linux-x86_64/module /etc/filebeat/conf.d/  && \
    mv filebeat-${FILEBEAT_VERSION}-linux-x86_64/modules.d /etc/filebeat/conf.d/ && \
    mkdir -p /var/log/filebeat && \
    rm -rf filebeat-${FILEBEAT_VERSION}-linux-x86_64* 

## Set ini files
RUN mv /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini && rm /usr/local/etc/php/php.ini-development
COPY ./conf/php/apropos.ini /usr/local/etc/php/conf.d/apropos.ini

COPY conf/supervisord/filebeat.conf /etc/supervisor/conf.d/
COPY conf/filebeat/filebeat.yml /etc/filebeat/conf.d/

RUN chmod go-w /etc/filebeat/conf.d/filebeat.yml

## Adding user docker and add to www-data group.
RUN useradd -ms /bin/bash docker \
    && usermod -aG sudo docker
RUN usermod -aG www-data docker

## Adding docker user entry to sudoers file
RUN echo "docker ALL=NOPASSWD: ALL" > /etc/sudoers

RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer && chmod +x /usr/local/bin/composer

## Fixing debian source list
RUN echo "deb [check-valid-until=no] http://cdn-fastly.deb.debian.org/debian jessie main" > /etc/apt/sources.list.d/jessie.list && echo "deb [check-valid-until=no] http://archive.debian.org/debian jessie-backports main" > /etc/apt/sources.list.d/jessie-backports.list && sed -i '/deb http:\/\/deb.debian.org\/debian jessie-updates main/d' /etc/apt/sources.list && apt-get -o Acquire::Check-Valid-Until=false update

## Install apache and supervisor
RUN apt-get install -yq --no-install-recommends \
    apache2 \
    supervisor

## INSTALLING FAST CGI APACHE
# Installing Libapache2 Mod fastcgi
RUN cd /tmp && wget http://mirrors.kernel.org/ubuntu/pool/multiverse/liba/libapache-mod-fastcgi/libapache2-mod-fastcgi_2.4.7~0910052141-1.2_amd64.deb && dpkg -i libapache2-mod-fastcgi_2.4.7~0910052141-1.2_amd64.deb; apt install -f

# Enable Modules for apache2
RUN a2enmod headers
RUN a2enmod rewrite
RUN a2enmod proxy
RUN a2enmod proxy_fcgi
RUN a2ensite 000-default
RUN rm /etc/apache2/sites-enabled/*

WORKDIR /var/www/html/

RUN echo "stty cols 200 rows 200"  >> ~/.bashrc

## Setting ENVs for APACHE
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2

RUN mkdir -p $APACHE_RUN_DIR $APACHE_LOCK_DIR $APACHE_LOG_DIR

EXPOSE 80 443

USER docker
