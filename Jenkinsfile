pipeline {
  agent any
  stages {
    stage('Init') {
      steps {
	script {
	  env.BUILD_TYPE = input message: 'Set parameters:', parameters: [choice(name: 'BUILD_TYPE', choices: ['Debug', 'Release', 'MinSizeRel', 'RelWithDebInfo'], description: 'Build Type')]
	}
        echo "Build Type: ${env.BUILD_TYPE}"
      }
    }
    stage('Build') {
      parallel {
        stage('Unix') {
          when { expression { isUnix() } }
          steps {
            sh '''make venv_create
`make --no-print-directory venv_activate`
python -m pip install --upgrade pip
make cmake_project
make build'''
          }
        }
        stage('Windows') {
          when { expression { !isUnix() } }
          steps {
            bat '''make venv_create
make venv_activate
python -m pip install --upgrade pip
make cmake_project
make build'''
          }
        }
      }
    }
    stage('Test') {
      environment {
        GTEST_OUTPUT = 'xml:../gtest/'
      }
      parallel {
        stage('Unix') {
          when { expression { isUnix() } }
          steps {
            sh """`make --no-print-directory venv_activate`
cd ${env.BUILD_TYPE} && ctest -C ${env.BUILD_TYPE} -T Test --no-compress-output"""
          }
        }
        stage('Windows') {
          when { expression { !isUnix() } }
          steps {
            bat """make venv_activate
cd ${env.BUILD_TYPE} && ctest -C ${env.BUILD_TYPE} -T Test --no-compress-output"""
          }
        }
      }
      post {
        always {
          archiveArtifacts artifacts: "${env.BUILD_TYPE}/Testing/**/*.xml, ${env.BUILD_TYPE}/gtest/**/*.xml", fingerprint: true
          xunit (
            thresholds: [ skipped(failureThreshold: '0'), failed(failureThreshold: '0') ],
            tools: [
              CTest(pattern: "${env.BUILD_TYPE}/Testing/**/*.xml", deleteOutputFiles: true, failIfNotNew: false, skipNoTestFiles: true, stopProcessingIfError: true),
              GoogleTest(pattern: "${env.BUILD_TYPE}/gtest/**/*.xml", deleteOutputFiles: true, failIfNotNew: false, skipNoTestFiles: true, stopProcessingIfError: true)
            ]
          )
        }
      }
    }
  }
}
