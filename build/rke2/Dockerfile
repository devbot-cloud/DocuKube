ARG IMAGE_USER_ID
ARG BASE_IMAGE
FROM node:lts-alpine3.16 as builder
# RUN apk add --no-cache git \
#     && git clone https://github.com/rancher/rke2-docs.git /rke2-docs \
#     && cd /rke2-docs \
#     && yarn install --frozen-lockfile \
#     && yarn build

FROM ${BASE_IMAGE}
COPY --from=builder --chown=${IMAGE_USER_ID}:nginx /rke2-docs/build /usr/share/nginx/html