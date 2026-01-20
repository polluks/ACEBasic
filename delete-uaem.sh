#!/bin/bash
# Script to recursively delete all .uaem files from the current directory

echo "Searching for .uaem files..."
files=$(find . -name "*.uaem" -type f)

if [ -z "$files" ]; then
    echo "No .uaem files found."
    exit 0
fi

echo "Found the following .uaem files:"
echo "$files"
echo ""
echo -n "Delete these files? (y/n): "
read -r response

if [ "$response" = "y" ] || [ "$response" = "Y" ]; then
    find . -name "*.uaem" -type f -delete
    echo "Files deleted."
else
    echo "Deletion cancelled."
fi
