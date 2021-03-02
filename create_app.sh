#!/bin/bash

YELLOW="\e[33m"
BLUE="\e[34m"
RED="\e[31m"
GREEN="\e[32m"
CYAN="\e[36m"
BOLD="\e[1m"
RESET="\e[0m"
MAGENTA="\e[35m"
VERSION="v.0.4-beta"
settings=()

title() {
    echo -e "$BLUE$BOLD"
    echo -e "create-app \e[7;34m $VERSION $RESET"
}

load_settings() {
    local config="$HOME/.config/create-app/defaults"
    local i=0

    while IFS= read -r line
    do
        settings[("$i")]="$line"
        i=$(( $i + 1 ))
    done < "$config"
}

pm_format() {
    local package_manager="$1"

    case $package_manager in
        "npm")
            echo -e "$RED$package_manager"
        ;;
        "pipenv")
            echo -e "$YELLOW$package_manager"
        ;;
        "yarn")
            echo -e "$CYAN$package_manager"
        ;;
        "intelliJ")
            echo -e "$MAGENTA$package_manager"
        ;;
        *)
            echo "$package_manager"
        ;;
    esac
}

template_format() {
    local template="$1"

    case $template in
        "web")
            echo -e "$YELLOW$template"
        ;;
        "javascript" | "js")
            template="JavaScript"
            echo -e "$YELLOW$template"
        ;;
        "py" | "python")
            template="Python"
            echo -e "$YELLOW$template"
        ;;
        "typescript" | "ts")
            template="TypeScript"
            echo -e "$BLUE$template"
        ;;
        "go")
            echo -e "$BLUE$template"
        ;;
        "java")
            echo -e "$RED$template"
        ;;
        *)
            echo "$template"
        ;;
    esac
}

is_template_valid() {
    local template="$1"

    if [ "$template" == "web" ]; then
        return 0
        elif [ "$template" == "py" ] || [ "$template" == "python" ]; then
        return 0
        elif [ "$template" == "java" ]; then
        return 0
    else
        echo -e "$RED"
        echo -e "Error on template name \"$template\".$RESET"
        templates
        return 1
    fi
}

is_package_manager_valid() {
    local package_manager="$1"

    if [ "$package_manager" != "npm" ] && [ "$package_manager" != "yarn" ]; then
        echo -e "$RED"
        echo -e "Error on package manager name \"$package_manager\".$RESET"
        echo -e "You meant$RED npm$RESET or$CYAN yarn$RESET?"
        return 1
    fi
}

update_app() {
    package_manager=${settings[1]}
    curl -sL https://raw.githubusercontent.com/afgalvan/create-app/main/installer.sh | bash -s  "main" "$package_manager"
}

prompt_help() {
    echo -e "\n  $BOLD \e[97mHelp information.$RESET"
    echo -e "\n   Usage: create-app <project-name> [template] [package-manager]"
    echo -e "   Example: $GREEN create-app$RESET awesome_project python"
    echo "   Note: If optional arguments are not provide, your default settings will be used."

    echo -e "\n   Commands:"
    echo -e "     -h, --help                                              Displays help information for command usage.
     -v, --version                                           Show create-app current version.
     -d, --defaults                                          Show your default settings.
     -t, --templates                                         Show available templates to use.
     -u, --update                                            Auto update create-app from the repository.
     -st, --set-template <template-name>                     Change default project template.
     -sp, --set-package-manager, --set-pm <package-manager>  Change default package manager.
    \n   Visit https://github.com/afgalvan/create-app"
}

templates() {
    echo -e "\nTemplates:"
    echo "   - web"
    echo "   - python"
    echo "   - java (Soon)"
}

change_template() {
    local template="$1"
    settings[0]="$template"

    is_template_valid "$template"
    if [ $? -ne 0 ]; then
        exit 1
    fi

    update_config
    template=$(template_format "$template")
    echo -e "Default package manager changed to $template$RESET."
}

