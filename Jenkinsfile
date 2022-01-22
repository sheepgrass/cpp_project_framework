pipeline {
  options {
    skipDefaultCheckout()
    buildDiscarder(logRotator(numToKeepStr: '10', artifactNumToKeepStr: '10'))
    preserveStashes()
  }
  agent none
  parameters {
    choice choices: ['', 'Any', 'Linux', 'Windows', 'Docker'], description: 'Build Agent', name: 'BUILD_AGENT'
    choice choices: ['', 'Debug', 'Release', 'MinSizeRel', 'RelWithDebInfo'], description: 'Build Type', name: 'BUILD_TYPE'
    booleanParam defaultValue: true, description: 'Enable Deploy Stage', name: 'ENABLE_DEPLOY_STAGE'
  }
  stages {
    stage('Init') {
      steps {
        script {
          def BUILD_AGENT = ''
          def BUILD_TYPE = ''
          if (params.BUILD_AGENT == '' || params.BUILD_TYPE == '') {
            def inputParams = input (
              message: 'Set Parameters:',
              parameters: [
                choice(choices: ['Any', 'Linux', 'Windows', 'Docker'], description: 'Build Agent', name: 'BUILD_AGENT'),
                choice(choices: ['Debug', 'Release', 'MinSizeRel', 'RelWithDebInfo'], description: 'Build Type', name: 'BUILD_TYPE')
              ]
            )
            BUILD_AGENT = inputParams.BUILD_AGENT
            BUILD_TYPE = inputParams.BUILD_TYPE
          } else {
            BUILD_AGENT = params.BUILD_AGENT
            BUILD_TYPE = params.BUILD_TYPE
          }
          env.BUILD_AGENT = BUILD_AGENT == 'Any' ? '' : BUILD_AGENT
          env.BUILD_TYPE = BUILD_TYPE
          parallel (
            "${BUILD_AGENT} - ${BUILD_TYPE}": {
              stage('Set Parameters') {
                echo "Build Agent: ${BUILD_AGENT}"
                echo "Build Type: ${BUILD_TYPE}"
              }
            }
          )
        }
      }
    }
    stage('Check') {
      options {
        timeout(time: 5, unit: 'SECONDS')
      }
      agent { label env.BUILD_AGENT }
      steps {
        echo "Build Agent: ${env.BUILD_AGENT}"
        echo "Build Type: ${env.BUILD_TYPE}"
      }
    }
    stage('Prepare') {
      parallel {
        stage('Unix') {
          agent { label env.BUILD_AGENT }
          when { expression { isUnix() } }
          steps {
            checkout scm
            sh '''make venv_create
`make --no-print-directory venv_activate`
python -m pip install --upgrade pip'''
            stash 'prepare'
          }
        }
        stage('Windows') {
          agent { label env.BUILD_AGENT }
          when { expression { !isUnix() } }
          steps {
            checkout scm
            bat 'make venv_create && .venv\\Scripts\\activate && python -m pip install --upgrade pip'
            stash 'prepare'
          }
        }
      }
    }
    stage('Build') {
      parallel {
        stage('Unix') {
          agent { label env.BUILD_AGENT }
          when { expression { isUnix() } }
          steps {
            unstash 'prepare'
            sh '''`make --no-print-directory venv_activate`
make cmake_project
make build'''
            stash 'build'
          }
        }
        stage('Windows') {
          agent { label env.BUILD_AGENT }
          when { expression { !isUnix() } }
          steps {
            unstash 'prepare'
            bat 'make venv_activate && make cmake_project && make build'
            stash 'build'
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
          agent { label env.BUILD_AGENT }
          when { expression { isUnix() } }
          steps {
            unstash 'build'
            sh "cd ${env.BUILD_TYPE} && ctest -C ${env.BUILD_TYPE} -T Test --no-compress-output"
            stash 'test'
          }
        }
        stage('Windows') {
          agent { label env.BUILD_AGENT }
          when { expression { !isUnix() } }
          steps {
            unstash 'build'
            bat "cd ${env.BUILD_TYPE} && ctest -C ${env.BUILD_TYPE} -T Test --no-compress-output"
            stash 'test'
          }
        }
      }
      post {
        always {
          node(env.BUILD_AGENT) {
            unstash 'test'
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
    stage('Post Test') {
      parallel {
        stage('Coverage - Unix') {
          agent { label env.BUILD_AGENT }
          when { expression { isUnix() } }
          steps {
            unstash 'test'
            sh 'make coverage'
          }
          post {
            success {
              archiveArtifacts artifacts: "${env.BUILD_TYPE}/**/coverage/", fingerprint: true
            }
          }
        }
        stage('Coverage - Windows') {
          agent { label env.BUILD_AGENT }
          when { expression { !isUnix() } }
          steps {
            unstash 'test'
            bat 'make coverage'
          }
          post {
            success {
              archiveArtifacts artifacts: "${env.BUILD_TYPE}/**/coverage/", fingerprint: true
            }
          }
        }
        stage('Pack - Unix') {
          agent { label env.BUILD_AGENT }
          when { expression { isUnix() } }
          steps {
            unstash 'build'
            sh 'make package'
          }
          post {
            success {
              script {
                env.PACKAGE_FILE_NAME = sh(script: 'make --no-print-directory package_file_name', returnStdout: true).trim()
              }
              archiveArtifacts artifacts: "${env.BUILD_TYPE}/${env.PACKAGE_FILE_NAME}*", fingerprint: true
            }
          }
        }
        stage('Pack - Windows') {
          agent { label env.BUILD_AGENT }
          when { expression { !isUnix() } }
          environment {
	    PACK_FORMAT = 'ZIP'
	  }
          steps {
            unstash 'build'
            bat 'make package'
          }
          post {
            success {
              script {
                env.PACKAGE_FILE_NAME = bat(script: '@make package_file_name', returnStdout: true).trim()
              }
              archiveArtifacts artifacts: "${env.BUILD_TYPE}/${env.PACKAGE_FILE_NAME}*", fingerprint: true
            }
          }
        }
        stage('Doxygen - Unix') {
          agent { label env.BUILD_AGENT }
          when { expression { isUnix() } }
          steps {
            unstash 'build'
            sh 'make --no-print-directory doxygen'
          }
          post {
            success {
              archiveArtifacts artifacts: "doxygen/", fingerprint: true
            }
          }
        }
        stage('Doxygen - Windows') {
          agent { label env.BUILD_AGENT }
          when { expression { !isUnix() } }
          steps {
            unstash 'build'
            bat 'make doxygen'
          }
          post {
            success {
              archiveArtifacts artifacts: "doxygen/", fingerprint: true
            }
          }
        }
      }
    }
    stage('Deploy') {
      agent { label env.BUILD_AGENT }
      when { expression { params.ENABLE_DEPLOY_STAGE } }
      steps {
        input 'Deploy?'
      }
    }
  }
}
