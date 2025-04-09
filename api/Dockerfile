FROM golang:1.24-alpine AS builder

WORKDIR /src

COPY go.mod go.sum ./

RUN go mod download

COPY api ./api

RUN CGO_ENABLED=0 go build -ldflags="-s -w" -o /usr/local/bin/bookshelf ./api/cmd/main.go

FROM gcr.io/distroless/static-debian11

WORKDIR /app

COPY --from=builder /usr/local/bin/bookshelf /usr/local/bin/bookshelf

COPY --from=builder /src/api/internal/config/yaml ./internal/config/yaml

EXPOSE 8080

ENTRYPOINT ["bookshelf"] 
