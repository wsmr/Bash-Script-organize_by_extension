# Quick One-Liner Command (for current folder)
# for f in *.*; do ext="${f##*.}"; mkdir -p "${ext^^}"; mv -- "$f" "${ext^^}/"; done

# 🔹 What this does:
# 	•	Loops over all files with an extension.
# 	•	Extracts the extension (e.g., jpg, pdf).
# 	•	Creates a folder with that extension name in UPPERCASE.
# 	•	Moves the file into that folder.
# Example: photo.jpg → JPG/photo.jpg
# ⚠️ Limitations:
# 	•	Only works in the current directory.
# 	•	Won’t recurse into subdirectories.
# 	•	Will overwrite files if duplicates exist (unless enhanced).
# ⸻

for f in *.*; do
  ext="${f##*.}"
  ext_upper="${(U)ext}"       # zsh way to uppercase
  mkdir -p "$ext_upper"
  mv -- "$f" "$ext_upper/"
done


# ⸻
# Better Script: organize_by_type.sh
#!/bin/bash
TARGET_DIR="${1:-$(pwd)}"
echo "📁 Organizing files in: $TARGET_DIR"
cd "$TARGET_DIR" || { echo "❌ Failed to access $TARGET_DIR"; exit 1; }
# Loop over all files (not folders)
find . -maxdepth 1 -type f | while read -r file; do
  # Extract extension in uppercase
  ext="${file##*.}"
  ext_upper=$(echo "$ext" | tr '[:lower:]' '[:upper:]')
  # Skip if no extension or hidden
  [[ "$file" == "$ext" || "$file" == .* ]] && continue
  # Create folder and move file
  mkdir -p "$ext_upper"
  mv -- "$file" "$ext_upper/" 2>/dev/null
done
echo "✅ Done organizing files by type."

# Save the script:nano organize_by_type.sh
# Make it executable: chmod +x organize_by_type.sh
# Run it: ./organize_by_type.sh | Organize a specific directory: ./organize_by_type.sh /path/to/folder

# ⸻
# Wrap it into a function in .zshrc for reuse <---- zsh-compatible uppercase conversion: #!/bin/bash

organize_by_extension() {
  local root_dir="${1:-.}"
  cd "$root_dir" || { echo "❌ Directory not found: $root_dir"; return 1; }

  echo "📂 Recursively organizing files in: $root_dir"

  find "$root_dir" -type f | while read -r file; do
    [[ "$(basename "$file")" == .* ]] && continue

    # Skip files already in extension folders
    rel_path="${file#$root_dir/}"
    top_folder="${rel_path%%/*}"
    [[ -d "$root_dir/$top_folder" && "$top_folder" =~ ^[A-Z0-9]{2,5}$ ]] && continue

    filename="$(basename "$file")"
    base="${filename%.*}"
    ext="${filename##*.}"
    [[ "$ext" == "$filename" ]] && continue  # Skip files without extension

    ext_upper="${(U)ext}"
    dest_dir="$root_dir/$ext_upper"
    dest_file="$dest_dir/$filename"

    mkdir -p "$dest_dir"

    if [[ -e "$dest_file" ]]; then
      # Compare file content using shasum (fallback safe check)
      incoming_hash=$(shasum "$file" | awk '{print $1}')
      existing_hash=$(shasum "$dest_file" | awk '{print $1}')

      if [[ "$incoming_hash" == "$existing_hash" ]]; then
        echo "⚠️  Skipping duplicate (same content): $file"
        continue
      else
        # Conflict: different content, move to EXISTING
        existing_dir="$root_dir/EXISTING/$ext_upper"
        mkdir -p "$existing_dir"

        conflict_name="$existing_dir/$filename"
        count=1
        while [[ -e "$conflict_name" ]]; do
          conflict_name="$existing_dir/${base}_$count.$ext"
          ((count++))
        done

        mv "$file" "$conflict_name"
        echo "📁 Conflict file moved to: $conflict_name"
        continue
      fi
    fi

    # Normal move
    mv "$file" "$dest_file"
    echo "✅ Moved: $file → $dest_file"
  done

  echo "🎉 Done organizing with conflict protection into 'EXISTING/'."
}


# Apply the change without restarting terminal: source ~/.zshrc
### Then use it anytime like: organize_by_extension ~/Downloads/mix

# JPG/cat.jpg ← first copyEXISTING/JPG/cat.jpg ← second one (moved here due to content conflict) | Skipping duplicate (same content)
# shasum — Checks File Content Uniquely
## incoming_hash=$(shasum "$file" | awk '{print $1}')
## existing_hash=$(shasum "$dest_file" | awk '{print $1}')
# It calculates a SHA-1 checksum for each file. That checksum:
# 	•	Is generated based on entire file content (byte-by-byte)
# 	•	Even if only one pixel changes in an image, the checksum will be different
# 	•	So even same-named, same-sized JPEGs will be identified as different, if their content differs
# If you want even stronger certainty, you could use shasum -a 256 (SHA-256) or md5.
## incoming_hash=$(shasum -a 256 "$file" | awk '{print $1}')
## existing_hash=$(shasum -a 256 "$dest_file" | awk '{print $1}')

