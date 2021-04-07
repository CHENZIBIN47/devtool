FROM alpine
MAINTAINER Chan <chan@gmail.com>
ADD hello /
ENTRYPOINT ["/hello"]