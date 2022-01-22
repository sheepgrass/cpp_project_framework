pipeline {
  agent any
  parameters {
    choice(name: 'BUILD_TYPE', choices: ['Debug', 'Release', 'MinSizeRel', 'RelWithDebInfo'], description: 'Build Type')
  }
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
        sh '''`make --no-print-directory venv_activate`
make test'''
      }
    }

  }
}
