pipeline {
    agent any

    environment {
        DOCKERHUB_REPO = "rutujashivpuje/book-my-show"
    }

    stages {
        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Checkout Code') {
            steps {
                git branch: 'feature/ci-cd-setup',
                    url: 'https://github.com/rutujaaa007/book-my-show.git'
            }
        }

        stage('SonarQube Analysis') {
    steps {
        withCredentials([string(credentialsId: 'sonar-token', variable: 'SONAR_AUTH_TOKEN')]) {
            withSonarQubeEnv('SonarQube') {   // Matches your configured server name
                script {
                    def scannerHome = tool 'SonarQubeScanner'   // Matches your scanner installation
                    sh """
                        ${scannerHome}/bin/sonar-scanner \
                          -Dsonar.projectKey=book-my-show \
                          -Dsonar.sources=. \
                          -Dsonar.host.url=$SONAR_HOST_URL \
                          -Dsonar.login=$SONAR_AUTH_TOKEN
                    """
                }
            }
        }
    }
}        

        stage('SonarQube Quality Gate') {
            steps {
                timeout(time: 1, unit: 'HOURS') { // optional timeout
                    script {
                        def qg = waitForQualityGate()
                        if (qg.status != 'OK') {
                            error "Pipeline failed due to SonarQube Quality Gate: ${qg.status}"
                        }
                    }
                }
            }
        }

        stage('Install Dependencies') {
    steps {
        dir('bookmyshow-app') {
            sh 'npm install'
        }
    }
}


        stage('Docker Build & Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-token', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    script {
                        def IMAGE = "${DOCKERHUB_REPO}:${BUILD_NUMBER}"
                        sh "docker build -t ${IMAGE} ."
                        sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
                        sh "docker push ${IMAGE}"
                        env.IMAGE = IMAGE
                    }
                }
            }
        }

        stage('Deploy to Docker Container') {
            steps {
                script {
                    sh '''
                        docker rm -f bms || true
                        docker run -d -p 3000:3000 --name bms ${env.IMAGE}
                    '''
                }
            }
        }
    }

    post {
        success {
            emailext(
                subject: "BMS Build #${BUILD_NUMBER} SUCCESS",
                body: "Build succeeded: ${BUILD_URL}",
                to: "your-email@example.com"
            )
        }
        failure {
            emailext(
                subject: "BMS Build #${BUILD_NUMBER} FAILED",
                body: "Build failed: ${BUILD_URL}",
                to: "your-email@example.com"
            )
        }
    }
}
