import os
import shutil
import hashlib
from collections import defaultdict

def hash_file(filepath, block_size=65536):
    hasher = hashlib.sha1()
    with open(filepath, 'rb') as f:
        for block in iter(lambda: f.read(block_size), b''):
            hasher.update(block)
    return hasher.hexdigest()

def organize_by_extension(base_dir='.'):
    base_dir = os.path.abspath(base_dir)
    print(f"📂 Organizing files in: {base_dir}")

    existing_dir = os.path.join(base_dir, "EXISTING")
    file_registry = defaultdict(list)

    for root, _, files in os.walk(base_dir):
        if root.startswith(existing_dir):
            continue  # Skip EXISTING/
        for file in files:
            full_path = os.path.join(root, file)
            if not os.path.isfile(full_path):
                continue

            ext = os.path.splitext(file)[1][1:].upper() or "UNKNOWN"
            dest_dir = os.path.join(base_dir, ext)

            file_size = os.path.getsize(full_path)
            file_hash = hash_file(full_path)

            existing = file_registry[ext]
            conflict = next((f for f in existing if f['name'] == file), None)

            if conflict:
                if conflict['size'] == file_size and conflict['hash'] == file_hash:
                    os.remove(full_path)
                    print(f"⚠️ Deleted duplicate: {file}")
                    continue
                elif conflict['size'] != file_size:
                    base, ext_part = os.path.splitext(file)
                    new_file = f"{base}_1{ext_part}"
                    dest_path = os.path.join(dest_dir, new_file)
                    os.makedirs(dest_dir, exist_ok=True)
                    shutil.move(full_path, dest_path)
                    file_registry[ext].append({'name': new_file, 'size': file_size, 'hash': file_hash})
                    continue
                else:
                    base, ext_part = os.path.splitext(file)
                    new_file = f"{base}_1{ext_part}"
                    type_existing_dir = os.path.join(existing_dir, ext)
                    os.makedirs(type_existing_dir, exist_ok=True)
                    dest_path = os.path.join(type_existing_dir, new_file)
                    shutil.move(full_path, dest_path)
                    continue

            # No conflict
            os.makedirs(dest_dir, exist_ok=True)
            dest_path = os.path.join(dest_dir, file)
            shutil.move(full_path, dest_path)
            file_registry[ext].append({'name': file, 'size': file_size, 'hash': file_hash})

    print("🎉 Done organizing.")

# Run this locally with:
# organize_by_extension("/path/to/your/folder")
