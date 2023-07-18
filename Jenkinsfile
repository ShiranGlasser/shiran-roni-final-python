pipeline {

    agent any

    environment {
        DOCKERHUB_TOKEN = credentials('dockerhub_token')
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

        stage('Test Flask app is up & running') {
            steps {
                sh '''
                CONTAINER_NAME="finalpython"
                docker run -p 5000:5000 -d --name $CONTAINER_NAME shiranglasser10/final-python:${BUILD_NUMBER}
                sleep 5
                CONTAINER_STATUS=$(docker container inspect -f '{{.State.Status}}' $CONTAINER_NAME)
                if [ $CONTAINER_STATUS = "running" ]
                then
                    echo "final python container is running!"
                    echo "Checking application is up..."
                    res=$(curl -I "http://localhost:5000/api/doc" | awk '/^HTTP/{print $2}')
                    if [ $res == '200' ]
                    then
                        echo "Good job! Flask app is running.."
                    else
                        echo "ERROR - Flask app is not working. Please check the logs"
                        exit 1
                    fi
                else
                    echo "ERROR - container state is: " $CONTAINER_STATUS
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
