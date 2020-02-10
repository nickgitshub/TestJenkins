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
         

        }
      }
    stage('Clean up directory'){
        steps{
          sh'sudo rm -rf TestJenkins'
        }
      }
    }
  }

  //Script that needs to run on the Jenkins host to install Kubernetes, IAM Authenticator, AWS CLI, and Hadolint
          sudo curl -o kubectl https://amazon-eks.s3-us-west-2.amazonaws.com/1.13.7/2019-06-11/bin/linux/amd64/kubectl
          sudo chmod +x ./kubectl
          sudo cp ./kubectl /usr/local/bin
          sudo export PATH=/usr/local/bin:$PATH
          
          sudo curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.13.7/2019-06-11/bin/linux/amd64/aws-iam-authenticator
          sudo chmod +x ./aws-iam-authenticator
          sudo cp ./aws-iam-authenticator /usr/local/bin
          sudo export PATH=/usr/local/bin:$PATH 
          
          curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
          sudo apt-get install unzip
          unzip awscli-bundle.zip
          sudo apt-get install -y python
          sudo ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws
          
          sudo apt  install -y  tidy
          sudo wget -O /bin/hadolint https://github.com/hadolint/hadolint/releases/download/v1.16.3/hadolint-Linux-x86_64
          sudo chmod +x /bin/hadolint
          
          EKS_CLUSTER_NAME=$(aws eks list-clusters --region us-west-2 --query clusters[0] --output text)
          /usr/local/bin/aws eks update-kubeconfig --name $EKS_CLUSTER_NAME --region us-west-2 
          



//Cloudformation script for grabbing AWS ARN name for ECR repo
(aws cloudformation describe-stacks --stack-name GenericECRandEKS --query Stacks[0].Outputs[0].OutputValue --output text)

//Assume role script
aws sts assume-role --role-arn "" --role-session-name AWSCLI-Session


//
