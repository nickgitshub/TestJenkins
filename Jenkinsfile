pipeline {
  agent any
  environment {
        VERSION = """${sh(
                returnStdout: true,
                script: 'cat version'
            )}""" 
        REPO = """${sh(
                returnStdout: true,
                script: 'aws ecr describe-repositories --query repositories[0].repositoryUri --output text --region us-west-2'
            )}"""
  }
  stages {
    stage('Pull and Lint Index.html and Dockerfile'){
        steps{
                sh 'hadolint Dockerfile'
                sh 'tidy index.html'
        }
    }
    stage('Build Docker Container and commit to ECR') {
        steps {
            sh 'sudo docker build . -t webapp:latest' 
            sh 'sudo $(aws ecr get-login --no-include-email --region us-west-2)'
            sh 'sudo docker tag webapp:latest ${REPO}:${VERSION}'
            sh 'sudo docker push ${REPO}:${VERSION}'
            sh 'sudo docker tag webapp:latest ${REPO}:latest'
            sh 'sudo docker push ${REPO}:latest'  
        }
    }
    stage('Update image set for webapp Pods (will initiate a rolling update if VERSION has changed)'){
        steps{
            sh 'kubectl set image deployment testjenkins-webapp webapp=${REPO}:$VERSION'
        }
    }
  }
}
