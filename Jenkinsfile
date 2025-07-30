pipeline {
    agent any

    environment {
        CONFIGURATION = 'Release'
        PUBLISH_DIR = 'publish'
        WEBHOOK_URL = 'https://3d190d3926f5.ngrok-free.app/github-webhook/' // Thay bằng URL thật
    }

    stages {
        stage('Checkout') {
            steps {
                echo '===> Cloning source code from Git...'
                git 'https://github.com/BachAn1205/EcommerceShopp.git'
            }
        }

        stage('Restore') {
            steps {
                echo '===> Restoring NuGet packages...'
                bat 'dotnet restore'
            }
        }

        stage('Build') {
            steps {
                echo '===> Building the project...'
                bat "dotnet build --configuration %CONFIGURATION%"
            }
        }

        stage('Test') {
            steps {
                echo '===> Running unit tests...'
                bat "dotnet test --no-build --verbosity normal"
            }
        }

        stage('Publish') {
            steps {
                echo '===> Publishing the app...'
                bat "dotnet publish --configuration %CONFIGURATION% --output %PUBLISH_DIR%"
            }
        }

        stage('Deploy') {
            steps {
                echo '===> Deploying the app...'
                bat "xcopy /E /Y %PUBLISH_DIR% C:\\deploy\\myapp\\"
            }
        }
    }

    post {
        success {
            echo '✅ Build and deployment completed successfully.'
            echo '===> Sending webhook notification...'
            script {
                def payload = '{"status":"success","project":"my-dotnet-app","time":"' + new Date().toString() + '"}'
                httpRequest httpMode: 'POST',
                            url: "${env.WEBHOOK_URL}",
                            requestBody: payload,
                            contentType: 'APPLICATION_JSON'
            }
        }
        failure {
            echo '❌ Build failed. Please check the logs.'
        }
    }
}
