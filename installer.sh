#!/bin/bash

echo "create-app installer"
mkdir -p ~/.config/create-app
wget https://raw.githubusercontent.com/afgalvan/create-app/main/create_app.sh
chmod +x create_app.sh
if [ -d "$1" ]; then
    pm="npm"
else
    pm="$1"
fi
echo "$pm" > ~/.config/create-app/default_pm

if [ -d ~/.config/create-app/create_app.sh ]; then
    rm -f ~/.config/create-app/create_app.sh
fi
mv create_app.sh ~/.config/create-app/
