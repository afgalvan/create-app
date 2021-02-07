#!/bin/bash

echo "Running pre-commit hook"
./test/test.sh
exit_code=$?

if [ $exit_code -ne 0 ]; then
    echo -e "\e[31m\nTests must pass before commit!"
    exit 1
fi
