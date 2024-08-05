ARG IMAGE_USER_ID
ARG BASE_IMAGE
FROM ubuntu as builder
RUN apt-get update && apt-get install -y git make golang-go bash curl \
    && git clone https://github.com/kubernetes-sigs/cluster-api.git /cluster-api \
    && cd /cluster-api \
    && git submodule update --init --recursive \
    && make build-book
FROM ${BASE_IMAGE}
ARG IMAGE_USER_ID
COPY --from=builder --chown=${IMAGE_USER_ID}:nginx /cluster-api/docs/book/book /usr/share/nginx/html