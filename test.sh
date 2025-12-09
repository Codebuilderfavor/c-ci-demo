#!/bin/sh
set -e

echo "Running tests..."
output=$(./hello)

if [ "$output" = "Hello from C CI Demo!" ]; then
    echo "Test passed!"
else
    echo "Test FAILED!"
    echo "Output was: $output"
    exit 1
fi
