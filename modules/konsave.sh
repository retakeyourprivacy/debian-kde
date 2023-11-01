#!/bin/sh

# install `konsave` into a new python3 virtual environment
python3 -m venv ~/.local/bin/python3
~/.local/bin/python3/bin/python3 -m pip install konsave

# use `sed` or `tee` to add `konsave` alias to the end of the aliasrc file
echo -e '\nalias konsave="~/.local/bin/python3/bin/konsave"' >> ~/.config/shell/aliasrc

# use `konsave` to import and apply the tiling window manager setup
~/.local/bin/python3/bin/konsave -i profile.knsv
~/.local/bin/python3/bin/konsave -a profile
rm ~/.config/konsave/conf.yaml
