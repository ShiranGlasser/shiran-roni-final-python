pipeline {

    agent any

    environment {
        DOCKERHUB_TOKEN = credentials('dockerhub_token')
    }

    options {
      ansiColor('xterm')
    }

    stages {
        stage('Clone Git Repository') {
            steps {
                cleanWs()
                checkout scm
            }
        }

        stage('Build') {
            steps {
                sh '''
                docker build -t shiranglasser10/final-python:${BUILD_NUMBER} .
                '''
            }
        }

        stage('Test Flask app is working') {
            steps {
                sh '''
                docker run -p 5000:5000 -d shiranglasser10/final-python:${BUILD_NUMBER}
                res=$(curl -I “http://localhost:5000/api/doc” | awk ‘/^HTTP/{print $2}’)
                if [ $res == '200' ]
                then
                    echo "Good job! Flask app is running.."
                else
                    echo "ERROR - Flask app is not working. Please check the logs"
                    exit 1
                fi
                '''
            }
        }

       stage('Push image to DockerHub') {
            steps {
                sh '''
                docker login -u shiranglasser10 -p ${DOCKERHUB_TOKEN}
                docker push shiranglasser10/final-python:${BUILD_NUMBER}
                '''
            }
        }
    }
}
