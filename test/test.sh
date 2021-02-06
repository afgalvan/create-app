#!/bin/bash

oneTimeSetUp() {
    . ./create_app.sh -d
}

testValidTemplates() {
    is_template_valid "web"
    is_template_valid "python"
    is_template_valid "java"
}

testPackageManager() {
    is_package_manager_valid "npm"
    is_package_manager_valid "yarn"
}

expected() {
    function="$1"
    title
    $1
}

testHelpPrompt() {
    expected=`expected prompt_help`
    result=`main`

    assertEquals \
    "the result of '${result}' was wrong" \
    "${expected}" "${result}"
}


testTemplateArg() {
    expected=`expected templates`
    result=`main -t`

    assertEquals \
    "the result of '${result}' was wrong" \
    "${expected}" "${result}"
}

. shunit2-2.1.6/src/shunit2
