#!/bin/sh

################################
# FUNCTIONS
################################

paks=(
"com.github.tchx84.Flatseal"
"com.discordapp.Discord"
"com.spotify.Client"
"com.github.k4zmu2a.spacecadetpinball"
)

flatinstall() {
    for pak in "${paks[@]}"; do
        flatpak install flathub $pak -y
    done
}

################################
# ACTUAL SCRIPT
################################

# sets up flatpak to reference the flathub repos
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

flatinstall
