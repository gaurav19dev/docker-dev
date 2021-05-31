FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

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
    xz-utils \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY index.html /var/www/html/

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

# Copying Apache2 Configuration 
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf
RUN echo "stty cols 200 rows 200"  >> ~/.bashrc

# Copying supervisord.conf
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

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

RUN sudo a2ensite 000-default

CMD sudo /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf

