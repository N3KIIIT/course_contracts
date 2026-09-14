FROM golang:latest

ARG PROTOC_VERSION=36.1

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        unzip \
        curl \
        git && \
    rm -rf /var/lib/apt/lists/*

RUN curl -fsSL \
        "https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOC_VERSION}/protoc-${PROTOC_VERSION}-linux-x86_64.zip" \
        -o /tmp/protoc.zip && \
    unzip /tmp/protoc.zip -d /usr/local && \
    rm /tmp/protoc.zip

RUN mkdir -p /usr/local/include/googleapis && \
    git clone \
        --depth=1 \
        https://github.com/googleapis/googleapis.git \
        /usr/local/include/googleapis

RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@latest && \
    go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

ENV PATH="/go/bin:${PATH}"

WORKDIR /app