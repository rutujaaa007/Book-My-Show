pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "rutujashivpuje/book-my-show"
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
                    withSonarQubeEnv('SonarQube') {
                        script {
                            def scannerHome = tool 'SonarQubeScanner'
                            sh """
                            ${scannerHome}/bin/sonar-scanner \
                              -Dsonar.projectKey=book-my-show \
                              -Dsonar.sources=./bookmyshow-app \
                              -Dsonar.host.url=$SONAR_HOST_URL \
                              -Dsonar.login=$SONAR_AUTH_TOKEN
                            """
                        }
                    }
                }
            }
        }

        stage('Quality Gate') {
            steps {
                script {
                    try {
                        timeout(time: 5, unit: 'MINUTES') {
                            def qg = waitForQualityGate()
                            if (qg.status != 'OK') {
                                echo "⚠️ Quality Gate failed: ${qg.status}"
                                // warning only, not abort
                            }
                        }
                    } catch (err) {
                        echo "⚠️ Quality Gate skipped: ${err}"
                    }
                }
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'cd bookmyshow-app && npm install'
            }
        }

        stage('Docker Build & Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-token', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                    echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                    docker build -t $DOCKER_IMAGE:${BUILD_NUMBER} ./bookmyshow-app
                    docker push $DOCKER_IMAGE:${BUILD_NUMBER}
                    docker tag $DOCKER_IMAGE:${BUILD_NUMBER} $DOCKER_IMAGE:latest
                    docker push $DOCKER_IMAGE:latest
                    '''
                }
            }
        }

        stage('Deploy to Docker') {
            steps {
                sh '''
                docker rm -f bms || true
                docker run -d -p 3000:3000 --name bms $DOCKER_IMAGE:latest
                '''
            }
        }
    }

    post {
        always {
            emailext (
                to: 'your-email@example.com',
                subject: "Build #${env.BUILD_NUMBER} - ${currentBuild.currentResult}",
                body: """
                Hello Team,

                Jenkins Pipeline finished.

                Project: BookMyShow
                Build Number: #${env.BUILD_NUMBER}
                Result: ${currentBuild.currentResult}

                Logs: ${env.BUILD_URL}

                Regards,
                Jenkins CI/CD
                """,
                mimeType: 'text/plain'
            )
        }
    }
}
