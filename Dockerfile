FROM golang:1.13

RUN apt-get update && \
    apt-get install -y unzip;

ENV GO111MODULE=on
ENV PROTOC_VERSION 3.9.1
ENV PROTOC_GEN_GO_VERSION v1.3.2
ENV GRPC_WEB_VERSION 1.0.7

RUN curl -OL https://github.com/protocolbuffers/protobuf/releases/download/v$PROTOC_VERSION/protoc-$PROTOC_VERSION-linux-x86_64.zip && \
    unzip -o protoc-$PROTOC_VERSION-linux-x86_64.zip -d /usr/local bin/protoc && \
    unzip -o protoc-$PROTOC_VERSION-linux-x86_64.zip -d /usr/local include/* && \
    rm -rf protoc-$PROTOC_VERSION-linux-x86_64.zip

RUN go get -u github.com/golang/protobuf/protoc-gen-go@$PROTOC_GEN_GO_VERSION && \
    go get -u github.com/gogo/protobuf/proto && \
    go get -u github.com/gogo/protobuf/gogoproto && \
    go get -u github.com/gogo/protobuf/protoc-gen-gofast && \
    go get -u github.com/gogo/protobuf/protoc-gen-gogo && \
    go get -u github.com/gogo/protobuf/protoc-gen-gogofast && \
    go get -u github.com/gogo/protobuf/protoc-gen-gogofaster && \
    go get -u github.com/gogo/protobuf/protoc-gen-gogoslick && \
    go get -u github.com/pseudomuto/protoc-gen-doc/cmd/protoc-gen-doc && \
    go get -u github.com/grpc-ecosystem/grpc-gateway/protoc-gen-grpc-gateway && \
    go get -u github.com/grpc-ecosystem/grpc-gateway/protoc-gen-swagger && \
    go get -u github.com/micro/protoc-gen-micro

RUN mkdir -p /go/src/github.com/google && \
    git clone --branch master https://github.com/google/protobuf /go/src/github.com/google/protobuf && \
    git clone --branch master https://github.com/openconfig/gnmi /go/src/github.com/openconfig/gnmi && \
    mkdir -p /go/src/github.com/ &&\
    wget "https://github.com/grpc/grpc-web/releases/download/$GRPC_WEB_VERSION/protoc-gen-grpc-web-$GRPC_WEB_VERSION-linux-x86_64" --quiet && \
    mv protoc-gen-grpc-web-$GRPC_WEB_VERSION-linux-x86_64 /usr/local/bin/protoc-gen-grpc-web && \
    chmod +x /usr/local/bin/protoc-gen-grpc-web

ENV DOCKER_VERSION 19.03.5
RUN curl -O https://download.docker.com/linux/static/stable/x86_64/docker-$DOCKER_VERSION.tgz \
    && tar zxvf docker-$DOCKER_VERSION.tgz \
    && cp docker/docker /usr/local/bin/ \
    && rm -rf docker docker-$DOCKER_VERSION.tgz

WORKDIR "/go/src/github.com/"

RUN echo "dash dash/sh boolean false" | debconf-set-selections
