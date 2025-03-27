
FROM golang:1.22 as builder

WORKDIR /app


COPY . .



RUN go build -o main main.go

FROM alpine:latest
WORKDIR /root/
COPY --from=builder /app/main .
EXPOSE 8080

CMD ["./main"]
