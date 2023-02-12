FROM gcr.io/k8s-staging-sig-docs/k8s-website-hugo:v0.101.0-1391af4d7df4 as builder
USER root
RUN apk add --no-cache git make \
    && git clone https://github.com/kubernetes/website.git /src \
    && cd /src \
    && make module-init \
    && npm install postcss-cli \
    && hugo --cleanDestinationDir --minify --environment production

FROM nginx:1.21.3-alpine
EXPOSE 80
COPY --from=builder /src/public /usr/share/nginx/html
LABEL org.opencontainers.image.source = "https://github.com/devbot-cloud/DocuKube"
