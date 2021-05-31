#!/bin/sh
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
	apropos_postcode_service_path="$project_path/apropos-postcode-service"

	sudo chown $USER:$USER ../pmanager2/pgdata*
    sudo chown $USER:$USER ../apropos-sso-service/pgdata*
    sudo chown $USER:$USER ../apropos-worklog-service/pgdata*
    sudo chown $USER:$USER ../apropos-postcode-service/mysql*

    printf "\n\n * * * * Working * * * * \n\n"

    docker-compose up -d pmanager_http pmanager_master_db pmanager_slave_db
    sleep 20
    docker exec -it pmanager.http bash -c "cp .env.dist .env && composer install && php bin/console app:clean-ms-graph-data && exit"
    docker-compose stop pmanager_http pmanager_master_db pmanager_slave_db

    cd $docker_development_path && docker-compose down
    cd $pmanager2_path && sudo rm -rf pgdata*
    cd $apropos_sso_service_path && sudo rm -rf pgdata*
    cd $apropos_worklog_service_path && sudo rm -rf pgdata*
    cd $apropos_postcode_service_path && sudo rm -rf mysql*
    cd $docker_development_path && docker-compose up -d --build

    printf "\n\n * * * * Build complete * * * * \n\n"

    sleep 10

    sudo chown $USER:$USER ../pmanager2/pgdata*
    sudo chown $USER:$USER ../apropos-sso-service/pgdata*
    sudo chown $USER:$USER ../apropos-worklog-service/pgdata*

    docker exec -it worklog.http bash -c "cp .env.dist .env && composer install && php bin/console d:m:m -n && exit"
    docker exec -it pmanager.http bash -c "php bin/console d:m:m -n && exit"
    docker exec -it sso.http bash -c "cp .env.dist .env && composer install && php bin/console d:m:m -n && exit"
    docker exec -it pmanager.http bash -c "php bin/console app:seed-data && exit"
    docker exec -it postcode.http bash -c "php bin/console d:m:m -n && php bin/console app:seed-all-data && exit"
else
	echo "$project_path is invalid directory"
fi
