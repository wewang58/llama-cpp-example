/bin/bash
# 构建镜像
#podman build -t mistral-api .

# 运行容器
podman run -d \
  --name mistral-service \
  -p 8000:8000 \
  --security-opt=no-new-privileges \
  --read-only \
  --tmpfs /tmp \
  quay.io/wewang58/mistral-api

# 查看日志
podman logs -f mistral-service

