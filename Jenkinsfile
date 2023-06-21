pipeline {
  //agent { label 'jenkins-kbound' } 
  agent { label 'docker' } 
  options {
    buildDiscarder(logRotator(numToKeepStr: '5'))
  }
  environment {
    DOCKERHUB_CREDENTIALS = credentials('Dockerhub-ID')
  }
  stages {
    stage('Check Docker Socket') {
      steps {
        script {
          timeout(time: 5, unit: 'MINUTES') {
            waitUntil {                       
                       def ret = sh script: 'curl --unix-socket /run/user/1000/docker.sock http://%2Fvar%2Frun%2Fdocker.sock/v1.24/info -o /dev/null', returnStatus: true
                       return ret == 0                           
                       }                      
          }
        }
      }
    }
    stage('Build') {
      steps {
        sh 'docker build -t tomjakanam/jen-mavslave:latest .'
      }
    }
    stage('Login') {
      steps {
        sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
      }
    }
    stage('Push') {
      steps {
        sh 'docker push tomjakanam/jen-mavslave:latest'
      }
    }
    stage('ToApp') {
      steps {
        /* Use the syntax below if parametarized (has to match the job to be triggered) */
        script{
          build job: 'BuildAndDeployJob'
          parameter: [
            [ $class: 'StringParameterValue', name: 'MATCH_PARAM', value: "${BUILD_NUMBER}"],
            [ $class: 'BooleanParameterValue', name: 'IS_READY', value: true ]
            // See: https://www.youtube.com/watch?v=V3QgzGQiB7U
            //build job: 'BuildAndDeployJob', parameters: [string(name: 'MATCH_PARAM', value: '$BUILD_NUMBER'), booleanParam(name: 'IS_READY', value: true)]
          ]
        }
      // */
      //  build 'BuildAndDeployJob'
      }
    }
  }
  post {
    always {
      script {
                if (getContext(hudson.FilePath)) {
                    sh 'docker logout'
                }
            }
      
    }
  }
}
