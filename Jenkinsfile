pipeline {
    agent any

    stages {
        stage('Restore') {
            steps {
                bat 'dotnet restore' // Nếu Jenkins chạy trên Windows
            }
        }

        stage('Build') {
            steps {
                bat 'dotnet build --configuration Release'
            }
        }

        stage('Test') {
            steps {
                bat 'dotnet test'
            }
        }

        stage('Publish') {
            steps {
                bat 'dotnet publish -c Release -o publish_output'
            }
        }
    }
}