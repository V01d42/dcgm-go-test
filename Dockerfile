FROM nvidia/cuda:11.8.0-base-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive

# DCGM(datacenter-gpu-manager) と Go を入れる
RUN apt-get update && apt-get install -y --no-install-recommends \
      gnupg2 curl ca-certificates build-essential && \
    curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/3bf863cc.pub | apt-key add - && \
    echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64 /" > /etc/apt/sources.list.d/cuda.list && \
    echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu2204/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list && \
    apt-get update && apt-get install -y --no-install-recommends datacenter-gpu-manager && \
    curl -s https://go.dev/dl/go1.22.3.linux-amd64.tar.gz | tar -C /usr/local -xz && \
    rm -rf /var/lib/apt/lists/*

ENV PATH="/usr/local/go/bin:${PATH}"

WORKDIR /app

# 依存解決
COPY go.mod go.sum ./
RUN go mod download

# ソースコピー & ビルド
COPY . .
RUN go build -o dcgm-go-test

CMD ["/app/dcgm-go-test"]