ARG IMAGE_USER_ID
ARG BASE_IMAGE
FROM alpine:3.17.2 as builder
RUN apk add --no-cache bash git \
    && git clone --branch=gh-pages --depth=1 https://github.com/kubernetes/ingress-nginx.git /build

FROM ${BASE_IMAGE}
COPY --from=builder --chown=${IMAGE_USER_ID}:nginx /build /usr/share/nginx/html