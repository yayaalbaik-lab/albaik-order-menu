# Yahya Albaik Order Menu

A lightweight NFC/QR restaurant ordering page that sends orders to a Cloudflare Worker, which forwards them to a Telegram group.

## Files

- `shawarma-order-menu.html`: customer-facing ordering menu.
- `albaik-worker.js`: Cloudflare Worker that receives orders and sends Telegram messages.

## Setup

1. Deploy `albaik-worker.js` as a Cloudflare Worker.
2. Add these Worker secrets in Cloudflare:
   - `TELEGRAM_BOT_TOKEN`
   - `TELEGRAM_CHAT_ID`
3. Create a KV namespace for order rate limiting and bind it to the Worker as:
   - `ORDER_RATE_LIMIT_KV`
4. Add this Worker variable to restrict browser calls to your GitHub Pages site:
   - `ALLOWED_ORIGIN=https://yayaalbaik-lab.github.io`
5. Update `ORDER_ENDPOINT` inside `shawarma-order-menu.html` with the Worker URL.
6. Host the HTML page and use its URL for the NFC/QR stand.

## Rate limiting

The Worker allows 2 orders every 10 minutes from the same `IP + User-Agent + device_token` identity.
This reduces repeated or fake orders, including requests sent directly to the Worker URL.

## Security note

Do not commit Telegram bot tokens or Cloudflare secrets to this repository.
