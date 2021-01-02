#!/bin/bash

is_package_manager_valid() {
    local package_manager="$1"

    if [ "$package_manager" != "npm" ] && [ "$package_manager" != "yarn" ]; then
        echo -e "\e[31m Error on package manager name \"$package_manager\"."
        exit 1
    fi
}

echo -e "\e[34m create-app \e[7;34m installer \e[0m"
mkdir -p ~/.config/create-app
wget https://raw.githubusercontent.com/afgalvan/create-app/main/create_app.sh
chmod +x create_app.sh
if [ -z "$1" ]; then
    pm="npm"
else
    is_package_manager_valid "$1"
    pm="$1"
fi
echo "$pm" > ~/.config/create-app/default_pm

if [ -d ~/.config/create-app/create_app.sh ]; then
    rm -f ~/.config/create-app/create_app.sh
fi
mv create_app.sh ~/.config/create-app/
echo -e "\n\n\n\n\e[32mcreate-app installed.\e[0m"
echo -e "\nTry creating an alias to use it everywhere:"
echo -e "$ echo \"alias create-app=~/.config/create-app/create_app.sh\" >> ~/.bashrc"
