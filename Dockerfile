FROM haproxy:1.7-alpine

RUN apk update && apk --no-cache add bash

ARG DOCKER_GEN_VERSION_ARG=0.7.5-rc1
ENV DOCKER_GEN_VERSION $DOCKER_GEN_VERSION_ARG

ARG OS_ARG=linux
ENV OS $OS_ARG

ARG ARCH_ARG=amd64
ENV ARCH $ARCH_ARG

ADD https://github.com/ocean/docker-gen/releases/download/$DOCKER_GEN_VERSION/docker-gen-$OS-$ARCH-$DOCKER_GEN_VERSION.tar.gz /tmp/docker-gen.tar.gz

RUN tar -C /usr/local/bin -xvzf /tmp/docker-gen.tar.gz && \
    chmod +x /usr/local/bin/docker-gen

COPY . /app/
WORKDIR /app/

ENV DOCKER_HOST unix:///tmp/docker.sock
ENTRYPOINT ["/app/docker-entrypoint.sh"]
CMD ["/app/haproxy_start.sh"]
EXPOSE 80 443
