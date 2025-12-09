pipeline {
    agent any

    environment {
        IMAGE_NAME = "c-ci-demo"
    }

    stages {
        stage('Checkout') {
            steps {
                echo '=== Checkout ==='
                checkout scm
                sh 'ls -la'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo '=== Docker Build ==='
                sh "docker build -t ${IMAGE_NAME}:${BUILD_NUMBER} ."
            }
        }

        stage('Run Tests in Docker') {
            steps {
                echo '=== Running tests ==='
                sh "docker run --rm ${IMAGE_NAME}:${BUILD_NUMBER} sh /app/test.sh"
            }
        }

        stage('Run Program (Smoke Test)') {
            steps {
                echo '=== Smoke test ==='
                sh """
                    # Remove any previous container with this name (ignore errors)
                    docker rm -f c-ci-test || true

                    # Run the program in a fresh container
                    docker run --rm --name c-ci-test ${IMAGE_NAME}:${BUILD_NUMBER} ./hello
                """
            }
        }

        stage('Cleanup') {
            steps {
                echo '=== Cleanup (no-op, just in case) ==='
                sh 'docker rm -f c-ci-test || true'
            }
        }
    }

    post {
        success { echo 'SUCCESS: All stages passed!' }
        failure { echo 'FAILURE: See details above.' }
    }
}
