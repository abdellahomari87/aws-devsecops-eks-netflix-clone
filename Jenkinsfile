pipeline {
    agent any

    tools {
        jdk 'jdk21'
        nodejs 'Node18'
    }

    environment {
        SCANNER_HOME = tool 'SonarScanner'
        AWS_REGION   = 'us-east-1'
        CLUSTER_NAME = 'netflix-eks'
        IMAGE_NAME   = 'omari87/netflix'
        IMAGE_TAG    = "${BUILD_NUMBER}"
        K8S_NS       = 'netflix'
        TEST_NS      = 'netflix-test'
    }

    stages {
        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Checkout') {
            steps {
                git branch: 'modernisation-project', url: 'https://github.com/abdellahomari87/Netflix-clone-abdellah.git'
            }
        }

        stage('Check Environment') {
            steps {
                sh '''
                    set -e
                    echo "=== Versions ==="
                    java -version
                    node -v
                    npm -v
                    git --version
                    docker --version
                    trivy --version
                    echo "SCANNER_HOME=$SCANNER_HOME"
                    ls -l "$SCANNER_HOME/bin" || true
                    "$SCANNER_HOME/bin/sonar-scanner" --version
                '''
            }
        }

        stage('Install Dependencies') {
            steps {
                sh '''
                    set -e
                    npm install
                '''
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh '''
                        set -e
                        "$SCANNER_HOME/bin/sonar-scanner" \
                          -Dsonar.projectName=netflix-clone \
                          -Dsonar.projectKey=netflix-clone \
                          -Dsonar.sources=. \
                          -Dsonar.host.url=$SONAR_HOST_URL \
                          -Dsonar.token=$SONAR_AUTH_TOKEN
                    '''
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 10, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('OWASP Dependency Check') {
            steps {
                withCredentials([string(credentialsId: 'nvd-api-key', variable: 'NVD_API_KEY')]) {
                    dependencyCheck(
                        odcInstallation: 'DependencyCheck',
                        additionalArguments: "--scan ./ --disableYarnAudit --disableNodeAudit --format XML --format HTML --nvdApiKey ${NVD_API_KEY}",
                        stopBuild: false
                    )
                }
            }
        }

        stage('Publish Dependency Check Report') {
            steps {
                dependencyCheckPublisher(
                    pattern: '**/dependency-check-report.xml',
                    stopBuild: false,
                    failedTotalCritical: 9999,
                    failedTotalHigh: 9999,
                    unstableTotalHigh: 1,
                    unstableTotalMedium: 1
                )
            }
        }

        stage('Trivy FS Scan') {
            steps {
                sh '''
                    set -e
                    trivy fs --no-progress --exit-code 0 --severity HIGH,CRITICAL --format table -o trivyfs.txt .
                '''
            }
        }

        stage('Docker Build') {
            steps {
                withCredentials([string(credentialsId: 'tmdb-api-key', variable: 'TMDB_KEY')]) {
                    sh '''
                        set -e
                        docker build \
                          --build-arg TMDB_V3_API_KEY=$TMDB_KEY \
                          -t ${IMAGE_NAME}:${IMAGE_TAG} \
                          -t ${IMAGE_NAME}:latest .
                    '''
                }
            }
        }

        stage('Trivy Image Scan') {
            steps {
                sh '''
                    set -e
                    trivy image --no-progress --exit-code 0 --severity HIGH,CRITICAL --format table -o trivyimage.txt ${IMAGE_NAME}:${IMAGE_TAG}
                '''
            }
        }

        stage('Push Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        set -e
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push ${IMAGE_NAME}:${IMAGE_TAG}
                        docker push ${IMAGE_NAME}:latest
                        docker logout
                    '''
                }
            }
        }

        stage('Configure kubeconfig') {
            steps {
                sh '''
                    set -e
                    aws eks update-kubeconfig --region ${AWS_REGION} --name ${CLUSTER_NAME}
                    kubectl config current-context
                    kubectl get nodes
                '''
            }
        }

        stage('Update Manifest Image') {
            steps {
                sh '''
                    set -e
                    sed -i "s|image: .*|image: ${IMAGE_NAME}:${IMAGE_TAG}|g" Kubernetes/deployment.yml
                    echo "=== deployment.yml after update ==="
                    cat Kubernetes/deployment.yml
                '''
            }
        }

        stage('Deploy App to Kubernetes') {
            steps {
                sh '''
                    set -e

                    echo "=== Create app namespace ==="
                    kubectl apply -f Kubernetes/namespace.yaml

                    echo "=== Deploy app resources ==="
                    kubectl apply -f Kubernetes/deployment.yml
                    kubectl apply -f Kubernetes/service.yml
                    kubectl apply -f Kubernetes/ingress.yml

                    echo "=== Wait for rollout ==="
                    kubectl rollout status deployment/netflix-app -n ${K8S_NS} --timeout=180s

                    echo "=== App resources ==="
                    kubectl get deployment -n ${K8S_NS}
                    kubectl get pods -n ${K8S_NS} -o wide
                    kubectl get svc -n ${K8S_NS}
                    kubectl get ingress -n ${K8S_NS}
                    kubectl get endpoints -n ${K8S_NS}
                    kubectl describe ingress netflix-ingress -n ${K8S_NS} || true
                '''
            }
        }

        stage('Deploy NetworkPolicy Test Resources') {
            steps {
                sh '''
                    set -e

                    echo "=== Create test namespace ==="
                    kubectl apply -f Kubernetes/test-network-policy/namespace.yaml

                    echo "=== Apply test resources ==="
                    kubectl apply -f Kubernetes/test-network-policy/nginx.yaml
                    kubectl apply -f Kubernetes/test-network-policy/clients.yaml

                    echo "=== Apply network policies ==="
                    kubectl apply -f Kubernetes/test-network-policy/networkpolicy-client-allowed.yaml
                    kubectl apply -f Kubernetes/test-network-policy/networkpolicy-nginx.yaml
                    kubectl apply -f Kubernetes/test-network-policy/networkpolicy-default-deny.yaml

                    echo "=== Wait for test pods ==="
                    kubectl wait --for=condition=Ready pod/nginx -n ${TEST_NS} --timeout=180s
                    kubectl wait --for=condition=Ready pod/client-allowed -n ${TEST_NS} --timeout=180s
                    kubectl wait --for=condition=Ready pod/client-blocked -n ${TEST_NS} --timeout=180s

                    echo "=== Test namespace resources ==="
                    kubectl get all -n ${TEST_NS}
                    kubectl get networkpolicy -n ${TEST_NS}
                '''
            }
        }

        stage('Validate NetworkPolicy') {
            steps {
                sh '''
                    set -e

                    echo "=== DNS test from allowed client ==="
                    kubectl exec -n ${TEST_NS} client-allowed -- sh -c "nslookup nginx.${TEST_NS}.svc.cluster.local || exit 1"

                    echo "=== Allowed client must reach nginx ==="
                    kubectl exec -n ${TEST_NS} client-allowed -- curl -I --max-time 10 http://nginx

                    echo "=== Blocked client must NOT reach nginx ==="
                    
                    set +e
                    kubectl exec -n ${TEST_NS} client-blocked -- curl -I --max-time 10 http://nginx
                    RESULT=$?
                    set -e

                    if [ $RESULT -eq 0 ]; then
                      echo "ERROR: client-blocked reached nginx"
                      exit 1
                    else
                      echo "OK: client-blocked was denied"
                    fi
                '''
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'trivyfs.txt,trivyimage.txt', fingerprint: true

            sh '''
                kubectl delete pod nginx -n ${TEST_NS} --ignore-not-found=true || true
                kubectl delete pod client-allowed -n ${TEST_NS} --ignore-not-found=true || true
                kubectl delete pod client-blocked -n ${TEST_NS} --ignore-not-found=true || true
                kubectl delete networkpolicy allow-client-allowed-egress -n ${TEST_NS} --ignore-not-found=true || true
                kubectl delete networkpolicy allow-nginx-from-client-allowed -n ${TEST_NS} --ignore-not-found=true || true
                kubectl delete networkpolicy default-deny -n ${TEST_NS} --ignore-not-found=true || true
                kubectl delete service nginx -n ${TEST_NS} --ignore-not-found=true || true

                echo "=== Docker images ==="
                docker images | head || true
            '''

            cleanWs()
        }

        success {
            echo 'Pipeline completed successfully.'
        }

        failure {
            echo 'Pipeline failed.'
        }
    }
}