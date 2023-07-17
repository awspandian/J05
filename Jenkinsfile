pipeline {
    agent any
	parameters { choice(name: 'BUILD_TOBRANCH', choices: ['j17', 'j16', 'p1' ,'p2'], description: 'choose the branch to build') }

    triggers { pollSCM('H/05 * * * *') }

    stages {
        stage('SCM') {
            steps {
                git branch: "${params.BUILD_TOBRANCH}", url: 'https://github.com/awspandian/J05.git'
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
           deploy adapters: [tomcat9(credentialsId: 'web', path: '', url: 'http://localhost:9090/')], contextPath: 'j17-pipeline', war: '**/*.war'
            }
        }
    }
}
