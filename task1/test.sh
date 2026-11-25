#!/bin/bash
set -e

echo "Compiling task1..."
ghc -O2 main.hs -o app_exe

cleanup() {
    rm -f app_exe
    rm -f main.o
    rm -f main.hi
}
trap cleanup EXIT

run_test() {
    local test_name="$1"
    local file_to_pass="$2"
    local expected="$3"

    if [ ! -f "$file_to_pass" ]; then
        echo "WARN: $test_name (file '$file_to_pass' not found, skipping)"
        return 0
    fi

    local actual=$(echo "$file_to_pass" | ./app_exe)

    if [ "$actual" = "$expected" ]; then
        echo "PASS: $test_name ($actual)"
    else
        echo "FAIL: $test_name (expected: $expected, got: $actual)"
        exit 1
    fi
}

run_test "Task 1 - Empty file" "empty.html" "0"
run_test "Task 1 - Simple HTML" "simple.html" "4"
run_test "Task 1 - L1.html" "L1.html" "246"

echo -e "\nTask 1: All tests passed!"
