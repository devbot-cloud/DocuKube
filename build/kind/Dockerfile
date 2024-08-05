ARG IMAGE_USER_ID
ARG BASE_IMAGE
FROM klakegg/hugo:ext-alpine as builder
USER root
RUN apk add --no-cache git \
    && git clone --recurse-submodules --depth 1 https://github.com/kubernetes-sigs/kind.git /kind \
    && cd /kind \
    && git submodule update --init --recursive \
    && cd /kind/site \
    && hugo --cleanDestinationDir --minify --environment production

FROM ${BASE_IMAGE}
COPY --from=builder --chown=${IMAGE_USER_ID}:nginx /kind/site/public /usr/share/nginx/html