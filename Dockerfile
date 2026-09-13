FROM golang:1.27

RUN apk add --no-cache git curl

RUN go install ://github.com && \
    go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.33.0 && \
    go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.3.0

WORKDIR /src

COPY go.mod go.sum ./
RUN go mod download

COPY proto/ ./proto/
COPY buf.gen.yaml ./
COPY . .

RUN buf generate

RUN CGO_ENABLED=0 GOOS=linux go build -o /app/server ./cmd/server/main.go


FROM alpine:3.21 AS runner

WORKDIR /app

COPY --from=builder /app/server .

EXPOSE 50051

CMD ["./server"]