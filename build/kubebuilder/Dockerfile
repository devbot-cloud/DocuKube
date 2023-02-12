FROM ubuntu as builder
RUN apt-get update && apt-get install -y git make golang-go bash curl
RUN git clone --recurse-submodules --depth 1 https://github.com/kubernetes-sigs/kubebuilder.git /kubebuilder \
    && cd /kubebuilder/docs/book/ \
    && ./install-and-build.sh

FROM nginx:1.21.3-alpine
EXPOSE 80
COPY --from=builder /kubebuilder/docs/book/book /usr/share/nginx/html
LABEL org.opencontainers.image.source = "https://github.com/devbot-cloud/DocuKube"
LABEL CONTAINER_REPO="ghcr.io/devbot-cloud/docukube-kubebuilder"