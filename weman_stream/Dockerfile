FROM golang:1.22-alpine AS builder
WORKDIR /app
COPY go.mod ./
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o /weman-stream cmd/server/main.go

FROM alpine:latest
WORKDIR /root/
COPY --from=builder /weman-stream .
EXPOSE 8081
CMD ["./weman-stream"]
