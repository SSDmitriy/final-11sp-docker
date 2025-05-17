
# Билдер-стейдж
FROM golang:1.22.0-alpine AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY *.go ./
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o parcel_app .

# Финальный образ
FROM alpine:latest
RUN apk add --no-cache sqlite

WORKDIR /app

# бинарник и база данных
COPY --from=builder /app/parcel_app .
COPY tracker.db .

CMD ["/app/parcel_app"]
