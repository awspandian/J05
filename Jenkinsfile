pipeline {
    agent any
    
     parameters { choice(name: 'BRANCH_TO_BUILD', choices: ['j16', 'p1', 'p2'], description: 'choose the required branch') }

    triggers { pollSCM('H/05 * * * *') }
    
    stages {
        stage('SCM') {
            steps {
                git branch: "${params.BRANCH_TO_BUILD}", url: 'https://github.com/awspandian/J05.git'
            }
        }
		stage('BUILD') {
            steps {
               sh 'mvn clean'
			   sh 'mvn install'
            }
        }
		stage('Deploy') {
            steps {
				deploy adapters: [tomcat9(credentialsId: 'web', path: '', url: 'http://localhost:9090/')], contextPath: 'pip-j16', war: '**/*.war'
            }
        }
    }
}

