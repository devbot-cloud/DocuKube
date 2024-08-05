ARG IMAGE_USER_ID
ARG BASE_IMAGE
FROM node:lts-alpine3.16 as builder
RUN apk add --no-cache git \
    && git clone https://github.com/rancher/rke2-docs.git /rke2-docs \
    && cd /rke2-docs \
    && git checkout gh-pages

FROM ${BASE_IMAGE}
ARG IMAGE_USER_ID
COPY --from=builder --chown=${IMAGE_USER_ID}:nginx /rke2-docs/ /usr/share/nginx/html