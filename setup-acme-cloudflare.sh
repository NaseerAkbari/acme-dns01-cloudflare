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

# Install directory
INSTALL_DIR="/root/certis"
mkdir -p "$INSTALL_DIR"

# Install the certificate
echo "📁 Installing certificate to $INSTALL_DIR..."
~/.acme.sh/acme.sh --install-cert -d "$DOMAIN" \
  --key-file "$INSTALL_DIR/${DOMAIN}.key" \
  --fullchain-file "$INSTALL_DIR/${DOMAIN}.crt" \
  --reloadcmd "echo '✅ Certificate for $DOMAIN installed. No reload needed.'"

echo "🎉 Done! Your certificate is now ready:"
echo "  Key:       $INSTALL_DIR/${DOMAIN}.key"
echo "  Fullchain: $INSTALL_DIR/${DOMAIN}.crt"
echo
echo "🔁 Auto-renewal is already set up via cron."