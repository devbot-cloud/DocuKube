ARG IMAGE_USER_ID
ARG BASE_IMAGE
FROM gcr.io/k8s-staging-sig-docs/k8s-website-hugo:v0.101.0-1391af4d7df4 as builder
USER root
ENV KUBERNETES_VERSION=release-1.28
RUN apk add --no-cache git make \
    && git clone https://github.com/kubernetes/website.git /src \
    && cd /src \
    && git checkout ${KUBERNETES_VERSION} \
    && make module-init \
    && npm install postcss-cli \
    && hugo --cleanDestinationDir --minify --environment production

FROM ${BASE_IMAGE}
COPY --from=builder --chown=${IMAGE_USER_ID}:nginx /src/public /usr/share/nginx/html