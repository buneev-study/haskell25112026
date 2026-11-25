#!/bin/bash
set -e

echo "Installing regex-posix..."
cabal install regex-posix --lib

echo "Compiling task3..."
ghc -O2 -package regex-posix main.hs -o app_exe

cleanup() {
    rm -f app_exe
    rm -f main.o
    rm -f main.hi
}
trap cleanup EXIT

run_test() {
    local test_name="$1"
    local file_to_pass="$2"
    local min_expected="$3"

    if [ ! -f "$file_to_pass" ]; then
        echo "WARN: $test_name (file '$file_to_pass' not found, skipping)"
        return 0
    fi

    local output=$(echo "$file_to_pass" | ./app_exe)
    
    if [ -f "output3.txt" ]; then
        local actual_count=$(wc -l < output3.txt)
        if [ "$actual_count" -ge "$min_expected" ]; then
            echo "PASS: $test_name (found $actual_count URLs)"
        else
            echo "FAIL: $test_name (expected at least $min_expected URLs, got $actual_count)"
            exit 1
        fi
    else
        echo "FAIL: $test_name (output3.txt not created)"
        exit 1
    fi
}

run_test "Task 3 - L1.html" "L1.html" "1"

echo -e "\nTask 3: All tests passed!"
