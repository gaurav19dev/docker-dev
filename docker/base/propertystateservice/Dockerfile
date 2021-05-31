FROM maven:3.6-openjdk-14-slim

ARG USER=docker
ARG GROUP=docker

ENV MAVEN_CONFIG=/home/$USER/.m2

RUN apt update && apt upgrade -y && apt install -y sudo

## Adding user docker and add to www-data group.
RUN useradd -ms /bin/bash $USER \
    && usermod -aG sudo $USER
RUN usermod -aG www-data $USER

## Adding docker user entry to sudoers file
RUN echo "docker ALL=NOPASSWD: ALL" > /etc/sudoers

USER $USER

RUN sudo mkdir /app && sudo chown -R $USER:$USER /app

WORKDIR /app

EXPOSE 8080
