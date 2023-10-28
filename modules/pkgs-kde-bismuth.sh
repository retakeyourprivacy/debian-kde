#!/bin/sh

# Packages for Debian-KDE using `kwin-bismuth`, a tiling window manager (like `dwm`):
# NB: 'neovim' has been removed because the version on the Debian repos is too old

while read pkg; do
    echo "$pkg is not installed on this computer. Installing $pkg now..."
    sudo nala install $pkg -y
done < package-list
