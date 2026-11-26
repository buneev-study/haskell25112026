#!/bin/bash
set -e

echo "Installing regex-pcre-builtin..."
cabal install regex-pcre-builtin --lib

echo "Compiling task5..."
cabal build

cleanup() {
    rm -f app_exe
    rm -f main.o
    rm -f main.hi
}
trap cleanup EXIT

run_test() {
    local test_name="$1"
    local file_to_pass="$2"
    local expected_file="$3"

    if [ ! -f "$file_to_pass" ]; then
        echo "WARN: $test_name (file '$file_to_pass' not found, skipping)"
        return 0
    fi

    if [ ! -f "$expected_file" ]; then
        echo "WARN: $test_name (expected file '$expected_file' not found, skipping)"
        return 0
    fi

    echo "$file_to_pass" | cabal run

    if [ -f "output5.txt" ]; then
        sed -i 's/\r$//' output5.txt
        if diff -q "output5.txt" "$expected_file" > /dev/null; then
            if  [[ "$(uchardet "output5.txt")" == *"IBM866"* ]] || [[ "$(uchardet "output5.txt")" == *"unknown"* ]]
            then
                echo "PASS: $test_name"
            else
                echo "FAIL: $test_name (wrong encoding output5.txt)"
                exit 1
            fi
        else
            echo "FAIL: $test_name (output differs from $expected_file)"
            diff -u "output5.txt" "$expected_file" || true
            exit 1
        fi
    else
        echo "FAIL: $test_name (output5.txt not created)"
        exit 1
    fi
}

run_test "Task 5 - Simple HTML" "simple.html" "simple_expected.html"
run_test "Task 5 - L1.html" "L1.html" "L1_expected.html"

echo -e "\nTask 5: All tests passed!"
