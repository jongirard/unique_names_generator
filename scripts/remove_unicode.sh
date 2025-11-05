#!/bin/bash

# Script to remove unicode characters from dictionary files
# Keeps only ASCII characters (bytes 0-127)

set -e

DICT_DIR="lib/dictionaries/data"
BACKUP_DIR="$DICT_DIR/.backup_$(date +%Y%m%d_%H%M%S)"

echo "Removing unicode characters from dictionary files..."
echo "Dictionary directory: $DICT_DIR"
echo ""

# Create backup directory
mkdir -p "$BACKUP_DIR"
echo "Created backup directory: $BACKUP_DIR"
echo ""

# Process each .txt file
processed=0
for file in "$DICT_DIR"/*.txt; do
  if [ -f "$file" ]; then
    filename=$(basename "$file")
    echo "Processing: $filename"

    # Backup original file
    cp "$file" "$BACKUP_DIR/$filename"

    # Remove unicode characters (keep only ASCII)
    # This removes any character with byte value > 127
    LC_ALL=C sed 's/[^[:print:]\n]//g' "$file" | \
    LC_ALL=C tr -cd '\11\12\15\40-\176' > "$file.tmp"

    # Move temp file to original
    mv "$file.tmp" "$file"

    # Remove any empty lines that may have been created
    sed -i.bak '/^$/d' "$file" && rm "$file.bak"

    ((processed++))
  fi
done

echo ""
echo "✓ Processed $processed files"
echo "✓ Backups saved to: $BACKUP_DIR"
echo ""
echo "To restore from backup if needed:"
echo "  cp $BACKUP_DIR/*.txt $DICT_DIR/"
echo ""
echo "To remove backup after verification:"
echo "  rm -rf $BACKUP_DIR"
