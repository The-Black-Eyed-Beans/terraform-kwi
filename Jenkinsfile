pipeline {
    agent any

    options { 
        buildDiscarder(logRotator(daysToKeepStr: '7', numToKeepStr: '3')) 
    }

    tools {
        terraform "Terraform"
        go "Golang"
    }

    environment {
        REGION_KWI = credentials("REGION-KWI")
        BUCKET_KWI = credentials("BUCKET-KWI")
        // DEPLOY_DIR = "deployment"
        MODULE_DIR = "modules"
        TEST_DIR= "test"
        // ENVIRONMENT = "dev"
        COMMIT_HASH = "${sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()}"
    }

    stages {
        stage("Selecting Environment") {
            steps {
                script {
                    if (env.GIT_BRANCH == "master") {
                        env.ENVIRONMENT = "prod"
                    } else {
                        env.ENVIRONMENT = "dev"
                    }
                }
            }
        }

        stage("Init") {
            steps {
                echo "Initializing Terraform..."
                dir ("${ENVIRONMENT}") {
                    sh "aws s3 --profile keshaun cp s3://${BUCKET_KWI}/inputs/backend-${ENVIRONMENT}.hcl ."
                    sh """
                    terraform init \
                        -no-color \
                        -migrate-state \
                        -backend-config=backend-${ENVIRONMENT}.hcl
                    """
                }
            }
        }

        stage("TFLint") {
            steps {
                echo "Checking for errors via TFLint..."
                dir ("${MODULE_DIR}/vpc") {
                    echo "Checking VPC module..."
                    sh "tflint --init"
                    sh "tflint"
                }
                dir ("${MODULE_DIR}/ecs") {
                    echo "Checking ECS module..."
                    sh "tflint"
                }
                dir ("${MODULE_DIR}/eks") {
                    echo "Checking EKS module..."
                    sh "tflint"
                }
                dir ("${MODULE_DIR}/secret") {
                    echo "Checking Secrets module..."
                    sh "tflint"
                }
            }
        }

        stage("Plan") {
            steps {
                echo "Creating Terraform Plan..."
                dir ("${ENVIRONMENT}") {
                    sh "aws s3 --profile keshaun cp s3://${BUCKET_KWI}/inputs/input-${ENVIRONMENT}.tfvars ."
                    sh "terraform plan -var-file=input-${ENVIRONMENT}.tfvars -no-color > out.txt"
                }
            }
        }

        stage("Test") {
            steps {
                echo "Testing Terraform Deployment"
                dir ("${TEST_DIR}") {
                    script {
                        def plans = sh(script: 'cat ../${ENVIRONMENT}/out.txt',returnStdout: true)
                        if (plans.contains("Plan:")) {
                            sh "aws s3 --profile keshaun cp s3://${BUCKET_KWI}/inputs/aws_infrastructure_testdata_${ENVIRONMENT}.json ."
                            sh "mv aws_infrastructure_testdata_${ENVIRONMENT}.json aws_infrastructure_testdata.json"
                            sh "go mod init aws_infrastructure"
                            sh "go mod tidy"
                            //sh "envsubst < aws_infrastructure_test.go | go test - -v -timeout 30m"
                            sh "go test ./aws_infrastructure_test.go -v -timeout 30m"
                        } else {
                            error("No changes to be made to Terraform infrastructure.")
                        }
                    }
                }
            }
        }

        stage("Apply") {
            steps {
                echo "Applying Terraform Plan..."
                dir ("${ENVIRONMENT}") {
                    script {
                        def plans = sh(script: 'cat out.txt',returnStdout: true)
                        if (plans.contains("Plan:")) {
                            sh "terraform apply -auto-approve -no-color -var-file=input-${ENVIRONMENT}.tfvars > output-${ENVIRONMENT}-${COMMIT_HASH}.txt"
                            sh "aws s3 --profile keshaun cp output-${ENVIRONMENT}-${COMMIT_HASH}.txt s3://${BUCKET_KWI}/output/"
                        } else {
                            error("No changes to be made to Terraform infrastructure.")
                        }
                    }
                }
            }
        }
    }

    post {
        always {
            sh "rm ${TEST_DIR}/go.mod"
            sh "rm ${TEST_DIR}/go.sum"
            sh "rm ${TEST_DIR}/aws_infrastructure_testdata.json"
            sh "rm ${ENVIRONMENT}/backend-${ENVIRONMENT}.hcl"
            sh "rm ${ENVIRONMENT}/output-${ENVIRONMENT}-${COMMIT_HASH}.txt"
        }
    }
}