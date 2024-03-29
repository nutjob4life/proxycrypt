# 🕵️‍♀️ ProxyCrypt
# =============
#
# Simple image based on Nginx and Alpine: ProxyCrypt adds OpenSSL and some custom configuration.

FROM nginx:1.21.6-alpine


# Default env vars
# ----------------
#
# - CERT_CN: "common name" to use in the random certificate's subject
# - PROXY_REDIRECT: How Nginx should rewrite "Location" and "Refresh" headers
#
# Other variables used but not listed here:
#
# - CERT_DAYS: How long the random certificate is good for; defaults to 365
# - PROXY_URL: Where to send upstream requests; this is **required**
# - PROXY_PATH: Path exposed on the proxy, from which to call the service; this is **required** 

ENV CERT_CN=localhost
ENV PROXY_REDIRECT=default


# Image construction
# ------------------
#
# Just add OpenSSL, Nginx config, and our custom entrypoint.

RUN : &&\
    /sbin/apk update --quiet &&\
    /sbin/apk add --no-progress --quiet openssl &&\
    /bin/rm -rf /var/cache/apk/* &&\
    :
COPY etc/nginx.conf /etc/nginx/
COPY etc/default.conf.template /etc/nginx/templates/
COPY docker/entrypoint.sh /
COPY docker/whitelist.sh /


# Entrypoint
# ----------
#
# Speaking of that custom entrypoint…

ENTRYPOINT ["/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]


# Metadata
# --------

EXPOSE 443
LABEL "org.label-schema.name"="ProxyCrypt"
LABEL "org.label-schema.description"="SSL/TLS termination for upstream services"
LABEL "org.label-schema.version"="1.0.0"
