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
    local expected_lines="$3"

    if [ ! -f "$file_to_pass" ]; then
        echo "WARN: $test_name (file '$file_to_pass' not found, skipping)"
        return 0
    fi

    echo "$file_to_pass" | ./app_exe
    
    if [ -f "output2.txt" ]; then
        local actual_lines=$(wc -l < output2.txt)
        if [ "$actual_lines" = "$expected_lines" ]; then
            echo "PASS: $test_name (lines: $actual_lines)"
        else
            echo "FAIL: $test_name (expected $expected_lines lines, got $actual_lines)"
            exit 1
        fi
    else
        echo "FAIL: $test_name (output2.txt not created)"
        exit 1
    fi
}

run_test "Task 2 - Simple HTML" "simple.html" "1"
run_test "Task 2 - L1.html" "L1.html" "82"

echo -e "\nTask 2: All tests passed!"
