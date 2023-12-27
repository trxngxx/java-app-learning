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
                    customWorkspace "/home/seta/java/"
                }
            }
            environment {
                TAG = sh(returnStdout: true, script: "git rev-parse -short=10 HEAD | tail -n +2").trim()
            }
            steps {
                script {
                    // Xây dựng Docker image
                    sh "docker build . -t devops-training-java-$ENV:latest --build-arg BUILD_ENV=$ENV -f Dockerfile"

                    sh "cat docker.txt | docker login -u 29trxngxx --password-stdin"

                    // Đẩy Docker image lên Docker Hub
                    sh "docker tag devops-training-java-$ENV:latest 29trxngxx/devops-training:$TAG"

                    sh "docker push 29trxngxx/devops-training:$TAG"

                    sh "docker rmi -f 29trxngxx/devops-training:$TAG"
                }
            }
        }

        stage("Deploy") {
            agent {
                node {
                    label "Target-Server"
                    customWorkspace "/home/ubuntu/java-app-$ENV/"
                }
            }
            environment {
                TAG = sh(returnStdout: true, script: "git rev-parse -short=10 HEAD | tail -n +2").trim()
            }
            steps {
                script {
                    sh "sed -i 's/{tag}/$TAG/g' /home/ubuntu/java-app-$ENV/docker-compose.yaml"
                    sh "docker-compose up -d"
                }
            }
        }
    }
}
