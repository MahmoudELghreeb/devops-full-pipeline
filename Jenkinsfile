pipeline {
    agent any

    environment {
        DOCKER_HUB_USERNAME = 'mahmoudelghreeb'
        IMAGE_NAME = "${DOCKER_HUB_USERNAME}/devops-full-pipeline"
        IMAGE_TAG = "latest"
    }

    stages {
        stage('Build') {
            steps {
                echo "Building application..."
                sh "ls -la src/"
            }
        }
        stage('Build Docker Image') {
            steps {
                echo "Building Docker image: ${IMAGE_NAME}:${IMAGE_TAG}"
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }
        stage('Test') {
            steps {
                echo "Running health check on Docker container..."
                sh "docker run -d --name test-container -p 8080:80 ${IMAGE_NAME}:${IMAGE_TAG}"
                sh "sleep 5"
                sh "curl -s --head http://localhost:8080 | grep '200 OK'"
                sh "docker stop test-container && docker rm test-container"
            }
        }
        stage('Login to Docker Hub') {
            steps {
                echo "Logging in to Docker Hub..."
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                echo "Pushing Docker image to Docker Hub..."
                sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                echo "Deploying to Kubernetes..."
                sh "kubectl apply -f k8s/"
                sh "kubectl get all"
            }
        }
    }

    post {
        success {
            echo "✅ Pipeline completed successfully!"
        }
        failure {
            echo "❌ Pipeline failed!"
        }
        always {
            echo "📌 Pipeline finished at ${new Date()}"
        }
    }
}
