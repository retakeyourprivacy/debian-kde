#!/bin/sh

################################
# FUNCTIONS
################################

installcomment() {
    echo "'$pkg' is not yet installed on this computer. Installing '$pkg' now..."
}

installloop() {
    for pkg in "${pkgs[@]}"; do
        [ ! -e /usr/bin/$pkg ] && installcomment && installpkg
    done
}

installpkg() {
    sudo nala install $pkg -y >/dev/null 2>&1
}

modulecheck() {
    [ -f modules/$module ] && echo "failed at $module" && gtfo="kthxbye" && break
    [[ $gtfo = "kthxbye" ]] && exit 1
}

modulerun() {
    [ -f modules/$module ] && bash modules/$module && mv modules/$module modules/completed
}

moduleloop() {
    for module in "${modules[@]}"; do
        modulerun && modulecheck
    done
}

################################
# PACKAGE DEPENDENCY CHECKS
################################

echo "Updating package repositories..."
[ -e /usr/bin/nala ] && sudo nala update >/dev/null 2>&1
[ ! -e /usr/bin/nala ] && sudo apt update >/dev/null 2>&1 \
    && pkg="nala" && installcomment && sudo apt install $pkg -y >/dev/null 2>&1

pkgs=(
"cmake"
"curl"
"git"
"unzip"
"zsh"
)

installloop

pkg="gettext" && [ ! -e /usr/lib/x86_64-linux-gnu/gettext ] \
    && installcomment && installpkg
pkg="rg" && [ ! -e /usr/bin/$pkg ] \
    && pkg="ripgrep" && installcomment && installpkg

################################
# MODULES
################################

mkdir -p modules/completed

modules=(
"shell.sh"
"p10k.sh"
"pkgs-kde-bismuth.sh"
"konsave-bismuth.sh"
#"flatpaks.sh"
"do-thru-ui.sh"
)

moduleloop

echo "debian-kde-bismuth installation complete!"
