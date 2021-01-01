#!/bin/bash

BLUE="\033[0;34m"
RED="\033[0;31m"
GREEN="\033[0;32m"
CYAN="\033[0;36m"
RESET="\033[0m"
VERSION="create-app version alpha"

default_package_manager() {
    config="$HOME/.config/create-app/default_pm"

    while IFS= read -r line
    do
        pckg="$line"
    done < "$config"
    echo "$pckg"
}

pm_colored() {
    package_manager="$1"

    if [ "$package_manager" == "npm" ]; then
        echo "$RED$package_manager"
    else
        echo "$CYAN$package_manager"
    fi
}

is_valid_package_manager() {
    package_manager="$1"

    if [ "$package_manager" != "npm" ] && [ "$package_manager" != "yarn" ]; then
        echo false
    else
        echo true
    fi

}

change_package_manager() {
    package_manager="$1"

    echo "$package_manager" > "$HOME/.config/create-app/default_pm"
    package_manager=$(pm_colored "$package_manager")
    echo -e "Default package manager setted to $package_manager$RESET."
}

prompt_help() {
    echo ""
}

main() {
    echo "create-app alpha"
    project_name="$1"
    package_manager="$2"
    if [ -z "$package_manager" ]; then
        package_manager=$(default_package_manager)
    fi

    status=$(is_valid_package_manager "$package_manager")
    if [ "$status" == false ]; then
        echo -e "$RED Error on package manager name \"$package_manager\"."
        return 1
    fi

    if [[ "$project_name" =~ ^- ]]; then
        if [ "$project_name" == "--help" ] || [ "$project_name" == "-h" ]; then
            echo "Not yet"
            return 0
        elif [ "$project_name" == "--set-pm" ]; then
            change_package_manager "$package_manager"
            return 0
        elif [ "$project_name" == "--version" ] || [ "$project_name" == "-v" ]; then
            echo "$VERSION"
            return 0
        else
            echo "Unknown option \"$project_name\""
            echo "Try: create-app --help"
            return 1
        fi
    fi
    package_manager=$(pm_colored "$package_manager")

    if [ -z "$project_name" ]; then
        echo "$project_name"
        echo -e "$RED Flag project name not provided."
        return 1
    fi

    if [ -d "$project_name" ]; then
        if [ ! -z "$(ls "$project_name")" ]; then
            echo -e "$BLUE$BOLD$project_name$RESET$RED folder exists and it's not empty."
            return 1
        fi
    fi

    repo_url=https://github.com/afgalvan/create-app.git
    git clone -b web -q "$repo_url" "$1"
    cd "$project_name"
    echo "# $project_name" > README.md
    rm -rf .git/
    git init
    git checkout -b main
    "$package_manager" install --silent
    echo -e "\n\n\n\n\n\n\n\n\n\n$GREEN"
    echo -e "✓$RESET $project_name project$GREEN SUCCESFULLY$RESET setted with $package_manager$RESET!"
}

main "$1" "$2"
