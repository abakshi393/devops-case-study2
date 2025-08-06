pipeline {
    agent any

    environment {
        AWS_REGION = 'ap-south-1'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'develop', 
                    url: 'https://github.com/abakshi393/devops-case-study2.git'
                script {
                    // Store Git commit hash
                    env.GIT_COMMIT = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
                }
            }
        }

        stage('Terraform Init & Apply') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-creds',
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                ]]) {
                    dir('infra') {
                        sh '''
                            terraform init -input=false
                            terraform validate
                            terraform apply -auto-approve -input=false
                        '''
                    }
                }
            }
        }

        stage('Build and Push Docker Image') {
            steps {
                script {
                    sh 'docker buildx install || true'
                    withCredentials([
                        usernamePassword(
                            credentialsId: '4bba3617-ac23-48a1-8d12-c496f75496fc',
                            usernameVariable: 'DOCKERHUB_USER',
                            passwordVariable: 'DOCKERHUB_PASS'
                        )
                    ]) {
                        sh '''
                            echo "$DOCKERHUB_PASS" | docker login -u "$DOCKERHUB_USER" --password-stdin
                            chmod +x scripts/build_and_push.sh
                            ./scripts/build_and_push.sh ${GIT_COMMIT}
                        '''
                    }
                }
            }
        }

        stage('Prepare Ansible') {
            steps {
                script {
                    // Get EC2 public IP from Terraform output (matches your Terraform output name)
                    env.EC2_IP = sh(
                        script: "cd infra && terraform output -raw instance_public_ip", 
                        returnStdout: true
                    ).trim()

                    // Create ansible inventory file
                    sh 'mkdir -p ansible'
                    writeFile file: 'ansible/hosts.ini', text: """
[ec2]
${env.EC2_IP} ansible_user=ubuntu ansible_ssh_private_key_file=$SSH_KEY_PATH

[ec2:vars]
ansible_python_interpreter=/usr/bin/python3
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
"""
                    sh 'cat ansible/hosts.ini'
                }
            }
        }

        stage('Run Ansible Playbook') {
            steps {
                withCredentials([
                    sshUserPrivateKey(
                        credentialsId: 'ansible',
                        keyFileVariable: 'SSH_KEY_PATH'
                    )
                ]) {
                    script {
                        try {
                            sh """
                                mkdir -p ~/.ssh
                                chmod 600 $SSH_KEY_PATH
                                ssh-keyscan -H ${env.EC2_IP} >> ~/.ssh/known_hosts
                                ansible-playbook -i ansible/hosts.ini ansible/deploy.yml \
                                    --private-key=$SSH_KEY_PATH \
                                    -u ubuntu \
                                    -e "GIT_COMMIT=${env.GIT_COMMIT}"
                            """
                        } catch (Exception e) {
                            error "❌ Ansible deployment failed: ${e.getMessage()}"
                        }
                    }
                }
            }
        }
    }

    post {
        always {
            echo "Pipeline execution completed."
        }
        failure {
            echo "❌ Pipeline failed. Check logs for details."
        }
        success {
            echo "✅ Deployment completed successfully!"
        }
    }
}
