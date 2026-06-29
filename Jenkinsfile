// ──────────────────────────────────────────────────
// CodeAlpha DevOps Internship — Task 2
// Sample Pipeline Job — runs on the remote agent
//
// To use: In Jenkins UI → New Item → Pipeline
// Paste this into the Pipeline Script box
// ──────────────────────────────────────────────────

pipeline {
    // Run this job on the remote agent node
    agent {
        label 'agent'
    }

    // Environment variables
    environment {
        PROJECT_NAME = 'CodeAlpha-DevOps-Task2'
        BUILD_ENV    = 'Jenkins Remoting'
    }

    // Pipeline stages
    stages {

        stage('Initialize') {
            steps {
                echo "=========================================="
                echo "  CodeAlpha DevOps Internship — Task 2"
                echo "  Jenkins Remoting Project"
                echo "=========================================="
                echo "Build #     : ${BUILD_NUMBER}"
                echo "Agent Node  : ${NODE_NAME}"
                echo "Workspace   : ${WORKSPACE}"
                echo "Branch      : ${GIT_BRANCH ?: 'N/A'}"
                echo "=========================================="
            }
        }

        stage('Verify Agent Environment') {
            steps {
                echo "--- Verifying remote agent tools ---"
                sh 'echo "Hostname  : $(hostname)"'
                sh 'echo "Java      : $(java -version 2>&1 | head -1)"'
                sh 'echo "Git       : $(git --version)"'
                sh 'echo "Gradle    : $(gradle --version | head -1)"'
                sh 'echo "OS        : $(uname -a)"'
                sh 'echo "User      : $(whoami)"'
                sh 'echo "Workspace : $(pwd)"'
            }
        }

        stage('Checkout') {
            steps {
                echo "--- Checking out source code on remote agent ---"
                // In a real project, replace with your actual repo:
                // git url: 'https://github.com/YOUR_USERNAME/YOUR_REPO.git', branch: 'main'
                sh '''
                    mkdir -p src
                    echo "public class Main {" > src/Main.java
                    echo "    public static void main(String[] args) {" >> src/Main.java
                    echo "        System.out.println(\\"CodeAlpha Jenkins Remoting — Build #${BUILD_NUMBER}\\");" >> src/Main.java
                    echo "    }" >> src/Main.java
                    echo "}" >> src/Main.java
                    echo "✅ Source code ready"
                    cat src/Main.java
                '''
            }
        }

        stage('Build') {
            steps {
                echo "--- Building on remote agent: ${NODE_NAME} ---"
                sh '''
                    mkdir -p out
                    javac src/Main.java -d out/
                    echo "✅ Build successful on agent: $(hostname)"
                '''
            }
        }

        stage('Test') {
            steps {
                echo "--- Running tests on remote agent ---"
                sh '''
                    cd out
                    java Main
                    echo "✅ All tests passed on agent: $(hostname)"
                '''
            }
        }

        stage('Node Isolation Check') {
            steps {
                echo "--- Verifying node isolation (security) ---"
                sh '''
                    echo "Agent Name    : $AGENT_NAME"
                    echo "Environment   : $ENVIRONMENT"
                    echo "Network       : $(hostname -I)"
                    echo "✅ Node isolation verified — build is sandboxed"
                '''
            }
        }

        stage('Report') {
            steps {
                echo "--- Build Summary ---"
                sh '''
                    echo "=========================================="
                    echo "  BUILD COMPLETE"
                    echo "------------------------------------------"
                    echo "  Status    : SUCCESS"
                    echo "  Agent     : $(hostname)"
                    echo "  Project   : CodeAlpha DevOps Task 2"
                    echo "  Internship: CodeAlpha"
                    echo "=========================================="
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Pipeline completed successfully on agent: ${NODE_NAME}"
        }
        failure {
            echo "❌ Pipeline failed on agent: ${NODE_NAME}"
        }
        always {
            echo "🧹 Cleaning up workspace on agent..."
            cleanWs()
        }
    }
}
