all: build push clean
.PHONY: build push clean

TAG = v1

# Build for linux amd64
build:
    GOOS=linux GOARCH=amd64 go build -o hello${TAG} main.go
    docker build -t chan.harbor.com/library/hello:${TAG} .

push:
    docker push chan.harbor.com/library/hello:${TAG}

# Clean 
clean:
	rm -f hello${TAG}