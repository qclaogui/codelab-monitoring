FROM golang:1.24-alpine AS builder

WORKDIR /workspace

COPY go.mod go.sum ./
RUN go mod download

COPY ./ ./
RUN CGO_ENABLED=0 go build -o app main.go

FROM alpine:3.21
COPY --from=builder /workspace/app /usr/local/bin/app
CMD ["app"]