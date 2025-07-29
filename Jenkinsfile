// Định nghĩa một pipeline Jenkins
pipeline {
    // Chỉ định tác nhân (agent) nơi pipeline sẽ chạy.
    // 'any' nghĩa là nó có thể chạy trên bất kỳ tác nhân nào có sẵn.
    agent any

    // Các biến môi trường sẽ được sử dụng trong pipeline
    environment {
        // Tên image Docker của bạn
        DOCKER_IMAGE_NAME = 'ecommerce'
        // Cổng trên máy chủ host mà bạn muốn ánh xạ tới cổng 8080 của container
        HOST_PORT = '9000'
        // Cổng mà ứng dụng ASP.NET Core lắng nghe bên trong container
        CONTAINER_PORT = '8080'
        // Ngrok Auth Token của bạn (lấy từ ngrok.com dashboard)
        // QUAN TRỌNG: KHÔNG ĐẶT TOKEN TRỰC TIẾP VÀO ĐÂY TRONG MÔI TRƯỜNG THỰC TẾ.
        // HÃY SỬ DỤNG JENKINS CREDENTIALS HOẶC BIẾN MÔI TRƯỜNG AN TOÀN.
        NGROK_AUTH_TOKEN = '383CnOo08XQwattbp6jXTtZCO3SJK_6nbvMOGQQtgkT8jDMlENM' // <--- THAY THẾ BẰNG TOKEN CỦA BẠN
    }

    // Các giai đoạn (stages) của pipeline
    stages {
        // Giai đoạn 'Checkout Source' đã bị loại bỏ vì Jenkins tự động xử lý việc này
        // dựa trên cấu hình SCM của job.

        // Giai đoạn 2: Xây dựng Docker Image
        stage('Build Docker Image') {
            steps {
                script {
                    // Xây dựng Docker image mới
                    sh "docker build --pull -t ${DOCKER_IMAGE_NAME} ."
                }
            }
        }

        // Giai đoạn 3: Dừng và xóa Container cũ (nếu có) và Ngrok Container
        stage('Stop & Remove Old Containers') {
            steps {
                script {
                    def appContainerId = sh(script: "docker ps -aq --filter ancestor=${DOCKER_IMAGE_NAME}", returnStdout: true).trim()
                    def ngrokContainerId = sh(script: "docker ps -aq --filter name=ngrok-tunnel-container", returnStdout: true).trim()

                    if (appContainerId != "") {
                        echo "Stopping and removing old application container: ${appContainerId}"
                        sh "docker stop ${appContainerId}"
                        sh "docker rm ${appContainerId}"
                    } else {
                        echo "No old application container found to stop and remove."
                    }

                    if (ngrokContainerId != "") {
                        echo "Stopping and removing old Ngrok tunnel container: ${ngrokContainerId}"
                        sh "docker stop ${ngrokContainerId}"
                        sh "docker rm ${ngrokContainerId}"
                    } else {
                        echo "No old Ngrok tunnel container found to stop and remove."
                    }
                }
            }
        }

        // Giai đoạn 4: Chạy Container mới và Ngrok Tunnel
        stage('Run New Containers with Ngrok') {
            steps {
                script {
                    // Chạy container ứng dụng
                    sh "docker run -d -p ${HOST_PORT}:${CONTAINER_PORT} --name ${DOCKER_IMAGE_NAME}-container ${DOCKER_IMAGE_NAME}"
                    echo "New application container ${DOCKER_IMAGE_NAME}-container started on http://localhost:${HOST_PORT}"

                    // Chạy container Ngrok để tạo tunnel
                    // Ngrok sẽ tunnel tới tên host của container ứng dụng (ecommrce-container)
                    // trên cổng 8080 (cổng nội bộ của ứng dụng)
                    sh "docker run -d --name ngrok-tunnel-container --link ${DOCKER_IMAGE_NAME}-container \
                        ngrok/ngrok:latest \
                        ngrok http ${DOCKER_IMAGE_NAME}-container:${CONTAINER_PORT} --authtoken ${NGROK_AUTH_TOKEN}"

                    echo "Ngrok tunnel container started. It may take a few moments for the tunnel to establish."
                    echo "To get the public Ngrok URL, run: docker logs ngrok-tunnel-container"
                    echo "Look for a line like 'url=https://<your-subdomain>.ngrok.io'"
                }
            }
        }
    }

    // Các hành động sau khi pipeline hoàn tất (thành công hoặc thất bại)
    post {
        always {
            echo "Pipeline finished."
        }
        success {
            echo "Deployment successful!"
        }
        failure {
            echo "Deployment failed!"
        }
    }
}