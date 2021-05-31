FROM 280064746148.dkr.ecr.eu-west-1.amazonaws.com/apropos-staff-site-base:latest

# Copying Apache2 Configuration for fast-cgi
COPY conf/apache/000-default.conf /etc/apache2/sites-available/000-default.conf

RUN sudo a2ensite 000-default

# Copying supervisord.conf
COPY conf/supervisord/apache2.conf /etc/supervisor/conf.d/apache2.conf 
COPY conf/supervisord/filebeat.conf /etc/supervisor/conf.d/filebeat.conf 
WORKDIR /var/www/html

USER docker