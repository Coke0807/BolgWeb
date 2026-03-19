# ── BolgWeb – Nginx Static Site ──────────────────────
# Build: docker build -t bolgweb .
# Run:   docker run -p 8080:80 bolgweb

FROM nginx:1.27-alpine

# Remove default nginx static content
RUN rm -rf /usr/share/nginx/html/*

# Copy blog files
COPY index.html   /usr/share/nginx/html/
COPY post.html    /usr/share/nginx/html/
COPY about.html   /usr/share/nginx/html/
COPY css/         /usr/share/nginx/html/css/
COPY js/          /usr/share/nginx/html/js/

# Copy custom nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -qO- http://localhost/ || exit 1
