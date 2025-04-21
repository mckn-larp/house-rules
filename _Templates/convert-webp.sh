#!/usr/bin/env bash

# Usage: ./convert-webp.sh [directory]
TARGET_DIR="${1:-.}"

echo "🔄 Converting .webp to .png in: $TARGET_DIR"

find "$TARGET_DIR" -type f -name "*.webp" | while read -r file; do
  base="${file%.webp}"
  newfile="${base}.png"
  echo "🖼 Converting: $file → $newfile"
  convert "$file" "$newfile" && echo "✅ Created: $newfile"
done

echo "🎉 Conversion complete."