# Build Stage
FROM hub.chan.com/library/docker-alpine:golang:1.13 AS build-stage

LABEL app="build-devtool"
LABEL REPO="https://github.com/CHENZIBIN47/devtool"

ENV PROJPATH=/go/src/github.com/CHENZIBIN47/devtool

# Because of https://github.com/docker/docker/issues/14914
ENV PATH=$PATH:$GOROOT/bin:$GOPATH/bin

ADD . /go/src/github.com/CHENZIBIN47/devtool
WORKDIR /go/src/github.com/CHENZIBIN47/devtool

RUN make build-alpine

# Final Stage
FROM hub.chan.com/library/docker-alpine:latest

ARG GIT_COMMIT
ARG VERSION
LABEL REPO="https://github.com/CHENZIBIN47/devtool"
LABEL GIT_COMMIT=$GIT_COMMIT
LABEL VERSION=$VERSION

# Because of https://github.com/docker/docker/issues/14914
ENV PATH=$PATH:/opt/devtool/bin

WORKDIR /opt/devtool/bin

COPY --from=build-stage /go/src/github.com/CHENZIBIN47/devtool/bin/devtool /opt/devtool/bin/
RUN chmod +x /opt/devtool/bin/devtool

# Create appuser
RUN adduser -D -g '' devtool
USER devtool

ENTRYPOINT ["/usr/bin/dumb-init", "--"]

CMD ["/opt/devtool/bin/devtool"]