change_package_manager() {
    local package_manager="$1"
    settings[1]="$package_manager"

    is_package_manager_valid "$package_manager"
    if [ $? -ne 0 ]; then
        exit 1
    fi
    update_config
    package_manager=$(pm_format "$package_manager")
    echo -e "Default package manager changed to $package_manager$RESET."
}

update_config() {
    rm -f $HOME/.config/create-app/defaults

    for i in "${settings[@]}"; do
        echo "$i" >> "$HOME/.config/create-app/defaults";
    done
}

defaults() {
    local template=${settings[0]}
    local pckg=${settings[1]}
    local template=$(template_format "$template")
    local pckg=$(pm_format "$pckg")

    echo "Default settings."
    echo -e "   - Template: $template$RESET"
    echo -e "   - Package manager: $pckg$RESET"
}

config_args() {
    local arg="$1"
    local opt="$2"

    case $arg in
        "--update" | "-u")
            update_app
        ;;
        "--help" | "-h")
            prompt_help
        ;;
        "--templates" | "-t")
            templates
        ;;
        "--set-package-manager" | "--set-pm" | "-sp")
            change_package_manager "$opt"
        ;;
        "--set-template" | "-st")
            change_template "$opt"
        ;;
        "--version" | "-v")
        ;;
        "--defaults" | "-d")
            defaults
        ;;
        *)
            echo "Unknown option \"$arg\""
            echo "    Try: create-app --help"
            exit 1
        ;;
    esac
    exit 0

}

is_project_valid() {
    local project_name="$1"

    # Check for any project name argument
    if [ -z "$project_name" ]; then
        prompt_help
        return 1
    fi
    # Check if the folder already exists
    if [ -d "$project_name" ]; then
        if [ ! -z "$(ls "$project_name")" ]; then
            echo -e "$BLUE$project_name$RESET$RED folder exists and it's not empty."
            return 1
        fi
    fi

    return 0
}

template_setup() {
    local project_name="$1"
    local package_manager="$2"
    local template="$3"
    local repo_url=https://github.com/afgalvan/create-app.git

    {
        git clone -b "$template" -q "$repo_url" "$project_name"
        } && {
        cd "$project_name"
        if [ ! -f README.md ]; then
            echo "# $project_name" > README.md
        fi
        rm -rf .git/
        git init
        git checkout -b main
        bash setup.sh "$package_manager" "$project_name"
        } || {
        echo -e "$RED"
        echo -e "The template installation has failed due a git error."
        cd ..
        rm -rf $project_name
        exit 1
    }
}

main() {
    local project_name="$1"
    local template="$2"
    local package_manager="$3"
    title

    # Check for config arguments
    if [[ "$project_name" =~ ^- ]]; then
        config_args "$project_name" "$2"
    fi

    is_project_valid "$project_name"
    if [ $? -ne 0 ]; then
        exit 1
    fi

    # Check template argument
    if [ -z "$template" ]; then
        template=${settings[0]}
    fi
    is_template_valid "$template"
    if [ $? -ne 0 ]; then
        exit 1
    fi

    # Check package manager argument
    if [ -z "$package_manager" ]; then
        package_manager=${settings[1]}
    fi
    is_package_manager_valid "$package_manager"
    if [ $? -ne 0 ]; then
        exit 1
    fi
    if [ "$template" == "python" ]; then
        package_manager="pipenv"
    fi
    if [ "$template" == "java" ]; then
        package_manager="intelliJ"
    fi

    {
        template_setup "$project_name" "$package_manager" "$template"
        } && {
        template=$(template_format "$template")
        package_manager=$(pm_format "$package_manager")
        echo -e "\n\n\n\n\n\n"
        echo -e "$GREEN✓$RESET The $template$RESET project \"$project_name\" was succesfully created with $package_manager$RESET!"
        } || {
        echo -e "$RED"
        echo "Unexpected error in the template installation."
        echo "Try checking the requirements."
        cd ..
        rm -rf $project_name
        exit 1
    }
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    load_settings
    main "$@"
fi
