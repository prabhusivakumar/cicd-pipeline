def COLOR_MAP = [
    'SUCCESS': 'good', 
    'FAILURE': 'danger',
]
pipeline {
    agent any

    stages{

        stage('Fetch code') {
          steps{
              git branch: 'main', url:'https://github.com/prabhusivakumar/cicd-pipeline.git'
          }  
        }

        stage('Build') {
            steps {
                sh 'zip -r webapp.war *'
            }
            post {
                success {
                    echo "Successfully prepared artifact."
                }
            }
        }

        stage("UploadArtifact"){
	    steps {
            	sshagent(['ubuntu']) {
       			sh "scp -o  StrictHostKeyChecking=no target /webapp.war ubuntu@3.89.111.121:/usr/local/tomcat/webapps/ROOT.war"
			}
            }
	}
    }

    post {
        always {
            echo 'Slack Notifications.'
            slackSend channel: '#jenkinscicd',
                color: COLOR_MAP[currentBuild.currentResult],
                message: "*${currentBuild.currentResult}:* Job: ${env.JOB_NAME} Build: ${env.BUILD_NUMBER} \n Build Details: ${env.BUILD_URL}"
        }
    }
    
}