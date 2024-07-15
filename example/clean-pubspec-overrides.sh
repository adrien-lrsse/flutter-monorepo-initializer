#!/bin/bash

# Use the find command to locate and delete pubspec_overrides.yaml files
find . -type f -name "pubspec_overrides.yaml" -exec rm -f {} \;

# Indicate the operation is complete
echo "All pubspec_overrides.yaml files have been deleted from subdirectories."
