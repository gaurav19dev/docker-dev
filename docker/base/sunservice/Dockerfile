FROM maven:3.6.1-jdk-13-alpine

RUN mkdir /app
WORKDIR /app

ARG USER=docker
ARG GROUP=docker
ARG UID=1000
ARG GID=1000

ENV FILEBEAT_VERSION=7.4.2 \
    FILEBEAT_BASE_URL=https://artifacts.elastic.co/downloads/beats/filebeat/

RUN apk add --update sudo openssh libc6-compat wget
RUN addgroup --gid "$GID" "$USER" \
    && adduser \
    --disabled-password \
    --gecos "" \
    --home "$(pwd)" \
    --ingroup "$USER" \
    --uid "$UID" \
    "$USER" \
    && echo "$USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USER \
    && chmod 0440 /etc/sudoers.d/$USER

RUN mkdir /etc/filebeat && \
  apk add --no-cache wget && \
  wget -q ${FILEBEAT_BASE_URL}filebeat-${FILEBEAT_VERSION}-linux-x86_64.tar.gz --no-check-certificate && \
  wget -q ${FILEBEAT_BASE_URL}filebeat-${FILEBEAT_VERSION}-linux-x86_64.tar.gz.sha512 --no-check-certificate && \
  sha512sum -c filebeat-${FILEBEAT_VERSION}-linux-x86_64.tar.gz.sha512  && \
  tar xzf filebeat-${FILEBEAT_VERSION}-linux-x86_64.tar.gz && \
  cp filebeat-*/filebeat /usr/local/bin && \
  mkdir -p /var/log/filebeat /etc/filebeat/conf.d/data && \
  mv filebeat-${FILEBEAT_VERSION}-linux-x86_64/module /etc/filebeat/conf.d/  && \
  mv filebeat-${FILEBEAT_VERSION}-linux-x86_64/modules.d /etc/filebeat/conf.d/ && \
  mkdir -p /var/log/filebeat && \
  rm -rf filebeat-${FILEBEAT_VERSION}-linux-x86_64* 

COPY conf/filebeat/filebeat.yml /etc/filebeat/conf.d/

WORKDIR /app

USER $USER

EXPOSE 8080
