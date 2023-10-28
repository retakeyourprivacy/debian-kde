#!/bin/sh

# sets up flatpak to reference the flathub repos
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

flatinstall="flatpak install flathub"

# flatpak for Flatseal, Discord, Spotify, and Windows XP Pinball
$flatinstall com.github.tchx84.Flatseal
$flatinstall com.discordapp.Discord
$flatinstall com.spotify.Client
$flatinstall com.github.k4zmu2a.spacecadetpinball
