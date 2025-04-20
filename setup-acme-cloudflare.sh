#!/bin/bash

set -e

echo "🔐 Let's set up automatic TLS with Cloudflare + acme.sh"

# Ask for user input
read -rp "🌐 Enter your full domain name (e.g., naseer.akbari.cloud): " DOMAIN
read -rp "🔑 Enter your Cloudflare API Token: " CF_Token
read -rp "🧾 Enter your Cloudflare Account ID: " CF_Account_ID
read -rp "📧 Enter your email address for ZeroSSL/Let's Encrypt: " EMAIL

# Export API credentials
export CF_Token
export CF_Account_ID

# Install acme.sh if not already installed
if [ ! -f ~/.acme.sh/acme.sh ]; then
  echo "📥 Installing acme.sh..."
  curl https://get.acme.sh | sh
  source ~/.bashrc || source ~/.profile
else
  echo "✅ acme.sh is already installed."
fi

# Register account with CA
~/.acme.sh/acme.sh --register-account -m "$EMAIL"

# Issue the certificate using DNS-01
echo "📡 Issuing certificate for $DOMAIN using Cloudflare DNS..."
~/.acme.sh/acme.sh --issue --dns dns_cf -d "$DOMAIN" --dnssleep 180 --debug

# Install directories
INSTALL_DIR="/root/certis"
INSTALL_DIR2="/etc/ssl"
mkdir -p "$INSTALL_DIR" "$INSTALL_DIR2/certs" "$INSTALL_DIR2/private"

# Install the certificate to /root/certis (backup / debug use)
echo "📁 Installing certificate to $INSTALL_DIR..."
~/.acme.sh/acme.sh --install-cert -d "$DOMAIN" \
  --key-file "$INSTALL_DIR/${DOMAIN}.key" \
  --fullchain-file "$INSTALL_DIR/${DOMAIN}.crt" \
  --reloadcmd "echo '✅ Certificate for $DOMAIN installed. No reload needed.'"

# Install the certificate to /etc/ssl (system usage)
echo "🔐 Installing certificate to $INSTALL_DIR2..."
~/.acme.sh/acme.sh --install-cert -d "$DOMAIN" \
  --key-file "$INSTALL_DIR2/private/${DOMAIN}.key" \
  --fullchain-file "$INSTALL_DIR2/certs/${DOMAIN}.crt" \
  --reloadcmd "echo '✅ Certificate for $DOMAIN installed in $INSTALL_DIR2. No reload needed.'"

echo "🎉 Done! Your certificate is now ready:"
echo "  Key (Backup):       $INSTALL_DIR/${DOMAIN}.key"
echo "  Fullchain (Backup): $INSTALL_DIR/${DOMAIN}.crt"
echo "  Key (System):       $INSTALL_DIR2/private/${DOMAIN}.key"
echo "  Fullchain (System): $INSTALL_DIR2/certs/${DOMAIN}.crt"
echo
echo "🔁 Auto-renewal is already set up via cron."
