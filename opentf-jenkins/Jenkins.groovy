pipeline {
    agent any

    stages {
        stage('Check Tofu version') {
            steps {
                sh 'tofu -v'
            }
        }
        stage('Check out configuration repo') {
            steps{
                git branch: 'main', credentialsId: 'S8-JenkinsID', url: 'git@github.com:TheRealGLH/S8-CICD-protos.git'
            }
        }
        stage('Start Tofu') {
            steps {
                dir('opentf-jenkins/hello-world-docker') {
                    sh 'tofu destroy -auto-approve'
                    sh 'tofu init'
                    sh 'tofu apply -auto-approve'
                }
            }
        }
    }
    post {
      always {
          dir('opentf-jenkins/hello-world-docker') {
              sh 'tofu destroy -auto-approve'
          }
      }
    }
}

