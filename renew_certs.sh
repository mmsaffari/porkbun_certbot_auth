#!/bin/bash
certbot certonly \
	--manual \
	--preferred-challenges dns \
	--manual-auth-hook /usr/local/etc/certbot/porkbun_auth.sh \
	--manual-cleanup-hook /usr/local/etc/certbot/porkbun_cleanup.sh \
	--agree-tos \
	-m youremail@yourdomain.tld \
	-d example.com \
	-d *.example.com
