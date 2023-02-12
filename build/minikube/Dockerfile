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

FROM nginx:1.21.3-alpine
EXPOSE 80
COPY --from=builder /minikube/site/public /usr/share/nginx/html
LABEL org.opencontainers.image.source = "https://github.com/devbot-cloud/DocuKube"
LABEL CONTAINER_REPO="ghcr.io/devbot-cloud/docukube-minikube"