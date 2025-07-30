pipeline {
    agent any

    environment {
        CONFIGURATION = 'Release'
        PUBLISH_DIR = 'publish'
        WEBHOOK_URL = 'https://3d190d3926f5.ngrok-free.app/github-webhook/'
    }

    stages {
        stage('Checkout') {
            steps {
                echo '===> Cloning source code from Git...'
                git branch: 'main', url: 'https://github.com/BachAn1205/EcommerceShopp.git'
            }
        }

        stage('Restore') {
            steps {
                echo '===> Restoring NuGet packages...'
                sh 'dotnet restore'
            }
        }

        stage('Build') {
            steps {
                echo '===> Building the project...'
                sh 'dotnet build --configuration $CONFIGURATION'
            }
        }

        stage('Test') {
            steps {
                echo '===> Running unit tests...'
                sh 'dotnet test --no-build --verbosity normal'
            }
        }

        stage('Publish') {
            steps {
                echo '===> Publishing the app...'
                sh 'dotnet publish --configuration $CONFIGURATION --output $PUBLISH_DIR'
            }
        }

        stage('Deploy') {
            steps {
                echo '===> Deploying the app...'
                sh 'mkdir -p /var/www/myapp'
                sh 'cp -r $PUBLISH_DIR/* /var/www/myapp/'
            }
        }
    }

    post {
        success {
            echo '✅ Build and deployment completed successfully.'
            echo '===> Sending webhook notification...'
            script {
                def payload = '{"status":"success","project":"my-dotnet-app","time":"' + new Date().toString() + '"}'
                httpRequest(
                    httpMode: 'POST',
                    url: "${env.WEBHOOK_URL}",
                    contentType: 'APPLICATION_JSON',
                    requestBody: payload,
                    validResponseCodes: '100:499'
                )
            }
        }
        failure {
            echo '❌ Build failed. Please check the logs.'
        }
    }
}
