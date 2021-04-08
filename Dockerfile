FROM hub.chan.com/dev/golang:1.13 as build
ENV GOPROXY https://goproxy.io
ENV GO111MODULE on
ENV GOSUMDB off

WORKDIR /go/cache
ADD go.mod .
ADD go.sum .
RUN go mod download
WORKDIR /go/release
ADD . .
RUN GOOS=linux CGO_ENABLED=0 go build -ldflags="-s -w" -installsuffix cgo -o devtool main.go

FROM scratch as prod
COPY --from=build /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
COPY --from=build /go/release/devtool /
COPY --from=build /go/release/conf ./conf
CMD ["/devtool"]