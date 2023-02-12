#!/bin/bash
API_KEY="Your porkbun token API KEY which normally starts with pk1_"
SECRET_API_KEY="Your porkbun token Secret Key that normally starts with sk1_"
# Strip only the top domain to get the zone id
DOMAIN=$(expr match "$CERTBOT_DOMAIN" '.*\.\(.*\..*\)')
# create payload
PAYLOAD="{
	\"secretapikey\":\"$SECRET_API_KEY\",
	\"apikey\": \"$API_KEY\",
	\"name\": \"_acme-challenge\",
	\"type\": \"TXT\",
	\"content\": \"$CERTBOT_VALIDATION\"
}"
RESULT=$(curl -s -X POST "https://porkbun.com/api/json/v3/dns/create/$DOMAIN" -H "Content-Type: application/json" --data "$PAYLOAD")
# Save info for cleanup
if [ ! -d /tmp/CERTBOT_$CERTBOT_DOMAIN ];then
        mkdir -m 0700 /tmp/CERTBOT_$CERTBOT_DOMAIN
fi
echo $RESULT > /tmp/CERTBOT_$CERTBOT_DOMAIN/RESULT
