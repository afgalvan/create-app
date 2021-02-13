#!/bin/bash

is_valid_option() {
    local option="$1"

    if [ "$option" != "$2" ] && [ "$option" != "$3" ]; then
        echo -e "\e[31mError on $4 name \"$option\"."
        exit 1
    fi
}

install_app() {
    pm="$1"

    chmod +x create_app.sh
    mkdir -p ~/.config/create-app
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


if [ -z "$1" ]; then
    branch="main"
else
    branch="$1"
    is_valid_option "$branch" "main" "development" "branch"
fi

if [ -z "$2" ]; then
    pm="npm"
else
    pm="$2"
    is_valid_option "$pm" "npm" "yarn" "package manager"
fi

echo -e "\e[34mcreate-app \e[7;34m installer \e[0m"
{
    curl -O https://raw.githubusercontent.com/afgalvan/create-app/"$branch"/create_app.sh && install_app "$pm" || echo -e "\e[31m Error downloading create-app from the repository."; return 1
}
