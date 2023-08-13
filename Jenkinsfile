def COLOR_MAP = [
    'SUCCESS': 'good', 
    'FAILURE': 'danger',
]
pipeline {
    agent any

    environment {
        registry = "prabhusiva619/cicd-pipeline"
        registryCredential = 'dockerhub'
    }

    stages{

        stage('Build Artifact') {
            steps {
                sh 'zip -r webapp.war *'
            }
            post {
                success {
                    echo 'Archiving artifacts'
                    archiveArtifacts artifacts: '**/*.war'
                }
            }
        }

        stage('Build Docker Image') {
          steps {
            script {
              dockerImage = docker.build registry + ":V$BUILD_NUMBER"
            }
          }
        }

        stage('Push Docker Image'){
          steps{
            script {
              docker.withRegistry('', registryCredential) {
                dockerImage.push("V$BUILD_NUMBER")
                dockerImage.push('latest')
              }
            }
          }
        }

        stage('Remove unused docker image') {
          steps{
            sh "docker rmi $registry:V$BUILD_NUMBER"
          }
        }

        stage('Deploy to Kubernetes') {
          agent {label 'K8S'}
            steps {
              sh "helm upgrade --install --force cicd-stack helm/cicdcharts --set appimage=${registry}:V${BUILD_NUMBER} --namespace dev"
            }
        }
    }

    post {
        always {
            echo 'Slack Notifications'
            slackSend channel: '#jenkinscicd',
                color: COLOR_MAP[currentBuild.currentResult],
                message: "*${currentBuild.currentResult}:* Job: ${env.JOB_NAME} Build: ${env.BUILD_NUMBER} \n Build Details: ${env.BUILD_URL}"
        }
    }
    
}