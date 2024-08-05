ARG IMAGE_USER_ID
ARG BASE_IMAGE
FROM klakegg/hugo:ext-ubuntu as builder
USER root
# RUN apk add --no-cache git make go
RUN apt-get update && apt-get upgrade -y && apt-get install git make golang -y
RUN wget -O hugo.tar.gz https://github.com/gohugoio/hugo/releases/download/v0.131.0/hugo_extended_0.131.0_Linux-64bit.tar.gz \
    && tar -xzf hugo.tar.gz \
    && mv hugo /usr/local/bin/hugo \
    && rm hugo.tar.gz
RUN git clone --recurse-submodules --depth 1 https://github.com/kubernetes/minikube.git /minikube \
    && cd /minikube \
    && git submodule update --init --recursive \
    && cd site/themes/docsy && npm install \
    && npm install -D autoprefixer \
    && npm install -D postcss-cli \
    && npm install -D postcss \
    && cd /minikube/site \
    && npm install
RUN cd /minikube/site && hugo --cleanDestinationDir --minify --environment production

FROM ${BASE_IMAGE}
ARG IMAGE_USER_ID
COPY --from=builder --chown=${IMAGE_USER_ID}:nginx /minikube/site/public /usr/share/nginx/html