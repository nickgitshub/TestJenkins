pipeline {
  agent any
  stages {
    stage('Lint Index.html and Dockerfile'){
        // hadolint can be used for the Dockerfile
        steps{
            sh 'sudo git clone https://github.com/nickgitshub/TestJenkins && cd TestJenkins'
            sh 'tidy index.html'
            sh'hadolint Dockerfile' 
        }
    stage('Build Docker Container and commit to ECR') {
        steps {
          sh 'sudo docker build /home/ubuntu/TestJenkins/ -t webapp:latest' 
          sh 'sudo $(aws ecr get-login --no-include-email --region us-west-2)'
          sh 'sudo docker tag webapp:latest 235447109042.dkr.ecr.us-west-2.amazonaws.com/generic-repository:latest'
          sh 'sudo docker push 235447109042.dkr.ecr.us-west-2.amazonaws.com/generic-repository:latest'
        }
      }

    stage('Deploy Container in EKS'){
        steps{
          sh'kubectl apply -f webapp.yaml'
          sh'kubectl apply -f webapp.service.yaml'
        }
      }
    stage('Clean up directory'){
        steps{
          sh'sudo rm -rf TestJenkins'
        }
      }
    }
  }
