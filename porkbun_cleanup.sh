#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source "$SCRIPT_DIR/.env"

RESULT_FILE=$CERTBOT_AUTH_OUTPUT

# Has there been a successful record creation?
if [ -f $RESULT_FILE ]; then
        RESULT=$(cat $RESULT_FILE)
        rm -f $RESULT_FILE
        RECORD_ID=$(echo $RESULT | jq -r .id)
else
    echo "$RESULT_FILE does not exist."
    echo "Aborting."
    exit 1
fi
# Strip only the top domain to get the zone id
DOMAIN=$(expr match "$CERTBOT_DOMAIN" '.*\.\(.*\..*\)')
if [ -z $DOMAIN ]; then
    DOMAIN=$CERTBOT_DOMAIN
fi
# create payload
PAYLOAD="{
	\"secretapikey\":\"$SECRET_API_KEY\",
	\"apikey\": \"$API_KEY\"
}"
# Remove the challenge TXT record from the zone
if [ -n "${RECORD_ID}" ]; then
    CLEANUP_RESULT=$(curl -s -X POST "https://porkbun.com/api/json/v3/dns/delete/$DOMAIN/$RECORD_ID" -H "Content-Type: application/json" --data "$PAYLOAD")
    echo $CLEANUP_RESULT > /tmp/CERTBOT_$CERTBOT_DOMAIN/CLEANUP_RESULT
fi