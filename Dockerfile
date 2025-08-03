
# 使用官方Python基础镜像
FROM python:3.10-slim-bookworm

WORKDIR /app
RUN apt-get update && apt-get install -y \
    wget build-essential cmake git libopenblas-dev pkg-config \
    && rm -rf /var/lib/apt/lists/*

# 安装带OpenBLAS支持的llama-cpp
RUN pip install --no-cache-dir --upgrade pip && \
    CMAKE_ARGS="-DLLAMA_BLAS=ON -DLLAMA_BLAS_VENDOR=OpenBLAS" \
    pip install llama-cpp-python==0.2.23 --verbose

# 下载量化模型
RUN wget https://huggingface.co/TheBloke/Mistral-7B-Instruct-v0.1-GGUF/resolve/main/mistral-7b-instruct-v0.1.Q4_K_M.gguf \
    -O /app/model.gguf

COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .

EXPOSE 8000
CMD ["uvicorn", "server:app", "--host", "0.0.0.0", "--port", "8000"]
