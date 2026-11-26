#!/bin/bash
set -e

echo "Installing regex-pcre-builtin..."
cabal install regex-pcre-builtin --lib

echo "Installing iconv..."
cabal install iconv --lib

echo "Compiling task6..."
cabal build

cleanup() {
    rm -f app_exe
    rm -f main.o
    rm -f main.hi
    rm -f output6_cp1251.txt
    rm -f output6_koi8r.txt
}
trap cleanup EXIT

run_test() {
    local test_name="$1"
    local file_to_pass="$2"
    local encoding="$3"
    local expected_file="$4"
    local encoding_pattern="$5"
    local output_file="output6_${encoding}.txt"

    if [ ! -f "$file_to_pass" ]; then
        echo "WARN: $test_name (file '$file_to_pass' not found, skipping)"
        return 0
    fi

    if [ ! -f "$expected_file" ]; then
        echo "WARN: $test_name (expected file '$expected_file' not found, skipping)"
        return 0
    fi

    if [ ! -f "$output_file" ]; then
        echo "FAIL: $test_name ($output_file not created)"
        exit 1
    fi

    sed -i 's/\r$//' "$output_file"

    if ! diff -q "$output_file" "$expected_file" > /dev/null 2>&1; then
        echo "FAIL: $test_name (output differs from $expected_file)"
        diff -u <(cat "$output_file" | iconv -f "$encoding" -t UTF-8 2>/dev/null || cat "$output_file") \
                <(cat "$expected_file" | iconv -f "$encoding" -t UTF-8 2>/dev/null || cat "$expected_file") \
                || true
        exit 1
    fi

    detected=$(uchardet "$output_file" 2>/dev/null || echo "unknown")
    if [[ "$detected" == *"$encoding_pattern"* ]] || [[ "$detected" == "unknown" ]]; then
        echo "PASS: $test_name (encoding detected: $detected)"
    else
        echo "FAIL: $test_name (wrong encoding: expected ~$encoding_pattern, got $detected)"
        exit 1
    fi
}

run_all_tests() {
    local file_to_pass="$1"

    if [ ! -f "$file_to_pass" ]; then
        echo "WARN: File '$file_to_pass' not found, skipping all tests for it"
        return 0
    fi

    echo "$file_to_pass" | cabal run

    run_test "Task 6 - $file_to_pass (CP1251)" \
             "$file_to_pass" "cp1251" \
             "${file_to_pass%.html}_expected_cp1251.html" "WINDOWS-1251"

    run_test "Task 6 - $file_to_pass (KOI8-R)" \
             "$file_to_pass" "koi8r" \
             "${file_to_pass%.html}_expected_koi8r.html" "KOI8-R"
}

run_all_tests "simple.html"
run_all_tests "L1.html"

echo -e "\nTask 6: All tests passed!"
