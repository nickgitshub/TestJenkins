pipeline {
  agent any

  environment {
    VERSION = "0.0.0"
    LATESTIMAGE = "235447109042.dkr.ecr.us-west-2.amazonaws.com/generic-repository:latest"
  }

  }
  stages {
    stage('Pull and Lint Index.html and Dockerfile'){
        steps{
            sh 'git clone https://github.com/nickgitshub/TestJenkins' 
            dir('TestJenkins'){
                sh 'hadolint Dockerfile'
                sh 'tidy index.html'
            }
        }
    }
    stage('Build Docker Container and commit to ECR') {
        steps {
            sh 'sudo docker build ./TestJenkins -t webapp:latest' 
            sh 'sudo $(aws ecr get-login --no-include-email --region us-west-2)'
            sh 'VERSION=$(cat version)'
            sh 'LATESTIMAGE=$(echo 235447109042.dkr.ecr.us-west-2.amazonaws.com/generic-repository:${VERSION})'
            sh 'echo ${LATESTIMAGE}'
            sh 'sudo docker tag webapp:latest ${LATESTIMAGE}'
            sh 'sudo docker push ${LATESTIMAGE}'
            sh 'sudo docker tag webapp:latest 235447109042.dkr.ecr.us-west-2.amazonaws.com/generic-repository:latest'
            sh 'sudo docker push 235447109042.dkr.ecr.us-west-2.amazonaws.com/generic-repository:latest'  
        }
    }
    stage('Delete old Kubernetes Pods and deploy new ones'){
        steps{
          dir('TestJenkins'){
                sh 'kubectl apply -f webapp.yaml'
                sh 'kubectl apply -f webapp.service.yaml'
                sh 'kubectl set image deployment testjenkins-webapp webapp=235447109042.dkr.ecr.us-west-2.amazonaws.com/generic-repository:$VERSION'
            }
        }
    }
    stage('Clean up directory'){
        steps{
          sh'rm -rf TestJenkins'
        }
    }
  }
}
