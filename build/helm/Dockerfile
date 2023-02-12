FROM klakegg/hugo:ext-alpine as builder
USER root
RUN apk add --no-cache git \
    && git clone --recurse-submodules --depth 1 https://github.com/helm/helm-www.git /helm-docs \
    && cd /helm-docs \
    && yarn install --frozen-lockfile \
    && npm install \
    && npm install postcss-cli \
    && hugo --cleanDestinationDir --environment production

FROM nginx:1.21.3-alpine 
EXPOSE 80
COPY --from=builder /helm-docs/app /usr/share/nginx/html
LABEL org.opencontainers.image.source "https://github.com/devbot-cloud/DocuKube"
LABEL CONTAINER_REPO="ghcr.io/devbot-cloud/docukube-helm"