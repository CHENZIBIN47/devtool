FROM alpine:3.5
MAINTAINER Chan <chan@gmail.com>
ADD hello /
ENTRYPOINT ["/hello"]