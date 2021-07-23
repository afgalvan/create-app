#!/bin/bash

oneTimeSetUp() {
    . ./create_app.sh
}

testValidTemplates() {
    isolation=$(is_template_valid "web")
    result=$?
    expected=0
    assertEquals "${expected}" "${result}"

    isolation=$(is_template_valid "python")
    result=$?
    expected=0
    assertEquals "${expected}" "${result}"

    isolation=$(is_template_valid "java")
    result=$?
    expected=0
    assertEquals "${expected}" "${result}"

    isolation=$(is_template_valid "go")
    result=$?
    expected=1
    assertEquals "${expected}" "${result}"

    isolation=$(is_template_valid "")
    result=$?
    expected=1
    assertEquals "${expected}" "${result}"

    # shellcheck disable=SC2034  # Unused variables left for readability
    isolation=$(is_template_valid)
    result=$?
    expected=1
    assertEquals "${expected}" "${result}"

}

testPackageManager() {
    isolation=$(is_package_manager_valid "npm")
    result=$?
    expected=0
    assertEquals "${expected}" "${result}"

    isolation=$(is_package_manager_valid "yarn")
    result=$?
    expected=0
    assertEquals "${expected}" "${result}"

    isolation=$(is_package_manager_valid "afsd")
    result=$?
    expected=1
    assertEquals "${expected}" "${result}"

    isolation=$(is_package_manager_valid "")
    result=$?
    expected=1
    assertEquals "${expected}" "${result}"

    # shellcheck disable=SC2034  # Unused variables left for readability
    isolation=$(is_package_manager_valid)
    result=$?
    expected=1
    assertEquals "${expected}" "${result}"
}

expected() {
    function="$1"
    title
    $function
}

testHelpPrompt() {
    expected=$(expected prompt_help)
    result=$(main)

    assertEquals \
    "the result of '${result}' was wrong" \
    "${expected}" "${result}"
}


testTemplateListing() {
    expected=$(expected templates)
    result=$(main -t)

    assertEquals \
    "the result of '${result}' was wrong" \
    "${expected}" "${result}"
}

testVersion() {
    expected=$(title)
    result=$(main -v)

    assertEquals \
    "the result of '${result}' was wrong" \
    "${expected}" "${result}"
}

. shunit2-2.1.6/src/shunit2
