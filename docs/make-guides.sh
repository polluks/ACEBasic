#!/bin/bash
# Convert ACE documentation from txt to AmigaGuide format

cd "$(dirname "$0")"

echo "Converting ace.txt..."
ruby txt2guide.rb ace.txt > ace.guide

echo "Converting ref.txt..."
ruby txt2guide.rb ref.txt > ref.guide

echo "Converting MUI-Submod.txt..."
ruby txt2guide.rb MUI-Submod.txt > MUI-Submod.guide

echo "Converting intern_funcall_conventions.txt..."
ruby txt2guide.rb intern_funcall_conventions.txt > intern_funcall_conventions.guide

echo "Done."
