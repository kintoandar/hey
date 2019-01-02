FROM golang:alpine AS builder
RUN apk update && apk add --no-cache git
RUN mkdir -p "$GOPATH/src/build"
COPY . $GOPATH/src/build
WORKDIR $GOPATH/src/build
RUN go get -d -v
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -ldflags="-w -s" -o hey
RUN mv "$GOPATH/src/build/hey" /
FROM scratch
COPY --from=builder /hey /bin/
EXPOSE 8000
ENTRYPOINT [ "/bin/hey" ]
