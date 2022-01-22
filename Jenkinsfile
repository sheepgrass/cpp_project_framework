pipeline {
  agent any
  stages {
    stage('Init') {
      steps {
	script {
	  env.BUILD_TYPE = input message: 'Set parameters:', parameters: [choice(name: 'BUILD_TYPE', choices: ['Debug', 'Release', 'MinSizeRel', 'RelWithDebInfo'], description: 'Build Type')]
	}
      }
    }
    stage('Build') {
      steps {
        sh '''make venv_create
`make --no-print-directory venv_activate`
python -m pip install --upgrade pip
make cmake_project
make build'''
      }
    }
    stage('Test') {
      steps {
        sh """`make --no-print-directory venv_activate`
cd ${env.BUILD_TYPE} && ctest -C ${env.BUILD_TYPE} -T Test --no-compress-output"""
      }
    }
  }
  post {
    always {
      xunit (
        thresholds: [ skipped(failureThreshold: '0'), failed(failureThreshold: '0') ],
        tools: [ CTest(pattern: "${env.BUILD_TYPE}/**/*.xml", deleteOutputFiles: true, failIfNotNew: false, skipNoTestFiles: true, stopProcessingIfError: true) ]
      )
    }
  }
}
