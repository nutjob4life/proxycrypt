#!/bin/sh -e
#
# 🕵️‍♀️ ProxyCrypt entrypoint — This is invoked at container startup.
#
#
# Check essential env vars:
: ${PROXY_URL:?✋ The environment variable PROXY_URL is required}


# "Reasonable" defaults:
CERT_CN=${CERT_CN:-localhost}
CERT_DAYS=${CERT_DAYS:-365}


# Make a random self-signed certificate
/bin/rm -f /etc/ssl/self.key /etc/ssl/self.cert
/usr/bin/openssl req -nodes -x509 -days ${CERT_DAYS} -newkey rsa:2048 \
    -keyout /etc/ssl/self.key -out /etc/ssl/self.cert \
    -subj "/C=US/ST=Texas/L=Crafty Stream/O=Minecraft/CN=${CERT_CN}"


# Handle whitelisting, if any
if [ "$WHITELIST"x != "x" ]; then
    /whitelist.sh
else
    cp /dev/null /etc/nginx/whitelist.conf
fi


# Turn things over to Nginx
exec /docker-entrypoint.sh "$@"
