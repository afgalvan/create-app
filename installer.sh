#!/bin/bash

is_package_manager_valid() {
    local package_manager="$1"

    if [ "$package_manager" != "npm" ] && [ "$package_manager" != "yarn" ]; then
        echo -e "\e[31m Error on package manager name \"$package_manager\"."
        exit 1
    fi
}

install_app() {
    pm="$1"

    mkdir -p ~/.config/create-app
    chmod +x create_app.sh
    echo "web" > ~/.config/create-app/defaults
    echo "$pm" >> ~/.config/create-app/defaults

    if [ -d ~/.config/create-app/create_app.sh ]; then
        rm -f ~/.config/create-app/create_app.sh
    fi
    mv create_app.sh ~/.config/create-app/
    echo -e "\n\n\n\n\e[32mcreate-app installed.\e[0m"
    echo -e "\nTry creating an alias to use it everywhere:"
    echo -e "$ echo \"alias create-app=~/.config/create-app/create_app.sh\" >> ~/.bashrc"
}

echo -e "\e[34m create-app \e[7;34m installer \e[0m"

if [ -z "$1" ]; then
    branch="main"
else
    branch="$1"
fi

if [ -z "$2" ]; then
    pm="npm"
else
    is_package_manager_valid "$1"
    pm="$2"
fi

{
    wget https://raw.githubusercontent.com/afgalvan/create-app/"$branch"/create_app.sh
} && {
    install_app "$pm"
} || {
    echo -e "\e[31m Error downloading create-app from the repository."
    exit 0
}

