pipeline {
  options {
    skipDefaultCheckout()
    buildDiscarder(logRotator(numToKeepStr: '10', artifactNumToKeepStr: '10'))
    preserveStashes()
  }
  agent none
  parameters {
    choice choices: ['', 'All', 'Any', 'Linux', 'Windows', 'Docker'], description: 'Build Agent', name: 'BUILD_AGENT_FILTER'
    choice choices: ['', 'All', 'Debug and Release', 'Debug', 'Release', 'MinSizeRel', 'RelWithDebInfo'], description: 'Build Type', name: 'BUILD_TYPE_FILTER'
    booleanParam defaultValue: true, description: 'Enable Deploy Stage', name: 'ENABLE_DEPLOY_STAGE'
  }
  stages {
    stage('Init') {
      steps {
        script {
          def BUILD_AGENT_FILTER = ''
          def BUILD_TYPE_FILTER = ''
          if (params.BUILD_AGENT_FILTER == '' || params.BUILD_TYPE_FILTER == '') {
            def inputParams = input (
              message: 'Set Parameters:',
              parameters: [
                choice(choices: ['All', 'Any', 'Linux', 'Windows', 'Docker'], description: 'Build Agent', name: 'BUILD_AGENT_FILTER'),
                choice(choices: ['All', 'Debug and Release', 'Debug', 'Release', 'MinSizeRel', 'RelWithDebInfo'], description: 'Build Type', name: 'BUILD_TYPE_FILTER')
              ]
            )
            BUILD_AGENT_FILTER = inputParams.BUILD_AGENT_FILTER
            BUILD_TYPE_FILTER = inputParams.BUILD_TYPE_FILTER
          } else {
            BUILD_AGENT_FILTER = params.BUILD_AGENT_FILTER
            BUILD_TYPE_FILTER = params.BUILD_TYPE_FILTER
          }
          env.BUILD_AGENT_FILTER = BUILD_AGENT_FILTER
          env.BUILD_TYPE_FILTER = BUILD_TYPE_FILTER
          parallel (
            "${BUILD_AGENT_FILTER} - ${BUILD_TYPE_FILTER}": {
              stage('Set Parameters') {
                echo "Build Agent: ${BUILD_AGENT_FILTER}"
                echo "Build Type: ${BUILD_TYPE_FILTER}"
              }
            }
          )
        }
      }
    }
    stage('Pipeline') {
      matrix {
        when {
          allOf {
            anyOf {
              expression { env.BUILD_AGENT_FILTER == 'All' }
              expression { env.BUILD_AGENT_FILTER == env.BUILD_AGENT }
            }
            anyOf {
              expression { env.BUILD_TYPE_FILTER == 'All' }
              expression { env.BUILD_TYPE_FILTER == env.BUILD_TYPE }
              allOf {
                expression { env.BUILD_TYPE_FILTER == 'Debug and Release' }
                anyOf {
                  expression { env.BUILD_TYPE == 'Debug' }
                  expression { env.BUILD_TYPE == 'Release' }
                }
              }
            }
            not {
              allOf {
                expression { env.BUILD_AGENT_FILTER == 'All' }
                expression { env.BUILD_AGENT == 'Any' }
              }
            }
          }
        }
        axes {
          axis {
            name 'BUILD_AGENT'
            values 'Any', 'Linux', 'Windows', 'Docker'
          }
          axis {
            name 'BUILD_TYPE'
            values 'Debug', 'Release', 'MinSizeRel', 'RelWithDebInfo'
          }
        }
        stages {
          stage('Check') {
            options {
              timeout(time: 5, unit: 'SECONDS')
            }
            agent {
              node {
                label env.BUILD_AGENT == 'Any' ? '' : env.BUILD_AGENT
                customWorkspace "${env.JOB_NAME}/${env.BUILD_AGENT}/${env.BUILD_TYPE}"
              }
            }
            steps {
              echo "Build Agent: ${env.BUILD_AGENT}"
              echo "Build Type: ${env.BUILD_TYPE}"
              echo "Build Workspace: ${env.JOB_NAME}/${env.BUILD_AGENT}/${env.BUILD_TYPE}"
            }
          }
          stage('Prepare') {
            agent {
              node {
                label env.BUILD_AGENT == 'Any' ? '' : env.BUILD_AGENT
                customWorkspace "${env.JOB_NAME}/${env.BUILD_AGENT}/${env.BUILD_TYPE}"
              }
            }
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
              stash "prepare_${env.BUILD_AGENT}_${env.BUILD_TYPE}"
            }
          }
          stage('Build') {
            agent {
              node {
                label env.BUILD_AGENT == 'Any' ? '' : env.BUILD_AGENT
                customWorkspace "${env.JOB_NAME}/${env.BUILD_AGENT}/${env.BUILD_TYPE}"
              }
            }
            steps {
              unstash "prepare_${env.BUILD_AGENT}_${env.BUILD_TYPE}"
              script {
                if (isUnix()) {
                  sh '''`make --no-print-directory venv_activate`
make cmake_project
make build'''
                } else {
                  bat 'make venv_activate && make cmake_project && make build'
                }
              }
              stash "build_${env.BUILD_AGENT}_${env.BUILD_TYPE}"
            }
          }
          stage('Test') {
            environment {
              GTEST_OUTPUT = 'xml:../gtest/'
            }
            agent {
              node {
                label env.BUILD_AGENT == 'Any' ? '' : env.BUILD_AGENT
                customWorkspace "${env.JOB_NAME}/${env.BUILD_AGENT}/${env.BUILD_TYPE}"
              }
            }
            steps {
              unstash "build_${env.BUILD_AGENT}_${env.BUILD_TYPE}"
              script {
                if (isUnix()) {
                  sh "cd ${env.BUILD_TYPE} && ctest -C ${env.BUILD_TYPE} -T Test --no-compress-output"
                } else {
                  bat "cd ${env.BUILD_TYPE} && ctest -C ${env.BUILD_TYPE} -T Test --no-compress-output"
                }
              }
              stash "test_${env.BUILD_AGENT}_${env.BUILD_TYPE}"
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
          stage('Pack') {
            agent {
              node {
                label env.BUILD_AGENT == 'Any' ? '' : env.BUILD_AGENT
                customWorkspace "${env.JOB_NAME}/${env.BUILD_AGENT}/${env.BUILD_TYPE}"
              }
            }
            steps {
              unstash "build_${env.BUILD_AGENT}_${env.BUILD_TYPE}"
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
          stage('Coverage') {
            agent {
              node {
                label env.BUILD_AGENT == 'Any' ? '' : env.BUILD_AGENT
                customWorkspace "${env.JOB_NAME}/${env.BUILD_AGENT}/${env.BUILD_TYPE}"
              }
            }
            steps {
              unstash "test_${env.BUILD_AGENT}_${env.BUILD_TYPE}"
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
                    reportName: "Coverage Report (${env.BUILD_AGENT} - ${env.BUILD_TYPE})"
                ]
              }
            }
          }
          stage('Doxygen') {
            agent {
              node {
                label env.BUILD_AGENT == 'Any' ? '' : env.BUILD_AGENT
                customWorkspace "${env.JOB_NAME}/${env.BUILD_AGENT}/${env.BUILD_TYPE}"
              }
            }
            steps {
              unstash "build_${env.BUILD_AGENT}_${env.BUILD_TYPE}"
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
                    reportName: "Doxygen (${env.BUILD_AGENT} - ${env.BUILD_TYPE})"
                ]
              }
            }
          }
        }
      }
    }
    stage('Deploy') {
      when { expression { params.ENABLE_DEPLOY_STAGE } }
      steps {
        input 'Deploy?'
      }
    }
  }
}
