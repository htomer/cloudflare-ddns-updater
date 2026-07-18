#!/bin/bash

checkForVariable() {
    if [[ -z ${!1+set} ]]; then
       echo "Error: Define $1 environment variable"
       exit 1
    fi
}

# check environment variables.
checkForVariable EMAIL
checkForVariable KEY
checkForVariable ZONE
checkForVariable RECORD
checkForVariable METHOD

# Script to use environment variables
sed -i \
    -e "s|^auth_email=.*|auth_email=\"$EMAIL\"|" \
    -e "s|^auth_method=.*|auth_method=\"$METHOD\"|" \
    -e "s|^auth_key=.*|auth_key=\"$KEY\"|" \
    -e "s|^zone_identifier=.*|zone_identifier=\"$ZONE\"|" \
    -e "s|^record_name=.*|record_name=\"$RECORD\"|" \
    -e "s|^proxy=.*|proxy=\"$PROXY\"|" \
    /cloudflare/cloudflare.sh

# Save environment values.
printenv | grep -v "no_proxy" >> /etc/environment

# Create necessary directories and files.
mkdir -p /var/log
touch /var/log/messages

# Initialize cron job.
rsyslogd && crond && tail -f /var/log/messages