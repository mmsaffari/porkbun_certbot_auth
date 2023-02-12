#!/bin/bash
API_KEY="Your porkbun token API KEY which normally starts with pk1_"
SECRET_API_KEY="Your porkbun token Secret Key that normally starts with sk1_"
# Has there been a successful record creation?
if [ -f /tmp/CERTBOT_$CERTBOT_DOMAIN/RESULT ]; then
        RESULT=$(cat /tmp/CERTBOT_$CERTBOT_DOMAIN/RESULT)
        rm -f /tmp/CERTBOT_$CERTBOT_DOMAIN/RESULT
        RECORD_ID=$(echo $RESULT | python -c "import sys,json;print(json.load(sys.stdin)['id'])")
else
    echo "/tmp/CERTBOT_$CERTBOT_DOMAIN/RESULT does not exist."
    echo "Aborting."
    exit 1
fi
# Strip only the top domain to get the zone id
DOMAIN=$(expr match "$CERTBOT_DOMAIN" '.*\.\(.*\..*\)')
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