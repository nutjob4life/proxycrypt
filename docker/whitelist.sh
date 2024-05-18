#!/bin/sh -e
#
# 🕵️‍♀️ ProxyCrypt whitelist — make the whitelist.conf file
#
#
# Check essential env vars:
: ${WHITELIST:?✋ The environment variable WHITELIST is required}

# Start with an empty whitelist
cp /dev/null /etc/nginx/whitelist.conf

# Make parsing command-line go by commas
OLD_IFS="$IFS"
IFS=','
set -- $WHITELIST
IFS="$OLD_FIS"
for ip; do
    echo "allow $ip;" >> /etc/nginx/whitelist.conf
done
echo "deny all;" >> /etc/nginx/whitelist.conf

exit 0
