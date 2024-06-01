# debian-kde

This script is an installer for KDE Plasma systems. It includes a handful of `konsave` profiles.

1. `Not Windows` is a desktop that looks and feels a lot like Windows.
2. `bismuth` is a tiling window manager setup.

Note: This script should be run as the primary local user for the computer; e.g., not as the root user.

```
apt update && apt install -y git
mkdir -pv ~/.local/src && cd ~/.local/src
git clone https://github.com/retakeyourprivacy/debian-kde && cd ~/.local/src/debian-kde
bash debian-kde.sh
```

## KDE profiles

This script uses the following KDE profile files:

- '231024_notwindows.knsv'
- '231027_bismuth-v2.knsv'
