pipeline {
  agent any
  environment {
        // Using returnStdout
        CC = """${sh(
                returnStdout: true,
                script: 'echo "clang"'
            )}""" 
        // Using returnStatus
        EXIT_STATUS = """${sh(
                returnStatus: true,
                script: 'exit 1'
            )}"""
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
            sh 'echo $CC'
            sh 'sudo docker build ./TestJenkins -t webapp:latest' 
            sh 'sudo $(aws ecr get-login --no-include-email --region us-west-2)'
            sh 'sudo docker tag webapp:latest 235447109042.dkr.ecr.us-west-2.amazonaws.com/generic-repository:${VERSION}'
            sh 'sudo docker push 235447109042.dkr.ecr.us-west-2.amazonaws.com/generic-repository:${VERSION}'
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
