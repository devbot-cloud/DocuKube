FROM alpine:3.17.2 as builder
RUN apk add --no-cache bash git \
    && git clone --branch=gh-pages --depth=1 https://github.com/kubernetes/ingress-nginx.git /build

FROM nginx:1.21.3-alpine 
EXPOSE 80
COPY --from=builder /build /usr/share/nginx/html
LABEL org.opencontainers.image.source = "https://github.com/devbot-cloud/DocuKube"
LABEL CONTAINER_REPO="ghcr.io/devbot-cloud/docukube-ingress-nginx"