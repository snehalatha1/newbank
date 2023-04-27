pipeline {
  agent any
  tools {
      maven 'M2_HOME'
      terraform 'T2_HOME'
        }
   environment {
       DOCKERHUB_CREDENTIALS = credentials('dockerhub')
   }      
  stages {
     stage('checkout'){
       steps {
          git branch: 'main', url: 'https://github.com/snehalatha1/newbank.git'
       }
     }
     stage('Package'){
       steps {
            sh 'mvn clean package'
        }    
     }  
     stage('publish Reports'){
               steps {
               publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: '/var/lib/jenkins/workspace/banking/target/surefire-reports', reportFiles: 'index.html', reportName: 'HTML Report', reportTitles: '', useWrapperFileDirectly: true])    
                }
      }
      stage('Docker Image Creation'){
          steps {
                 sh 'docker build -t snehalatha15/bank:latest  .'
           }
       }
     stage('login'){
         steps {
           sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
         }
     }
     stage('push'){
         steps{
             sh 'docker push snehalatha15/bank:latest'
         }
     }
    stage ('Configure Test-server with Terraform, Ansible and then Deploying'){
            steps {
                dir('test'){
                sh 'sudo chmod 777 ./mykey.pem'
                sh 'terraform init'
                sh 'terraform validate'
                sh 'terraform apply --auto-approve'
                }
            }
    }
        }
   }
