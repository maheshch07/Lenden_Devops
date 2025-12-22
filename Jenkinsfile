pipeline {
    agent any

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/maheshch07/Lenden_Devops.git'
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t devops-app ./app'
            }
        }

        stage('Security Scan - Trivy') {
            steps {
                sh '''
                trivy image devops-app || true
                '''
            }
        }

        stage('Terraform Init') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Security Scan') {
            steps {
                dir('terraform') {
                    sh '''
                    trivy config . || true
                    '''
                }
            }
        }
    }
}