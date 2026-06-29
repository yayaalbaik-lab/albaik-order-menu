; AutoHotkey v2 script for cashier order alerts.
; Enter the same value configured as CASHIER_SECRET in Cloudflare when prompted.

#Requires AutoHotkey v2.0
#SingleInstance Force

WorkerUrl := "https://albaik-worker.yayaalbaik.workers.dev"
CashierPageUrl := "https://yayaalbaik-lab.github.io/albaik-order-menu/cashier.html"
AlertSoundPath := A_ScriptDir . "\cashier-order-alert.wav"
PollMs := 2000
AlarmActive := false

secretBox := InputBox("Enter CASHIER_SECRET:", "Albaik Orders", "Password w360 h140")
if (secretBox.Result != "OK" || Trim(secretBox.Value) = "") {
  ExitApp
}

CashierSecret := Trim(secretBox.Value)
SetTimer(CheckOrders, PollMs)

CheckOrders() {
  global WorkerUrl, CashierPageUrl, CashierSecret, AlarmActive

  hasOrders := HasNewOrders(WorkerUrl, CashierSecret)
  if (hasOrders) {
    if (!AlarmActive) {
      AlarmActive := true
      Run(CashierPageUrl)
    }
    if FileExist(AlertSoundPath) {
      SoundPlay(AlertSoundPath)
    } else {
      SoundBeep(880, 350)
    }
  } else {
    AlarmActive := false
  }
}

HasNewOrders(workerUrl, secret) {
  try {
    http := ComObject("WinHttp.WinHttpRequest.5.1")
    http.Open("GET", workerUrl . "/cashier/orders", false)
    http.SetRequestHeader("Authorization", "Bearer " . secret)
    http.Send()

    if (http.Status != 200) {
      return false
    }

    body := http.ResponseText
    return InStr(body, '"orders":[{') > 0
  } catch {
    return false
  }
}
