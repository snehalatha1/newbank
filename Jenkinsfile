pipeline {
  agent any

  tools {
      maven 'M2_HOME'
      terraform 'TERRAFORM_HOME'
        }
environment {
        AWS_ACCESS_KEY = '${ACCESS_KEY}'
        AWS_SECRET_KEY = '${SECRET_KEY}'
        }


  stages {
     stage('checkout'){
       steps {
          git branch: 'main', url: 'https://github.com/snehalatha1/bankdomain.git'
       }
     }
   

     stage('Package'){
        steps {
            
            sh 'mvn clean package'
        }    
     }  
     stage('publish Reports'){
               steps {
               publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: '/var/lib/jenkins/workspace/project2/target/surefire-reports', reportFiles: 'index.html', reportName: 'HTML Report', reportTitles: '', useWrapperFileDirectly: true])    
                    }
            }

     stage('Docker Image Creation'){
          steps {
                 sh 'docker build -t snehalatha15/bankingapp:latest  .'
                      }
                   }


      stage('Push Image to DockerHub'){
               steps {
                   withCredentials([usernamePassword(credentialsId: 'dh', passwordVariable: 'dhpswd', usernameVariable: 'dhuser')]) {
        	   sh "docker login -u ${env.dhuser} -p ${env.dhpswd}"
                   sh 'docker push snehalatha15/bankingapp:latest'

	            }
                 }
            }
	     
     stage ('Configure Test-server with Terraform, Ansible and then Deploying'){
            steps {
                dir('test'){
                sh 'sudo chmod 600 ./newkeypair.pem'
                sh 'terraform init'
                sh 'terraform validate'
                sh 'terraform apply --auto-approve'
                }
                }
            }
        }
   }

