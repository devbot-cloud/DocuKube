FROM klakegg/hugo:ext-alpine as builder
USER root
RUN apk add --no-cache git \
    && git clone --recurse-submodules --depth 1 https://github.com/kubernetes-sigs/kind.git /kind \
    && cd /kind \
    && git submodule update --init --recursive \
    && cd /kind/site \
    && hugo --cleanDestinationDir --minify --environment production

FROM nginx:1.21.3-alpine
EXPOSE 80
COPY --from=builder /kind/site/public /usr/share/nginx/html
LABEL org.opencontainers.image.source = "https://github.com/devbot-cloud/DocuKube"
LABEL CONTAINER_REPO="ghcr.io/devbot-cloud/docukube-kind"