ARG IMAGE_USER_ID
ARG BASE_IMAGE
FROM klakegg/hugo:ext-alpine as builder
USER root
RUN apk add --no-cache git make go \
    && git clone --recurse-submodules --depth 1 https://github.com/kubernetes/minikube.git /minikube \
    && cd /minikube \
    && git submodule update --init --recursive \
    && cd site/themes/docsy && npm install \
    && npm install hugo-extended --save-dev \
    && npm install -D autoprefixer \
    && npm install -D postcss-cli \
    && npm install -D postcss \
    && cd /minikube/site \
    && npm install \
    && hugo --cleanDestinationDir --minify --environment production

FROM ${BASE_IMAGE}
COPY --from=builder --chown=${IMAGE_USER_ID}:nginx /minikube/site/public /usr/share/nginx/html