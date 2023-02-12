FROM node:lts-alpine3.16 as builder
RUN apk add --no-cache git \
    && git clone https://github.com/rancher/rke2-docs.git /rke2-docs \
    && cd /rke2-docs \
    && yarn install --frozen-lockfile \
    && yarn build

FROM nginx:1.21.3-alpine 
EXPOSE 80
COPY --from=builder /rke2-docs/build /usr/share/nginx/html
LABEL org.opencontainers.image.source = "https://github.com/devbot-cloud/DocuKube"