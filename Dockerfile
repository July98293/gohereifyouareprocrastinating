# ---- build ----
FROM golang:1.23-alpine AS build
WORKDIR /app
RUN apk add --no-cache ca-certificates && update-ca-certificates

# copy module files + vendor first (cache-friendly)
COPY go.mod go.sum ./
COPY vendor/ ./vendor/

# copy source and build using vendor mode
COPY . .
ENV CGO_ENABLED=0
RUN go build -mod=vendor -o main main.go

# ---- runtime ----
FROM alpine:3.20
WORKDIR /app
RUN apk add --no-cache ca-certificates && update-ca-certificates
COPY --from=build /app/main /app/main
EXPOSE 6768
CMD ["./main"]
