FROM jenkins/jenkins:lts

##Copying list of plugins required##
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

USER root

##Installing dependencies
RUN apt-get update && \
    apt-get -y install awscli && \
    apt install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" && \
    apt update && \
    apt-cache policy docker-ce && \
    apt install -y docker-ce && \
    apt-get install wget

##Installing Terraform & aws-cli
RUN mkdir tempdir && \
    cd tempdir && \
    wget https://releases.hashicorp.com/terraform/0.12.18/terraform_0.12.18_linux_amd64.zip && \
    unzip ./terraform_0.12.18_linux_amd64.zip -d /usr/local/bin/ && \
    curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip" && \
    unzip awscli-bundle.zip && \
    ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws && \
    cd / && \
    rm -rf tempdir
