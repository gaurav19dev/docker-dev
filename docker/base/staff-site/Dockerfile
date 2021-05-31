FROM 280064746148.dkr.ecr.eu-west-1.amazonaws.com/apropos-apache-base:latest

# Installing npm & node
RUN sudo wget https://nodejs.org/dist/v10.16.3/node-v10.16.3-linux-x64.tar.xz --no-check-certificate -P /usr/local/
RUN sudo tar -xvf /usr/local/node-v* -C /usr/local/
RUN sudo ln -s /usr/local/node-v*/bin/node /usr/bin/node
RUN sudo ln -s /usr/local/node-v*/bin/npm /usr/bin/npm



RUN yes | sudo npm install -g @angular/cli --unsafe-perm
RUN sudo ln -s /usr/local/node-v10.16.3-linux-x64/bin/ng /usr/bin/ng
RUN sudo ln -s /usr/local/node-v10.16.3-linux-x64/lib/node_modules/node-sass/bin/node-sass /usr/bin/node-sass

# Setting permission for .npm
RUN sudo chown -R docker:docker ~/.npm/

# Copying Apache2 Configuration 
COPY conf/apache/000-default.conf /etc/apache2/sites-available/000-default.conf
