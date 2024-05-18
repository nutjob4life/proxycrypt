#!/bin/sh -e
#
# 🕵️‍♀️ ProxyCrypt whitelist — make the whitelist.conf file
#
#
# Check essential env vars:
: ${WHITELIST:?✋ The environment variable WHITELIST is required}

rm -f /etc/nginx/whitelist.conf && touch /etc/nginx/whitelist.conf

OLD_IFS="$IFS"
IFS=','
set -- $WHITELIST
IFS="$OLD_FIS"
for ip; do
    echo "allow $ip;" >> /etc/nginx/whitelist.conf
done
echo "deny all;" >> /etc/nginx/whitelist.conf

exit 0
