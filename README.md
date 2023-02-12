# Porkbun scripts for certbot

Issuing wildcard domain certificates with certbot, when your dns server is not one of the famous ones like CloudFlare, DigitalOcean, etc., can be a cumbersome task. Here I will try to provide a walkthrough for when you are managing your domain's DNS records on https://porkbun.com.  
There are plugins for PorkBunäs DNS challenge on `snap` or `PyPI` but connecting certbot to those plugins didn't really work for me, and moreover, why should I install more beta or RC packages when it can be solved using a couple of script files?  
Let's get our hands dirty!

## Prerequisites
These scripts use `python` to get porkbun's `record_id` of the challenge record.  
Make sure you have a globally reachable `python` installed on your machine.
``` bash
apt install python3 -y
update-alternatives --install /usr/bin/python python /usr/bin/python3 10
```

## Configure porkbun's API
1. Log into your porkbun account.
2. From the top-right `"ACCOUNT"` menu, select `"API Access"`.
3. At the bottom of the page, just the footer section, there is a text box that reads `"API Key Title"`. Write something meaningful, like `"CertbotDnsToken"`, in the box.
4. On success you'll see a green box with two significant pieces of information. Take a note of your token's `"API KEY"` and `"Secret Key"`.
5. From the `"ACCOUNT"` menu on the top right, navigate to `"Domain Management"`.
6. Find your domain and open its `"Details"` pane.
7. Enable `"API ACCESS"` (Green is enabled. Red is disabled.)

## Configure Certbot
1. Create a folder like `/usr/local/etc/certbot`
2. Copy `porkbun_cleanup.sh` and `porkbun_auth.sh` into that folder and make them executable by runing `chmod a+x /usr/local/etc/certbot/porkbun_*`
3. Edit them using your text editor of choice and set `API_KEY` and `SECRET_API_KEY` to those values you received when you created a porkbun API token in the previous section.

## Get your certificates
That's all! You should be able to fetch a new wildcard certificate for you domain as easy as running the following command. **Remeber to replace your email and domain names before running it**.

``` bash
certbot certonly \
    --manual \
    --preferred-challenges dns \
    --manual-auth-hook /usr/local/etc/certbot/porkbun_auth.sh \
    --manual-cleanup-hook /usr/local/etc/certbot/porkbun_cleanup.sh \
    --agree-tos \
    -m youremail@yourdomain.tld \
    -d example.com \
    -d *.example.com
```

Since you've provided those hooks, certbot will auto-renew your certificates for you.

Viel Spaß!

---
### Referrences:  
1. https://eff-certbot.readthedocs.io/en/stable/using.html#hooks
2. https://porkbun.com/api/json/v3/documentation
---

