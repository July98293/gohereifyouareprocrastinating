FROM golang:1.23-alpine AS build
WORKDIR /app

# Tools needed to fetch modules
RUN apk add --no-cache git ca-certificates openssh && update-ca-certificates

# Helpful Go env (tweak if you use a corporate proxy)
ENV GOPROXY=https://proxy.golang.org,direct \
    GOSUMDB=sum.golang.org \
    CGO_ENABLED=0

# Copy only module files first
COPY go.mod ./
COPY go.sum ./

# Print verbose details so we see the exact error
RUN set -eux; \
    go version; \
    go env; \
    echo "----- go.mod -----"; cat go.mod; \
    echo "----- go.sum (first 20 lines) -----"; head -n 20 go.sum || true; \
    echo "----- running go mod download -x -----"; \
    go mod download -x

# If we get here, deps resolved; now build
COPY . .
RUN go build -o main main.go

FROM alpine:3.20
WORKDIR /app
RUN apk add --no-cache ca-certificates && update-ca-certificates
COPY --from=build /app/main /app/main
EXPOSE 6768
CMD ["./main"]
