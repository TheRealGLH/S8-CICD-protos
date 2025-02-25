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
                git branch: 'master', credentialsId: 'S8-JenkinsID', url: 'ssh://git@bitbucket.local:23/s8/cpp-template.git'
            }
        }
        stage('Start Tofu') {
            steps {
                sh 'ls -la'
                dir('terraform') {
                    //sh 'tofu destroy -auto-approve'
                    sh 'tofu init'
                    sh 'tofu apply -auto-approve'
                }
            }
        }
        stage('Test') {
            steps {
                echo 'Running tests...'
                sleep 60
                echo 'All done!'
            }
        }
        stage('Save artifacts') {
            steps {
                archiveArtifacts allowEmptyArchive: true, artifacts: '**/*.exe', followSymlinks: false, onlyIfSuccessful: true
            }
        }
    }
    post {
      always {
            dir('terraform') {
                sh 'tofu destroy -auto-approve'
            }
            cleanWs()
      }
    }
}

