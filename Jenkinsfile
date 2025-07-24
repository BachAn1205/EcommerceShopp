
pipeline {
    agent any


    environment {
        DOCKER_IMAGE_NAME = 'ecommrce' 
        HOST_PORT = '9000'
        CONTAINER_PORT = '8080'
    }

    stages {
        stage('Checkout Source') {
            steps {
                git branch: 'BachAn', url: 'https://github.com/BachAn1205/EcomerceShop.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build --pull -t ${DOCKER_IMAGE_NAME} ."
                }
            }
        }

        stage('Stop & Remove Old Container') {
            steps {
                script {
                    def containerId = sh(script: "docker ps -aq --filter ancestor=${DOCKER_IMAGE_NAME}", returnStdout: true).trim()

                    if (containerId != "") {
                        echo "Stopping and removing old container: ${containerId}"
                        sh "docker stop ${containerId}"
                        sh "docker rm ${containerId}"
                    } else {
                        echo "No old container found to stop and remove."
                    }
                }
            }
        }

        stage('Run New Container') {
            steps {
                script {
                    sh "docker run -d -p ${HOST_PORT}:${CONTAINER_PORT} --name ${DOCKER_IMAGE_NAME}-container ${DOCKER_IMAGE_NAME}"
                    echo "New container ${DOCKER_IMAGE_NAME}-container started on http://localhost:${HOST_PORT}"
                }
            }
        }
    }

    post {
        always {
            echo "Pipeline finished."
        }
        success {
            echo "Deployment successful!"
        }
        failure {
            echo "Deployment failed!"
        }
    }
}
