FROM ubuntu as builder
RUN apt-get update && apt-get install -y git make golang-go bash curl \
    && git clone https://github.com/kubernetes-sigs/cluster-api.git /cluster-api \
    && cd /cluster-api \
    && git submodule update --init --recursive \
    && make build-book

FROM nginx:1.21.3-alpine
EXPOSE 80
COPY --from=builder /cluster-api/docs/book/book /usr/share/nginx/html
# COPY book /usr/share/nginx/html
LABEL org.opencontainers.image.source = "https://github.com/devbot-cloud/DocuKube"
LABEL CONTAINER_REPO="ghcr.io/devbot-cloud/docukube-cluster-api"