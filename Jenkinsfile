pipeline {
    agent any

    environment {
        DOCKER_HUB_USER = "atharvab3"
        IMAGE_NAME = "myapp"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/develop']],
                          userRemoteConfigs: [[url: 'https://github.com/<your-repo>.git']]])
            }
        }

        stage('Build & Dockerize') {
            steps {
                sh 'chmod +x scripts/build_and_push.sh'
                sh './scripts/build_and_push.sh'
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('infra') {
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Deploy with Ansible') {
            steps {
                sh 'ansible-playbook -i ansible/hosts.ini ansible/deploy.yml'
            }
        }
    }
}
