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
    # Skip hidden files and files in already-created extension folders
    [[ "$(basename "$file")" == .* ]] && continue
    rel_path="${file#$root_dir/}"
    top_folder="${rel_path%%/*}"
    [[ -d "$root_dir/$top_folder" && "$top_folder" =~ ^[A-Z0-9]{2,5}$ ]] && continue

    # Get filename, extension
    filename="$(basename "$file")"
    base="${filename%.*}"
    ext="${filename##*.}"
    [[ "$ext" == "$filename" ]] && continue  # Skip files without extension

    ext_upper="${(U)ext}"
    dest_dir="$root_dir/$ext_upper"
    dest_file="$dest_dir/$filename"

    mkdir -p "$dest_dir"

    if [[ -e "$dest_file" ]]; then
      # Compare size
      orig_size=$(stat -f %z "$file")
      existing_size=$(stat -f %z "$dest_file")
      if [[ "$orig_size" -ne "$existing_size" ]]; then
        # Generate new filename with counter
        count=1
        while true; do
          new_name="${base}_$count.$ext"
          dest_file="$dest_dir/$new_name"
          [[ -e "$dest_file" ]] || break
          ((count++))
        done
      else
        # Same name and size, likely duplicate
        echo "⚠️  Skipping duplicate: $file"
        continue
      fi
    fi

    mv "$file" "$dest_file"
    echo "✅ Moved: $file → $dest_file"
  done

  echo "🎉 Done organizing files with safe conflict handling."
}

# Apply the change without restarting terminal: source ~/.zshrc
### Then use it anytime like: organize_by_extension ~/Downloads/mix
