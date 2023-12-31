#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source "$SCRIPT_DIR/.env"

# Strip only the top domain to get the zone id
DOMAIN=$(expr match "$CERTBOT_DOMAIN" '.*\.\(.*\..*\)')
if [ -z $DOMAIN ]; then
    DOMAIN=$CERTBOT_DOMAIN
fi
# create payload
PAYLOAD="{
	\"secretapikey\":\"$SECRET_API_KEY\",
	\"apikey\": \"$API_KEY\",
	\"name\": \"_acme-challenge\",
	\"type\": \"TXT\",
	\"content\": \"$CERTBOT_VALIDATION\"
}"
RESULT=$(curl -s -X POST "https://porkbun.com/api/json/v3/dns/create/$DOMAIN" -H "Content-Type: application/json" --data "$PAYLOAD")

RESULT_DIRNAME=/tmp/CERTBOT_$CERTBOT_DOMAIN
# Save info for cleanup
if [ ! -d $RESULT_DIRNAME ];then
        mkdir -m 0700 $RESULT_DIRNAME
fi

RESULT_SUFFIX=$(openssl rand -hex 8)
RESULT_FILE=$RESULT_DIRNAME/RESULT/$RESULT_SUFFIX
echo $RESULT > $RESULT_FILE
echo $RESULT_FILE
