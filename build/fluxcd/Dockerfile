FROM docker.io/fluxcd/website:hugo-0.110.0-extended as builder
RUN apk update && \
	apk add --no-cache \
	bash \
	coreutils \
	curl \
	gcc \
	grep \
	jq \
	libc-dev \
	libffi-dev \
	linux-headers \
	make \
	nodejs \
	npm \
	openssh-client \
	py3-pip \
	python3 \
	python3-dev \
	rsync \
    go \
    && git clone --recurse-submodules --depth 1 https://github.com/fluxcd/website.git /flux-docs \
    && cd /flux-docs \
    && python3 -m pip install -r requirements.txt \
    && npm install \
    && make prereqs \
    && hack/import-calendar.py \
    && hugo --cleanDestinationDir --gc --minify --enableGitInfo --environment production --buildDrafts --buildFuture

FROM nginx:1.21.3-alpine 
EXPOSE 80
COPY --from=builder /flux-docs/public /usr/share/nginx/html
LABEL org.opencontainers.image.source "https://github.com/devbot-cloud/DocuKube"
LABEL CONTAINER_REPO="ghcr.io/devbot-cloud/docukube-flux"