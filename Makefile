# Go parameters
BINARY_NAME ?= hey

GOCMD=go
GOBUILD=$(GOCMD) build
GOFMT=$(GOCMD) fmt
GOCLEAN=$(GOCMD) clean
GOTEST=$(GOCMD) vet
GOGET=$(GOCMD) get

all: deps test fmt build

fmt:
	$(GOFMT) .

test:
	$(GOTEST) .

clean:
	$(GOCLEAN)
	rm -f $(BINARY_NAME)

run:
	$(GOBUILD) -o $(BINARY_NAME) -v ./...
	./$(BINARY_NAME)

deps:
	$(GOGET) .

# Cross compilation
build:
	CGO_ENABLED=0 GOOS=linux GODEBUG=netdns=go GOARCH=amd64 $(GOBUILD) -o $(BINARY_NAME) -v

build-native:
	$(GOBUILD) -o $(BINARY_NAME) -v

.PHONY: all build fmt test clean run deps build-linux
