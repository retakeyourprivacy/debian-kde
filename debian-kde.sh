#!/bin/sh

################################
# FUNCTIONS
################################

installcomment() {
    echo "'$pkg' is not yet installed on this computer. Installing '$pkg' now..."
}

installloop() {
    pkgs=(
    "cmake"
    "curl"
    "git"
    "unzip"
    "zsh"
    )

    for pkg in "${pkgs[@]}"; do
        [ ! -e /usr/bin/$pkg ] && installcomment && installpkg
    done

    installspecial
}

installpkg() {
    sudo nala install $pkg -y >/dev/null 2>&1
}

installspecial() {
    pkg="gettext" && [ ! -e /usr/lib/x86_64-linux-gnu/gettext ] \
        && installcomment && installpkg

    pkg="rg" && [ ! -e /usr/bin/$pkg ] \
        && pkg="ripgrep" && installcomment && installpkg
}

moduleloop() {
    mkdir -p modules/completed

    modules=(
    "shell.sh"
    "p10k.sh"
    "pkgs-kde.sh"
    "konsave.sh"
    #"flatpaks.sh"
    "do-thru-ui.sh"
    )

    for module in "${modules[@]}"; do
        [ -f modules/$module ] && bash modules/$module && mv modules/$module modules/completed
        [ -f modules/$module ] && echo "failed at $module!" && exit 1
    done
}

nalacheck() {
    echo "Updating package repositories..."
    [ -e /usr/bin/nala ] && sudo nala update >/dev/null 2>&1
    [ ! -e /usr/bin/nala ] && sudo apt update >/dev/null 2>&1 \
        && pkg="nala" && installcomment && sudo apt install $pkg -y >/dev/null 2>&1
}

qprofile() {
    options=(
    "Dumb Windows"
    "Tiling Window Manager"
    "Mystery third option"
    "Exit the program"
    )

    echo "This script will install a KDE Plasma desktop environment on this computer. Please choose the desktop that you would like to use. See the README.md for more information about the different options."
    PS3="Please select a number: "

    select option in "${options[@]}"; do
        case $REPLY in
            1) kdeprofile=dumbwindows; break;;
            2) kdeprofile=bismuth; break;;
            4) echo "Exiting now." && exit;;
            *) echo "Unknown response. Try again. $REPLY";;
        esac
    done

    echo "Selected '$option'" && echo
}

profilecleanup() {
    [ -f profile.knsv ] && rm profile.knsv
    cp konsave-profiles/$kdeprofile.knsv profile.knsv

    [ -f package-list ] && rm package-list
    cp package-lists/package-list-$kdeprofile package-list

    [ -d images-in-use ] && rm -r images-in-use
    cp -r image-files/$kdeprofile images-in-use
    [ -d ~/Pictures ] && mkdir -p ~/Pictures
    cp -r images-in-use ~/Pictures

    [ -f do-thru-ui.md ] && rm do-thru-ui.md
    cp do-thru-ui/do-thru-ui-$kdeprofile.md do-thru-ui.md
}

################################
# ACTUAL SCRIPT
################################

qprofile

profilecleanup

nalacheck

installloop

moduleloop

echo "Installation of debian-kde-$kdeprofile is complete!"
