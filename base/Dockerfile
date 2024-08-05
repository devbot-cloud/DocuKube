ARG IMAGE_USER_ID
ARG IMAGE_VERSION
ARG BUILD_DATE

# Start with the official NGINX image
FROM nginxinc/nginx-unprivileged:stable-alpine

# uid=101(nginx) gid=101(nginx) groups=101(nginx)
LABEL org.opencontainers.image.source="https://github.com/devbot-cloud/DocuKube"
LABEL org.opencontainers.image.version="${IMAGE_VERSION}"
LABEL org.opencontainers.image.created="${BUILD_DATE}"
LABEL org.opencontainers.image.title="DocuKube Base Image"
LABEL org.opencontainers.image.description="This is the base image for the DocuKube project, built with NGINX running as a non-root user."
LABEL org.opencontainers.image.licenses="Apache-2.0"
# Configure container as root
USER root

# Change the ownership of the NGINX directories to the non-root user
RUN chown -R ${IMAGE_USER_ID}:nginx /var/cache/nginx /var/log/nginx /var/run /usr/share/nginx/html

# Set environment variables
ENV USER_ID=${IMAGE_USER_ID}
ENV GROUP_ID=nginx
ENV IMAGE_VERSION=${IMAGE_VERSION}
ENV BUILD_DATE=${BUILD_DATE}

# Switch to the non-root user
USER ${IMAGE_USER_ID}
ENV USER_ID=${IMAGE_USER_ID}
ENV GROUP_ID=nginx
# Expose the port NGINX will run on
EXPOSE 8080

# Start NGINX
CMD ["nginx", "-g", "daemon off;"]
