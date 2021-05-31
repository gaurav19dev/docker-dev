#!/bin/sh
echo "Are you executing this script from docker-development? (y - YES, n - NO): \c"
read IS_DIR_DOCKER_DEV

if [ "$IS_DIR_DOCKER_DEV" = 'y' ]
then
  PROJECT_PATH="../"
else
  echo "Enter path of your project without quotes: \c"
  read PROJECT_PATH
fi

if [ -d "$PROJECT_PATH" ]
then
	CURRENT_DATE_TIME=`date +'%m.%d.%Y.%s'`
	DOCKER_DEVELOPMENT_PATH="$PROJECT_PATH/docker-development"
	PMANAGER2_PATH="$PROJECT_PATH/pmanager2"
	SSOSERVER_PATH="$PROJECT_PATH/apropos-sso-service"
	CUSTOMER_SITE_PATH="$PROJECT_PATH/apropos-customer-site"
	WORK_LOG_PATH="$PROJECT_PATH/apropos-worklog-service"
	POSTCODE_PATH="$PROJECT_PATH/apropos-postcode-service"
	STAFF_SITE_PATH="$PROJECT_PATH/apropos-staff-site"
	PORTAL_PATH="$PROJECT_PATH/apropos-portal-service"
	SUN_SERVICE_PATH="$PROJECT_PATH/apropos-sun-service"
	QUEUEWORKER_SERVICE_PATH="$PROJECT_PATH/apropos-queues-worker"
	PROPERTY_STATE_SERVICE_PATH="$PROJECT_PATH/apropos-property-state-service"

	echo "Enter branch name to take pull from all 10 repositories: \c"
	read BRANCH_NAME

	STASH_NAME="$CURRENT_DATE_TIME $BRANCH_NAME"
	GIT_FETCH="git fetch origin"
	GIT_STASH="git stash save \"$STASH_NAME\""
	GIT_CHECKOUT_BRANCH="git checkout $BRANCH_NAME"
	GIT_PULL="git pull origin $BRANCH_NAME"

	printf "\n\n * * * * Working on pmanager2 * * * * \n\n"

	cd $PMANAGER2_PATH && $GIT_FETCH && $GIT_STASH && $GIT_CHECKOUT_BRANCH && $GIT_PULL

	printf "\n\n * * * * Working on apropos-sso-service * * * * \n\n"

	cd $SSOSERVER_PATH && $GIT_FETCH && $GIT_STASH && $GIT_CHECKOUT_BRANCH && $GIT_PULL

	printf "\n\n * * * * Working on apropos-customer-site * * * * \n\n"

	cd $CUSTOMER_SITE_PATH && $GIT_FETCH && $GIT_STASH && $GIT_CHECKOUT_BRANCH && $GIT_PULL

	printf "\n\n * * * * Working on apropos-worklog-service * * * * \n\n"

	cd $WORK_LOG_PATH && $GIT_FETCH && $GIT_STASH && $GIT_CHECKOUT_BRANCH && $GIT_PULL

	printf "\n\n * * * * Working on apropos-postcode-service * * * * \n\n"

	cd $POSTCODE_PATH && $GIT_FETCH && $GIT_STASH && $GIT_CHECKOUT_BRANCH && $GIT_PULL

	printf "\n\n * * * * Working on apropos-staff-site * * * * \n\n"

	cd $STAFF_SITE_PATH && $GIT_FETCH && $GIT_STASH && $GIT_CHECKOUT_BRANCH && $GIT_PULL

	printf "\n\n * * * * Working on apropos-portal-service * * * * \n\n"

	cd $PORTAL_PATH && $GIT_FETCH && $GIT_STASH && $GIT_CHECKOUT_BRANCH && $GIT_PULL

	printf "\n\n * * * * Working on apropos-sun-service * * * * \n\n"

	cd $SUN_SERVICE_PATH && $GIT_FETCH && $GIT_STASH && $GIT_CHECKOUT_BRANCH && $GIT_PULL

	printf "\n\n * * * * Working on apropos-queues-worker * * * * \n\n"

	cd $QUEUEWORKER_SERVICE_PATH && $GIT_FETCH && $GIT_STASH && $GIT_CHECKOUT_BRANCH && $GIT_PULL

	printf "\n\n * * * * Working on apropos-property-state-service * * * * \n\n"

	cd $PROPERTY_STATE_SERVICE_PATH && $GIT_FETCH && $GIT_STASH && $GIT_CHECKOUT_BRANCH && $GIT_PULL

	printf "\n\n * * * * Finish * * * * \n\n"
else
	echo "$PROJECT_PATH is invalid directory"
fi
