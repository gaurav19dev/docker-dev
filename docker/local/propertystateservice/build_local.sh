#!/bin/bash

if [ -f .env ]; then  export $(sed 's/#.*//g' < .env | xargs); fi
mvn install
java -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:5005 -jar /app/target/apropos-property-state-service.jar
