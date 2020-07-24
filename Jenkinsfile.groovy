pipeline {
    agent any
    stages {
        stage('Deploy') {
            steps {
                sh 'kubectl get namespaces quorum-namespace || kubectl create namespace quorum-namespace'
                sh 'make deploy HELM=/usr/local/bin/helm'
            }
        }
    }
}
