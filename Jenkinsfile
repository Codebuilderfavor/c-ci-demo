pipeline {
    agent any

    environment {
        IMAGE_NAME = "c-ci-demo"
    }

    stages {
        stage('Checkout') {
            steps {
                echo '=== Checking out source code ==='
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "=== Building Docker image ${IMAGE_NAME}:${BUILD_NUMBER} and :latest ==="
                // Build ONCE, but give it TWO tags: ${BUILD_NUMBER} and latest
                sh "docker build -t ${IMAGE_NAME}:${BUILD_NUMBER} -t ${IMAGE_NAME}:latest ."
            }
        }

        stage('Run Tests in Docker') {
            steps {
                echo '=== Running tests inside container ==='
                // Use the build-number tag so we know exactly which image was tested
                sh "docker run --rm ${IMAGE_NAME}:${BUILD_NUMBER} sh /app/test.sh"
            }
        }

        stage('Run Program (Smoke Test)') {
            steps {
                echo '=== Smoke test ==='
                sh """
                    # Remove any previous container with this name (ignore errors)
                    docker rm -f c-ci-demo-smoke || true

                    # Run the program from the image we just built
                    docker run --name c-ci-demo-smoke ${IMAGE_NAME}:${BUILD_NUMBER}

                    echo '=== Container logs from smoke test ==='
                    docker logs c-ci-demo-smoke || true

                    # Clean up the container
                    docker rm -f c-ci-demo-smoke || true
                """
            }
        }

        // Optional: later you can add a Push stage here
        // stage('Push Image') {
        //     when {
        //         expression { return env.DOCKERHUB_USER }
        //     }
        //     steps {
        //         echo "=== Pushing image to registry ==="
        //         sh "docker push ${IMAGE_NAME}:${BUILD_NUMBER}"
        //         sh "docker push ${IMAGE_NAME}:latest"
        //     }
        // }
    }

    post {
        always {
            echo '=== Build finished (success or failure) ==='
            // Light cleanup if you want (safe: only dangling layers)
            // sh 'docker image prune -f || true'
        }
    }
}
