# ---- build ----
FROM golang:1.23-alpine AS build
WORKDIR /app
RUN apk add --no-cache git ca-certificates && update-ca-certificates

# copy module files first for caching
COPY go.mod ./
COPY go.sum ./
RUN go mod download

# copy source and build
COPY . .
ENV CGO_ENABLED=0
RUN go build -o main main.go

# ---- runtime ----
FROM alpine:3.20
WORKDIR /app
RUN apk add --no-cache ca-certificates && update-ca-certificates
COPY --from=build /app/main /app/main
EXPOSE 6768
CMD ["./main"]
