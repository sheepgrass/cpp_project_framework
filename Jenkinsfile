pipeline {
  agent any
  stages {
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
        sh '''`make --no-print-directory venv_activate`
make test'''
      }
    }

  }
  environment {
    BUILD_TYPE = 'Debug'
  }
}