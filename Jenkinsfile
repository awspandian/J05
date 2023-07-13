pipeline {
    agent any

    stages {
        stage('SCM') {
            steps {
                git branch: 'p1', url: 'https://github.com/awspandian/J05.git'
            }
        }
		stage('Maven Build') {
            steps {
                sh 'mvn clean'
				sh 'mvn install'
            }
        }
		stage ('Docker Image Build'){
		    steps {
                script {
                    app = docker.build("dockerpandian/jly")
                    app.inside {
                        sh 'echo $(curl localhost:8080)'
                    }
                }
            }
        }
         stage('Push Docker Image') {

            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'docker') {
                        app.push("${env.BUILD_NUMBER}")
                        app.push("latest")
                    }
                }
            }
        }
        		stage('DeployToProduction') {

            steps {
                input 'Deploy to Production?'
                milestone(1)
                withCredentials([usernamePassword(credentialsId: 'web', usernameVariable: 'USERNAME', passwordVariable: 'USERPASS')]) {
                    script {
                        sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@$prod_ip \"docker pull dockerpandian/jly:${env.BUILD_NUMBER}\""
                        try {
                            sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@$prod_ip \"docker stop azcs\""
                            sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@$prod_ip \"docker rm azcs\""
                        } catch (err) {
                            echo: 'caught error: $err'
                        }
                        sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@$prod_ip \"docker run --restart always --name azcs -p 8080:8080 -d dockerpandian/jly:${env.BUILD_NUMBER}\""
                    }
                }
            }
        }
		}
		
    }
