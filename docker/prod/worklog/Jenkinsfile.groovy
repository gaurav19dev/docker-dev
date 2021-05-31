pipeline {
    agent any
    parameters {
        string(name: 'BUILD_PATH', defaultValue: 'prod/worklog', description: 'path from which images need to be built')
        string(name: 'IMAGE_NAME', defaultValue: 'apropos-worklog-prod', description: 'Image name to publish')
        string(name: 'BRANCH_NAME', defaultValue: 'test', description: 'Branch to build')
    }
    stages {
      stage('Checkout') {
          steps {
            checkout([$class: 'GitSCM', branches: [[name: "*/${params.BRANCH_NAME}"]], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'djajenkins', url: 'https://djajenkins@bitbucket.org/djalexander/docker-development.git']]])
          }
      }
      stage ('Docker build and push') {
          steps {
            script {
              docker.withRegistry("https://${env.DOCKER_REGISTRY}", 'ecr:eu-west-1:f486be3b-4af4-4514-b9eb-0f639c4aecbb') {
                sh "cd ${WORKSPACE}/docker/${params.BUILD_PATH}/"
                sh "echo '${params.IMAGE_NAME}: ${env.BUILD_ID}' >> .build-details"
                def customImage = docker.build("${env.DOCKER_REGISTRY}/${params.IMAGE_NAME}:${env.BUILD_ID}","${WORKSPACE}/docker/${params.BUILD_PATH}/")
                sh "docker tag ${env.DOCKER_REGISTRY}/${params.IMAGE_NAME}:${env.BUILD_ID} ${env.DOCKER_REGISTRY}/${params.IMAGE_NAME}:latest"
                customImage.push("${env.BUILD_ID}")
                customImage.push('latest')
              }
            }
          }
      }
    }
}

