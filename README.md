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
3. Update `ORDER_ENDPOINT` inside `shawarma-order-menu.html` with the Worker URL.
4. Host the HTML page and use its URL for the NFC/QR stand.

## Security note

Do not commit Telegram bot tokens or Cloudflare secrets to this repository.
