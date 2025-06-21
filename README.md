# Bash-Script-organize_by_extension

## Usage:

#### Make executable
chmod +x organize_by_extension.sh

#### Basic usage
./organize_by_extension.sh

#### Specify path
./organize_by_extension.sh ~/Downloads

#### Specify path and ignore folders
./organize_by_extension.sh ~/Downloads "temp,backup,old"

#### Show help
./organize_by_extension.sh --help

## Configuration Examples:

#### Only process images and videos
INCLUDE_EXTENSIONS="jpg,jpeg,png,gif,mp4,avi,mov"

#### Ignore temporary files
EXCLUDE_EXTENSIONS="tmp,temp,log,bak,cache"

#### Only files between 1KB and 100MB
MIN_FILE_SIZE=1024
MAX_FILE_SIZE=104857600

#### Simple folder names without timestamp
USE_TIMESTAMP=false


## Key Features:
1. Configuration Section (Top of script)

INCLUDE_EXTENSIONS: Specify which file types to process (e.g., "jpg,png,pdf")
EXCLUDE_EXTENSIONS: File types to completely ignore
MIN_FILE_SIZE/MAX_FILE_SIZE: Size range filters
USE_TIMESTAMP: Enable/disable timestamp in folder names
DEFAULT_IGNORE_FOLDERS: Folders to skip

2. Error Handling

Files with errors go to ERROR/ folder
Handles file access issues, hash calculation failures, etc.
Never loses files - problematic ones are safely moved

3. Detailed Logging

Creates timestamped log file in script directory
Records all actions: moved, removed, errors with timestamps
Tracks statistics and configuration used

4. Timestamped Folders

JPG_20241222 format (configurable date format)
Can be disabled for simple JPG names

5. Advanced Filtering

File size ranges
Include/exclude specific extensions
Ignore specific folders (case-insensitive)
