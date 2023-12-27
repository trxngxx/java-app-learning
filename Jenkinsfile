pipeline {
    agent any

    environment {
        JAVA_HOME = '/usr/lib/jvm/java-17-openjdk-amd64'
        DOCKERHUB_CREDENTIALS = '29trxngxx'
    }

    stages {
        stage('Build') {
            steps {
                script {
                    def mvnHome = tool 'Maven' // 'Maven' là tên của Maven Installation trong Jenkins

                    withMaven(
                        maven: mvnHome,
                        mavenSettingsConfig: 'my-maven-settings', // 'my-maven-settings' là ID của Maven Settings trong Jenkins
                        mavenLocalRepo: '.m2/repository'
                    ) {
                        sh 'mvn clean install'
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    docker.build('your-dockerhub-username/my-java-app:latest', '-f Dockerfile .')

                    // You may push the Docker image to a registry here
                    // docker.withRegistry('https://registry.example.com', 'registry-credentials') {
                    //     docker.image('my-java-app:latest').push()
                    // }
                    docker.withRegistry('https://registry.hub.docker.com', DOCKERHUB_CREDENTIALS) {
                        docker.image('29trxngxx/my-java-app:latest').push()
                    }
                }
            }
        }
    }
}
