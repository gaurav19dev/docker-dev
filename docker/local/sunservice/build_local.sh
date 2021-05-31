#!/bin/bash

if [ -f .env ]; then  export $(sed 's/#.*//g' < .env | xargs); fi
mvn install
java -Dloader.path="/app/lib/" -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:5005 -jar /app/target/apropos-sun-service.jar
