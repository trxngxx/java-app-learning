pipeline {
    agent none

    environment {
        ENV = "dev"
        NODE = "Build-server"
        //DOCKERHUB_CREDENTIALS = 'your-dockerhub-credentials-id' // Thay bằng ID của Jenkins Credentials cho Docker Hub
    }

    stages {
        stage('Build and Push Docker Image') {
            agent {
                node {
                    label "Build-server"
                    customWorkspace "/home/seta/jenkins/"
                }
            }
            environment {
                TAG = sh(returnStdout: true, script: "git rev-parse -short=10 HEAD | tail -n +2").trim()
            }
            steps {
                script {
                    // Xây dựng Docker image
                    docker.build('29trxngxx/my-java-app:latest', '-f Dockerfile .')
                    
                    sh "cat docker.txt | docker login -u 29trxngxx --password-stdin"

                    // Đẩy Docker image lên Docker Hub
                    docker.withRegistry('https://registry.hub.docker.com', DOCKERHUB_CREDENTIALS) {
                        docker.image('29trxngxx/my-java-app:latest').push()
                    }
                }
            }
        }

        stage("Deploy") {
            agent {
                node {
                    label "Target-Server"
                    customWorkspace "/home/ubuntu/jenkins-$ENV/"
                }
            }
            environment {
                TAG = sh(returnStdout: true, script: "git rev-parse -short=10 HEAD | tail -n +2").trim()
            }
            steps {
                script {
                    // Thực hiện các bước triển khai ứng dụng Java
                    sh "sed -i 's/{tag}/$TAG/g' /home/ubuntu/jenkins-$ENV/docker-compose.yaml"
                    sh "docker-compose up -d"
                }
            }
        }
    }
}
