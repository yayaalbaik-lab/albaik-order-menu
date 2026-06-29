# Yahya Albaik Order Menu

A lightweight NFC/QR restaurant ordering page that sends orders to a Cloudflare Worker, which forwards them to a Telegram group.

## Files

- `shawarma-order-menu.html`: customer-facing ordering menu.
- `albaik-worker.js`: Cloudflare Worker that receives orders and sends Telegram messages.
- `cashier.html`: cashier screen for new orders and accept actions.
- `cashier-alert.ahk`: optional AutoHotkey alert script for the cashier computer.

## Setup

1. Deploy `albaik-worker.js` as a Cloudflare Worker.
2. Add these Worker secrets in Cloudflare:
   - `TELEGRAM_BOT_TOKEN`
   - `TELEGRAM_CHAT_ID`
3. Create a KV namespace for order rate limiting and bind it to the Worker as:
   - `ORDER_RATE_LIMIT_KV`
4. Add this Worker secret for the cashier screen:
   - `CASHIER_SECRET`
5. Optional: create a separate KV namespace for saved cashier orders and bind it as:
   - `ORDER_STORE_KV`
   If this is not configured, the Worker uses `ORDER_RATE_LIMIT_KV` for saved orders too.
6. Add this Worker variable to restrict browser calls to your GitHub Pages site:
   - `ALLOWED_ORIGINS=https://yayaalbaik-lab.github.io`
   - Optional for local testing: `ALLOWED_ORIGINS=https://yayaalbaik-lab.github.io,http://127.0.0.1:4174`
7. Update `ORDER_ENDPOINT` inside `shawarma-order-menu.html` with the Worker URL.
8. Host the HTML page and use its URL for the NFC/QR stand.

## Cashier screen

Open `cashier.html` on the cashier computer:

`https://yayaalbaik-lab.github.io/albaik-order-menu/cashier.html`

The cashier enters `CASHIER_SECRET` once, then the page checks for new orders every 2 seconds.
When a new order arrives, the page plays a repeated alert until the cashier clicks accept.

## AutoHotkey alert

`cashier-alert.ahk` is optional. It checks the Worker every 2 seconds, beeps when a new order exists,
and opens the cashier page above the POS. When it starts, enter the same `CASHIER_SECRET` configured
in Cloudflare.

## Rate limiting

The Worker allows 2 orders every 10 minutes from the same `IP + User-Agent + device_token` identity.
This reduces repeated or fake orders, including requests sent directly to the Worker URL.

## Security note

Do not commit Telegram bot tokens or Cloudflare secrets to this repository.
