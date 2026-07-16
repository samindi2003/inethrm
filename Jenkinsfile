pipeline {
    agent any

    environment {
        // Target GitHub Container Registry
        REGISTRY        = 'ghcr.io'
        IMAGE_NAME      = 'nglsarath/inethrm'
        IMAGE_TAG       = 'latest'
        
        // Credentials ID configured in Jenkins Credentials manager
        GHCR_CREDS_ID   = 'ghcr-credentials' 
        //GHCR_CREDS_ID   = 'ghcr-credentials'
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Build Image') {
            steps {
                script {
                    echo "Building Docker image: ${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}"
                    sh "docker build -t ${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG} ."
                }
            }
        }

        stage('Push Image to GHCR') {
            steps {
                script {
                    echo "Logging into GHCR registry at ${REGISTRY}..."
                    withCredentials([usernamePassword(credentialsId: GHCR_CREDS_ID, usernameVariable: 'GHCR_USER', passwordVariable: 'GHCR_PASS')]) {
                        sh "echo '${GHCR_PASS}' | docker login ${REGISTRY} -u '${GHCR_USER}' --password-stdin"
                        sh "docker push ${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}"
                    }
                }
            }
        }

        stage('Clean Image') {
            steps {
                echo "Cleaning up local build image..."
                sh "docker rmi ${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG} || true"
            }
        }
    }
}
