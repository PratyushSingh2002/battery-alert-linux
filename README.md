# Battery Alert Linux

A lightweight Bash + systemd battery monitoring service for Linux that sends notifications when battery reaches a threshold while charging.

## Features

- Monitors battery percentage
- Alerts when battery reaches 80% while charging
- Repeats notification until charger is unplugged
- Optional sound alert
- Auto-starts on login using systemd user service
- Restarts automatically if it crashes

---

## Requirements

- Linux (tested on Ubuntu/GNOME)
- `bash`
- `systemd`
- `notify-send`
- Optional: `paplay`

Install dependencies:

```bash
sudo apt install libnotify-bin pulseaudio-utils
```

---

## Installation

### 1. Clone repository

```bash
git clone https://github.com/YOUR_USERNAME/battery-alert-linux.git
cd battery-alert-linux
```

### 2. Make script executable

```bash
chmod +x battery_alert.sh
```

### 3. Copy script

```bash
mkdir -p ~/.local/bin
cp battery_alert.sh ~/.local/bin/
```

### 4. Copy systemd service

```bash
mkdir -p ~/.config/systemd/user
cp systemd/battery-alert.service ~/.config/systemd/user/
```

### 5. Reload systemd

```bash
systemctl --user daemon-reload
```

### 6. Enable and start service

```bash
systemctl --user enable --now battery-alert.service
```

This will:
- Start immediately
- Auto-start on every login

---

## Check Status

```bash
systemctl --user status battery-alert.service
```

Expected output:
```bash
active (running)
```

---

## View Logs

```bash
journalctl --user -u battery-alert.service -f
```

---

## Restart Service

After editing the script:

```bash
systemctl --user restart battery-alert.service
```

---

## Stop Service

```bash
systemctl --user stop battery-alert.service
```

Disable auto-start:

```bash
systemctl --user disable battery-alert.service
```

---

## Configuration

### Change Battery Threshold

Edit `battery_alert.sh`:

```bash
THRESHOLD=80
```

Examples:
- `70` → alert at 70%
- `85` → alert at 85%

### Battery Path

Default:
```bash
BATTERY="/sys/class/power_supply/BAT0"
```

Check available power devices:
```bash
ls /sys/class/power_supply/
```

---

## How It Works

The script continuously checks:
- Battery percentage
- Charging status

If:
- Battery >= threshold
- Status = `Charging`

Then it:
- Sends a critical desktop notification
- Optionally plays sound
- Repeats every 20 seconds
- Stops once charger is unplugged (`Discharging`)

---

## Uninstall

```bash
systemctl --user disable --now battery-alert.service
rm ~/.config/systemd/user/battery-alert.service
rm ~/.local/bin/battery_alert.sh
systemctl --user daemon-reload
```

---

## Notes

This project does **not** physically stop battery charging.  
It only notifies the user.

Actual charge limiting depends on laptop firmware / BIOS support.
