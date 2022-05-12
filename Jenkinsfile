pipeline {
    environment { 
        registry = "project.nexus.com:8090/project" 
        registryCredential = 'docker-hub' 
        dockerImage = '' 
    }
    agent any

    stages {
        
        
        stage('Maven Build') {
            steps {
              sh "mvn clean package"
               
            }
        }
        
        stage('Build Image') {
            steps {
                echo 'Building Docker Image'
                script {
                    dockerImage = docker.build registry + ":$BUILD_NUMBER"
                }
            }
        }
        
        stage('Pushing Image to Docker-Hub') {
            steps {
                echo 'Pushing Docker Image'
                script {
                   docker.withRegistry( 'http://project.nexus.com:8090', registryCredential ) {
                   dockerImage.push("$BUILD_NUMBER")
                   dockerImage.push('latest')
                  }
                }
            }
        }
        
        stage('Clean Up') {
            steps {
                sh "docker rmi $registry:$BUILD_NUMBER"
                sh "docker rmi $registry:latest"
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
                sh "kubectl apply -f deployment.yaml"
                sh "kubectl apply -f service.yaml"
                sh "kubectl rollout restart deployment.apps/calc-deployment"
            }
        }
    }
}

