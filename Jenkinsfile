pipeline {

    agent {
        label 'docker-agent'
    }

    environment {
        IMAGE_NAME = 'purushothdoc/prt-cicd'
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    docker build \
                    -t ${IMAGE_NAME}:${BUILD_NUMBER} \
                    -t ${IMAGE_NAME}:latest \
                    ./app
                '''
            }
        }

        stage('Test Image') {
            steps {
                sh '''
                    docker run -d --name prt-test -p 8081:80 ${IMAGE_NAME}:${BUILD_NUMBER}
                    sleep 5
                    curl -f http://localhost:8081
                    docker rm -f prt-test
                '''
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub-credentials',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )
                ]) {

                    sh '''
                        echo "$DOCKER_PASS" | docker login \
                        -u "$DOCKER_USER" \
                        --password-stdin

                        docker push ${IMAGE_NAME}:${BUILD_NUMBER}
                        docker push ${IMAGE_NAME}:latest

                        docker logout
                    '''
                }
            }
        }
    }

    post {
        success {
            echo 'PRT – CI/CD Completed Successfully'
        }

        failure {
            echo 'PRT – CI/CD Failed'
        }
    }
}
