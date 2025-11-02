# ---- build ----
FROM golang:1.23-alpine AS build
WORKDIR /app

# tools needed for go mod download from VCS
RUN apk add --no-cache git ca-certificates && update-ca-certificates

# copy ONLY the module files first (so Docker can cache deps)
COPY go.mod ./
# copy go.sum if it exists; if you don’t have it yet, see note below
COPY go.sum . 2>/dev/null || true

RUN go mod download

# now copy the rest and build
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
