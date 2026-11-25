#!/bin/bash
set -e

echo "Compiling task2..."
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
    local expected_file="$3"

    if [ ! -f "$file_to_pass" ]; then
        echo "WARN: $test_name (file '$file_to_pass' not found, skipping)"
        return 0
    fi

    if [ ! -f "$expected_file" ]; then
        echo "WARN: $test_name (expected file '$expected_file' not found, skipping)"
        return 0
    fi

    echo "$file_to_pass" | ./app_exe

    if [ -f "output2.txt" ]; then
        sed -i 's/\r$//' output2.txt
        if diff -q "output2.txt" "$expected_file" > /dev/null; then
            echo "PASS: $test_name"
        else
            echo "FAIL: $test_name (output differs from $expected_file)"
            diff -u "output2.txt" "$expected_file" || true
            exit 1
        fi
    else
        echo "FAIL: $test_name (output2.txt not created)"
        exit 1
    fi
}

run_test "Task 2 - Simple HTML" "simple.html" "simple_expected.html"
run_test "Task 2 - L1.html" "L1.html" "L1_expected.html"

echo -e "\nTask 2: All tests passed!"
