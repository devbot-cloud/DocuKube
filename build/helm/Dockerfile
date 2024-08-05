ARG IMAGE_USER_ID
ARG BASE_IMAGE
FROM klakegg/hugo:ext-alpine as builder
USER root
RUN apk add --no-cache git \
    && git clone --recurse-submodules --depth 1 https://github.com/helm/helm-www.git /helm-docs \
    && cd /helm-docs \
    && yarn install --frozen-lockfile \
    && npm install \
    && npm install postcss-cli \
    && hugo --cleanDestinationDir --environment production

FROM ${BASE_IMAGE}
COPY --from=builder --chown=${IMAGE_USER_ID}:nginx /helm-docs/app /usr/share/nginx/html