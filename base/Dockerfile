ARG IMAGE_USER_ID
# Start with the official NGINX image
FROM nginxinc/nginx-unprivileged:stable-alpine
# uid=101(nginx) gid=101(nginx) groups=101(nginx)
LABEL org.opencontainers.image.source = "https://github.com/devbot-cloud/DocuKube"
LABEL CONTAINER_REPO="ghcr.io/devbot-cloud/docukube-cluster-api"
# Configure container as root
USER root

# Change the ownership of the NGINX directories to the non-root user
RUN chown -R ${IMAGE_USER_ID}:nginx /var/cache/nginx /var/log/nginx /var/run /usr/share/nginx/html

# # # Copy the NGINX configuration file
# COPY --chown=${IMAGE_USER_ID}:nginx ./nginx.conf /etc/nginx/nginx.conf

# Switch to the non-root user
USER ${IMAGE_USER_ID}
ENV USER_ID=${IMAGE_USER_ID}
ENV GROUP_ID=nginx
# Expose the port NGINX will run on
EXPOSE 8080

# Start NGINX
CMD ["nginx", "-g", "daemon off;"]
