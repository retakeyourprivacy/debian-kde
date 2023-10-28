#!/bin/sh

# variables
script="$pkg is not installed on this computer. Installing $pkg now..."
installpkg="sudo nala install $pkg -y >/dev/null 2>&1"

# Package dependency checks
echo "Updating package repositories..."
[ -e /usr/bin/nala ] && sudo nala update >/dev/null 2>&1
[ ! -e /usr/bin/nala ] && sudo apt update >/dev/null 2>&1 && echo "$script" && sudo apt install nala -y >/dev/null 2>&1

pkgs=(
"cmake"
"curl"
"git"
"unzip"
"zsh"
)

for pkg in "${pkgs[@]}"; do
    [ ! -e /usr/bin/$pkg ] && echo "$script" && $installpkg
done

pkg="gettext" && [ ! -e /usr/lib/x86_64-linux-gnu/gettext ] && echo "$script" && $installpkg
pkg="rg" && [ ! -e /usr/bin/$pkg ] && pkg="ripgrep" && echo "$script" && $installpkg

# Installation of modules
mkdir -p modules/completed

modules=(
"shell.sh"
"p10k.sh"
"pkgs-kde-bismuth.sh"
"konsave-bismuth.sh"
#"flatpaks.sh"
"do-thru-ui.sh"
)

for module in "${modules[@]}"; do
    [ -f modules/$module ] && bash modules/$module && mv modules/$module modules/completed
    [ -f modules/$module ] && echo "failed at $module" && gtfo="kthxbye" && break
done

[[ $gtfo = "kthxbye" ]] && exit 1

echo "debian-kde-bismuth installation complete!"
