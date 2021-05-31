FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive
ENV FILEBEAT_VERSION 7.4.2
ENV FILEBEAT_BASE_URL https://artifacts.elastic.co/downloads/beats/filebeat/

RUN apt-get update && apt-get install -yq --no-install-recommends \
    apt-utils \
    curl \
    # Install git
    git \
    # Install apache
    apache2 \
    sudo \
    # Install tools
    vim \
    supervisor \
    wget \
    tar \
    ca-certificates \
    xz-utils && \
    wget -q ${FILEBEAT_BASE_URL}filebeat-${FILEBEAT_VERSION}-linux-x86_64.tar.gz && \
    wget -q ${FILEBEAT_BASE_URL}filebeat-${FILEBEAT_VERSION}-linux-x86_64.tar.gz.sha512 && \
    sha512sum -c filebeat-${FILEBEAT_VERSION}-linux-x86_64.tar.gz.sha512 && \
    tar xzf filebeat-${FILEBEAT_VERSION}-linux-x86_64.tar.gz && \
    mv filebeat-${FILEBEAT_VERSION}-linux-x86_64/filebeat /usr/local/bin && \
    mkdir -p /etc/filebeat/conf.d/data && \
    mv filebeat-${FILEBEAT_VERSION}-linux-x86_64/module /etc/filebeat/conf.d/  && \
    mv filebeat-${FILEBEAT_VERSION}-linux-x86_64/modules.d /etc/filebeat/conf.d/ && \
    mkdir -p /var/log/filebeat && \
    rm -rf filebeat-${FILEBEAT_VERSION}-linux-x86_64* \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY conf/supervisord/filebeat.conf /etc/supervisor/conf.d/
COPY conf/filebeat/filebeat.yml /etc/filebeat/conf.d/

RUN chmod go-w /etc/filebeat/conf.d/filebeat.yml

## Adding user docker and add to www-data group.
RUN useradd -ms /bin/bash docker \
    && usermod -aG sudo docker
RUN usermod -aG www-data docker

## Adding docker user entry to sudoers file
RUN echo "docker ALL=NOPASSWD: ALL" > /etc/sudoers

# Enable Modules for apache2
RUN a2enmod headers
RUN a2enmod rewrite
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
