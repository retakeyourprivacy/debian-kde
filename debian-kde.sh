#!/bin/sh

################################
# VARIABLES
################################

modules=(
"shell.sh"
"p10k.sh"
"pkgs-kde.sh"
"konsave.sh"
#"flatpaks.sh"
"do-thru-ui.sh"
)

options=(
"Not Windows"
"Tiling Window Manager"
"Mystery third option"
"Exit the program"
)

################################
# FUNCTIONS
################################

qprofile() {
    echo "This script will install a KDE Plasma desktop environment on this computer. Please choose the desktop that you would like to use. See the README.md for more information about the different options."
    PS3="Please select a number: "

    select option in "${options[@]}"; do
        case $REPLY in
            1) kdeprofile=notwindows; break;;
            2) kdeprofile=bismuth; break;;
            4) echo "Exiting now." && exit;;
            *) echo "Unknown response. Try again. $REPLY";;
        esac
    done

    echo "Selected '$option'" && echo
}

profilecleanup() {
    [ ! -d ~/.local/share/konsole ] && mkdir -p ~/.local/share/konsole
    [ ! -d ~/.local/share/kxmlgui5 ] && mkdir -p ~/.local/share/kxmlgui5

    [ -f do-thru-ui.md ] && rm do-thru-ui.md
    cp do-thru-ui/do-thru-ui-$kdeprofile.md do-thru-ui.md

    [ -f package-list ] && rm package-list
    cp package-lists/package-list-$kdeprofile package-list

    [ -f profile.knsv ] && rm profile.knsv
    cp konsave-profiles/$kdeprofile.knsv profile.knsv

    [ ! -d /data ] && sudo mkdir /data
    sudo chown $USER: /data
    [ ! -d /data/kde ] && mkdir /data/kde
    [ ! -d /data/kde/images ] && mkdir /data/kde/images

    [ -f /data/kde/images/bg.png ] && rm /data/kde/images/bg.png
    [ -f image-files/$kdeprofile/bg.png ] && cp image-files/$kdeprofile/bg.png /data/kde/images

    [ -f /data/kde/images/startmenu.png ] && rm /data/kde/images/startmenu.png
    [ -f image-files/$kdeprofile/startmenu.png ] && cp image-files/$kdeprofile/startmenu.png /data/kde/images

    [ -f /data/kde/images/usericon.png ] && rm /data/kde/images/usericon.png
    [ -f image-files/$kdeprofile/usericon.png ] && cp image-files/$kdeprofile/usericon.png /data/kde/images
}

nalacheck() {
    echo "Updating package repositories..."
    sudo apt update >/dev/null 2>&1

    [ ! -e /usr/bin/nala ] && pkg="nala" \
        && installcomment && installpkg
}
installcomment() {
    echo "Installing '$pkg' now..."
}

installloop() {
    pkgs=(
    "cmake"
    "curl"
    "git"
    "stow"
    "unzip"
    "zsh"
    )

    for pkg in "${pkgs[@]}"; do
        [ ! -e /usr/bin/$pkg ] && installcomment && installpkg
    done

    installspecial
}

installpkg() {
    sudo apt install $pkg -y >/dev/null 2>&1
}

installspecial() {
    [ ! -e /usr/lib/x86_64-linux-gnu/gettext ] && pkg="gettext" \
        && installcomment && installpkg

    [ ! -e /usr/bin/rg ] && pkg="ripgrep" \
        && installcomment && installpkg
}
moduleloop() {
    mkdir -p modules/completed

    for module in "${modules[@]}"; do
        [ -f modules/$module ] \
            && bash modules/$module && mv modules/$module modules/completed
        [ -f modules/$module ] \
            && echo "failed at $module!" && exit 1
    done
}

completiontext() {
    echo "Installation of debian-kde-$kdeprofile is complete!"
}

################################
# ACTUAL SCRIPT
################################

qprofile

profilecleanup

nalacheck

installloop

moduleloop

completiontext
