pipeline {
  agent any
  environment {
        VERSION = """${sh(
                returnStdout: true,
                script: 'cat version'
            )}""" 
        REPO_LATEST = """${sh(
                returnStdout: true,
                script: 'REPOSITORY=$(aws ecr describe-repositories --query repositories[0].repositoryUri --region us-west-2 --output text) && Output="${REPOSITORY}:latest" && echo $Output'
            )}"""
        REPO_VERSION = """${sh(
                returnStdout: true,
                script: 'REPOSITORY=$(aws ecr describe-repositories --query repositories[0].repositoryUri --region us-west-2 --output text) && VERSION=$(cat version) && Output="${REPOSITORY}:${VERSION}" && echo $Output'
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
            sh 'sudo docker tag webapp:latest ${REPO_VERSION}'
            sh 'sudo docker push ${REPO_VERSION}'
            sh 'sudo docker tag webapp:latest ${REPO_LATEST}'
            sh 'sudo docker push ${REPO_LATEST}'  
        }
    }
    stage('Update image set for webapp Pods (will initiate a rolling update if VERSION has changed)'){
        steps{
            sh 'kubectl set image deployment testjenkins-webapp webapp=${REPO}:$VERSION'
        }
    }
  }
}
