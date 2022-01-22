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
      agent { label env.BUILD_AGENT }
      steps {
        checkout scm
        script {
          if (isUnix()) {
            sh '''make venv_create
`make --no-print-directory venv_activate`
python -m pip install --upgrade pip'''
          } else {
            bat 'make venv_create && .venv\\Scripts\\activate && python -m pip install --upgrade pip'
          }
        }
        stash 'prepare'
      }
    }
    stage('Build') {
      agent { label env.BUILD_AGENT }
      steps {
        unstash 'prepare'
        script {
          if (isUnix()) {
            sh '''`make --no-print-directory venv_activate`
make cmake_project
make build'''
          } else {
            bat 'make venv_activate && make cmake_project && make build'
          }
        }
        stash 'build'
      }
    }
    stage('Test') {
      environment {
        GTEST_OUTPUT = 'xml:../gtest/'
      }
      agent { label env.BUILD_AGENT }
      steps {
        unstash 'build'
        script {
          if (isUnix()) {
            sh "cd ${env.BUILD_TYPE} && ctest -C ${env.BUILD_TYPE} -T Test --no-compress-output"
          } else {
            bat "cd ${env.BUILD_TYPE} && ctest -C ${env.BUILD_TYPE} -T Test --no-compress-output"
          }
        }
        stash 'test'
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
    stage('Wrap Up') {
      parallel {
        stage('Coverage') {
          agent { label env.BUILD_AGENT }
          steps {
            unstash 'test'
            script {
              if (isUnix()) {
                sh 'make coverage'
              } else {
                bat 'make coverage'
              }
            }
          }
          post {
            success {
              script {
                if (isUnix()) {
                  env.PROJECT_NAME = sh(script: 'make --no-print-directory project_name', returnStdout: true).trim()
                  env.COVERAGE_REPORT_DIR = sh(script: "ls -td1 ${env.BUILD_TYPE}/${env.PROJECT_NAME}/coverage/CoverageReport-*/ | head -n1", returnStdout: true).trim()
                  env.COVERAGE_REPORT_FILE = 'CoverageReport.html'
                } else {
                  env.PROJECT_NAME = bat(script: 'make project_name', returnStdout: true).trim()
                  env.COVERAGE_REPORT_DIR = bat(script: "dir /b /s /ad /o-n ${env.BUILD_TYPE}\\${env.PROJECT_NAME}\\coverage\\CoverageReport-*", returnStdout: true).split('\n').getAt(0).trim()
                  env.COVERAGE_REPORT_FILE = 'index.html'
                }
              }
              archiveArtifacts artifacts: "${env.BUILD_TYPE}/**/coverage/", fingerprint: true
              publishHTML target: [
                  allowMissing: false,
                  alwaysLinkToLastBuild: false,
                  keepAll: true,
                  reportDir: env.COVERAGE_REPORT_DIR,
                  reportFiles: env.COVERAGE_REPORT_FILE,
                  reportName: 'Coverage Report'
              ]
            }
          }
        }
        stage('Pack') {
          agent { label env.BUILD_AGENT }
          steps {
            unstash 'build'
            script {
              if (isUnix()) {
                sh 'make package'
              } else {
                withEnv(['PACK_FORMAT=ZIP']) {
                  bat 'make package'
                }
              }
            }
          }
          post {
            success {
              script {
                if (isUnix()) {
                  env.PACKAGE_FILE_NAME = sh(script: 'make --no-print-directory package_file_name', returnStdout: true).trim()
                } else {
                  env.PACKAGE_FILE_NAME = bat(script: '@make package_file_name', returnStdout: true).trim()
                }
              }
              archiveArtifacts artifacts: "${env.BUILD_TYPE}/${env.PACKAGE_FILE_NAME}*", fingerprint: true
            }
          }
        }
        stage('Doxygen') {
          agent { label env.BUILD_AGENT }
          steps {
            unstash 'build'
            script {
              if (isUnix()) {
                sh 'make --no-print-directory doxygen'
              } else {
                bat 'make doxygen'
              }
            }
          }
          post {
            success {
              archiveArtifacts artifacts: "doxygen/", fingerprint: true
              publishHTML target: [
                  allowMissing: false,
                  alwaysLinkToLastBuild: false,
                  keepAll: true,
                  reportDir: 'doxygen/html/',
                  reportFiles: 'index.html',
                  reportName: 'Doxygen'
              ]
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
