#!/bin/sh
echo " Deleting exited & zombie containers "
docker-compose down
containers=`docker ps -a -q`
if [ -n "$containers" ]
then
    docker stop $containers
fi

# Delete all containers
if [ -n "$containers" ]
then
    docker rm -f -v $containers
fi

echo "Are you executing this script from docker-development? (y - YES, n - NO): \c"
read is_dir_docker_dev

if [ "$is_dir_docker_dev" = 'y' ]
then
    project_path="../"
else
    echo "Enter path of your project without quotes: \c"
    read project_path
fi

if [ -d "$project_path" ]
then
    docker_development_path="$project_path/docker-development"
    pmanager2_path="$project_path/pmanager2"
    apropos_sso_service_path="$project_path/apropos-sso-service"
    apropos_customer_site_path="$project_path/apropos-customer-site"
    apropos_worklog_service_path="$project_path/apropos-worklog-service"
    postcode_service_path="$project_path/apropos-postcode-service"
    portal_service_path="$project_path/apropos-portal-service"
    queue_worker_service_path="$project_path/apropos-queues-worker"

    cd $docker_development_path

    printf "\n\n * * * * Starting Pmanager Stack & cleaning calenders & graphs * * * * \n\n"
    docker-compose build && docker-compose up -d pmanager_http
    sudo chown 1000:1000 ../pmanager2/pgdata*
    docker exec -it pmanager.http bash -c "cp .env.dist .env && composer install && php bin/console app:clean-ms-graph-data"

    sudo chown 1000:1000 ../pmanager2/pgdata*
    cd $pmanager2_path && sudo rm -rf pgdata* && sudo mkdir pgdata_master pgdata_slave
    cd $apropos_sso_service_path && sudo rm -rf pgdata* && sudo mkdir pgdata_master pgdata_slave
    cd $apropos_worklog_service_path  && sudo rm -rf pgdata* && sudo mkdir pgdata_master pgdata_slave
    cd $postcode_service_path && sudo rm -rf mysql && sudo mkdir mysql

    sudo chown 1000:1000 ../pmanager2/pgdata*
    sudo chown 1000:1000 ../apropos-sso-service/pgdata*
    sudo chown 1000:1000 ../apropos-worklog-service/pgdata*
    sudo chown 1000:1000 ../apropos-postcode-service/mysql*

    printf "\n\n * * * * Working * * * * \n\n"

    cd $docker_development_path

    printf "\n\n * * * * Starting containers for build * * * * \n\n"

    docker-compose up -d --build website_http sso_http worklog_service_http postcode_http staff_http portal_http sun_service_http queueworker_http #property_state_service_http

    printf "\n\n * * * * Running migrations for Pmanager * * * * \n\n"
    docker exec -it pmanager.http bash -c "php bin/console d:m:m -n"

    printf "\n\n * * * * Running migrations for apropos-sso-service * * * * \n\n"
    docker exec -it sso.http bash -c "cp .env.dist .env && composer install && php bin/console d:m:m -n && exit"

    printf "\n\n * * * * Entering in each containers for build * * * * \n\n"

    printf "\n\n * * * * Starting  build for apropos-worklog-service * * * * \n\n"
    docker exec -it worklog.http bash -c "cp .env.dist .env && composer install && php bin/console d:m:m -n && exit"

    printf "\n\n * * * * Starting build for pmanager * * * * \n\n"
    docker exec -it pmanager.http bash -c "bin/console app:seed-data && exit"

    printf "\n\n * * * * Starting build for apropos-customer-site * * * * \n\n"
    docker exec -it website.http bash -c "cp .env.dist .env && composer install && cd client-area && ng analytics off && npm install && npm run build:dev && exit"

    printf "\n\n * * * * Starting build for apropos-postcode-service * * * * \n\n"
    docker exec -it postcode.http bash -c "cp .env.dist .env && composer install && php bin/console d:m:m -n && php bin/console app:seed-all-data && exit"

    printf "\n\n * * * * Starting build for apropos-staff-site * * * * \n\n"
    docker exec -it staff.http bash -c "npm install && ng analytics off && npm run build:test && exit"

    printf "\n\n * * * * Starting build for apropos-portal-service * * * * \n\n"
    docker exec -it portal.http bash -c "cp .env.dist .env && composer install && exit"

    printf "\n\n * * * * Starting build for queueworker-service * * * * \n\n"
    docker exec -it queueworker.http bash -c "cp .env.dist .env && composer install && exit"

    printf "\n\n * * * * Starting build for apropos-sun-service * * * * \n\n"
    docker exec -it sunservice.http ash -c "cp .env.dist .env && exit"
    cp ./docker/local/sunservice/build_local.sh ../apropos-sun-service/

    # printf "\n\n * * * * Starting build for apropos-property-state-service * * * * \n\n"
    # docker exec -it propertystateservice.http ash -c "cp .env.dist .env && exit"
    # cp ./docker/local/propertystateservice/build_local.sh ../apropos-property-state-service/

    printf "\n\n * * * * Build complete * * * * \n\n"

else
  echo "$project_path is invalid directory"
fi
