# 🔐 acme-cloudflare-auto

A simple shell script to automate the issuance and renewal of TLS certificates using [`acme.sh`](https://github.com/acmesh-official/acme.sh) and the Cloudflare DNS API — without needing to expose any services publicly.

Perfect for securing **internal services**, **self-hosted apps**, or **home labs** using DNS-01 challenges.

---

## 📌 Problem

Issuing Let's Encrypt certificates for internal or local services (e.g., `nextcloud.example.com`) that aren't publicly accessible is normally tricky. Traditional HTTP-01 validation won't work behind NAT or firewalls.

---

## ✅ Solution

This script uses the **DNS-01 challenge** via **Cloudflare's API** to prove domain ownership. This works completely offline and allows certificates to be generated for **private subdomains** — no need to expose ports.

The script also sets up auto-renewal and installs certificates into a custom path (default: `/root/certis`).

---

## 📋 Requirements

Before running the script, make sure:

- You're running on a Linux system with:
  - `bash`
  - `curl`
- Your domain is managed by **Cloudflare**
- You have a valid:
  - **Cloudflare API Token**
  - **Cloudflare Account ID**

---

## ⚙️ Usage

```bash
chmod +x setup-acme-cloudflare.sh
sudo ./setup-acme-cloudflare.sh
```

You'll be prompted to enter:

- `🌐 Domain`: e.g., `home.akbari.cloud`
- `🔑 Cloudflare API Token`: a token with DNS edit access
- `🧾 Cloudflare Account ID`: 32-character Cloudflare account ID
- `📧 Email`: your email for ZeroSSL/Let's Encrypt registration

---

## 📦 Output

On success, certificates will be saved here:

```bash
/root/certis/your.domain.key     # Private key
/root/certis/your.domain.crt     # Full chain certificate
```

Certificates will automatically be renewed daily via cron.

---

## 🧾 Required Variables & Example

| Variable             | Description                        | Example                                     |
|----------------------|------------------------------------|---------------------------------------------|
| `DOMAIN`             | Full domain name                   | `subdomain.rootdomain.com`                      |
| `CF_Token`           | Cloudflare API Token               | `IAmAPI-TokenHoraBora`   |
| `CF_Account_ID`      | Cloudflare Account ID              | `669241312345678Examplelkjlhlskdf997eaf`          |
| `EMAIL`              | Email address for ZeroSSL account | `admin@example.com`                         |

---

## 🔄 Auto-Renewal

A cron job is automatically added by `acme.sh`:

```cron
16 8 * * * "/root/.acme.sh"/acme.sh --cron --home "/root/.acme.sh" > /dev/null
```

This ensures all your certificates stay up to date without any manual steps.

---

## 📜 License

MIT — feel free to fork, extend, or contribute!

---

## 🤝 Author

Built with ❤️ by [Naseer Akbari](https://naseer.akbari.cloud) — for self-hosters and secure private setups.
