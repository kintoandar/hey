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

build:
	$(GOBUILD) -o $(BINARY_NAME) -v

# Cross compilation
build-linux:
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 $(GOBUILD) -a -installsuffix cgo -ldflags="-w -s" -o $(BINARY_NAME) -v

.PHONY: all build fmt test clean run deps build-linux
