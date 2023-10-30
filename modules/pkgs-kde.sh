#!/bin/sh

while read pkg; do
    echo "'$pkg' is not yet installed on this computer. Installing '$pkg' now..."
    sudo nala install $pkg -y >/dev/null 2>&1
done < package-list
