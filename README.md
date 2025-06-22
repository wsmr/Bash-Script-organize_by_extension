# File Organization Script

A powerful and intelligent file organization tool that automatically categorizes files by extension while handling duplicates, conflicts, and errors gracefully.

## 🚀 Features

### Core Functionality
- **Smart File Categorization**: Automatically organizes files into folders based on their extensions (e.g., `JPG/`, `PDF/`, `MP4/`)
- **Intelligent Duplicate Handling**: 
  - Removes exact duplicates (same name, size, and content)
  - Renames files with same name but different sizes
  - Moves files with same name/size but different content to `EXISTING/` folder
- **Error Recovery**: Problematic files are safely moved to `ERROR/` folder instead of being lost
- **Comprehensive Logging**: Detailed timestamped logs of all operations

### Advanced Features
- **Configurable File Filtering**: Include/exclude specific file types and size ranges
- **Folder Ignoring**: Skip specified folders during organization
- **Timestamped Folders**: Optional timestamp suffixes (e.g., `JPG_20241222`)
- **Cross-Platform Compatibility**: Works on macOS, Linux, and other Unix-like systems
- **Colored Output**: Easy-to-read terminal output with color coding

## 📋 Table of Contents

- [Installation](#installation)
- [Quick Start](#quick-start)
- [Configuration](#configuration)
- [Usage Examples](#usage-examples)
- [File Processing Logic](#file-processing-logic)
- [System Requirements](#system-requirements)
- [Advanced Configuration](#advanced-configuration)
- [Troubleshooting](#troubleshooting)
- [Future Implementations](#future-implementations)
- [Contributing](#contributing)

## 🛠️ Installation

### Method 1: Direct Download
```bash
# Download the script
curl -O https://raw.githubusercontent.com/wsmr/Script-Bash-organize_by_extension/main/organize_by_extension.sh

# Make it executable
chmod +x organize_by_extension.sh
```

### Method 2: Clone Repository
```bash
git clone https://github.com/wsmr/Script-Bash-organize_by_extension.git
cd Script-Bash-organize_by_extension
chmod +x organize_by_extension.sh
```

## 🚀 Quick Start

### Basic Usage
```bash
# Organize current directory
./organize_by_extension.sh

# Organize specific directory
./organize_by_extension.sh ~/Downloads

# Organize with ignored folders
./organize_by_extension.sh ~/Downloads "temp,backup,archive"
```

### Help
```bash
./organize_by_extension.sh --help
```

## ⚙️ Configuration

The script includes a configuration section at the top that you can modify:

```bash
# File types to process (leave empty for all)
INCLUDE_EXTENSIONS=""  # Example: "jpg,png,pdf,mp4"

# File types to ignore
EXCLUDE_EXTENSIONS="tmp,temp,log,bak"

# File size limits (in bytes, 0 = no limit)
MIN_FILE_SIZE=0        # Minimum file size
MAX_FILE_SIZE=0        # Maximum file size  

# Folder naming with timestamp
USE_TIMESTAMP=true     # Set to false for simple names
DATE_FORMAT="%Y%m%d"   # Timestamp format

# Default folders to ignore
DEFAULT_IGNORE_FOLDERS="existing,error,logs"
```

## 📝 Usage Examples

### Example 1: Basic Organization
```bash
./organize_by_extension.sh ~/Downloads
```
**Result**: All files in Downloads organized by extension into timestamped folders.

### Example 2: Specific File Types Only
```bash
# Edit script: INCLUDE_EXTENSIONS="jpg,png,pdf,docx"
./organize_by_extension.sh ~/Documents
```
**Result**: Only image and document files are organized.

### Example 3: Size-Based Filtering
```bash
# Edit script: MIN_FILE_SIZE=1048576 (1MB), MAX_FILE_SIZE=104857600 (100MB)
./organize_by_extension.sh ~/Downloads
```
**Result**: Only files between 1MB and 100MB are processed.

### Example 4: Ignore Specific Folders
```bash
./organize_by_extension.sh ~/Downloads "work,personal,temp"
```
**Result**: Files in work/, personal/, and temp/ folders are skipped.

## 🔄 File Processing Logic

The script follows this intelligent processing logic:

### 1. Different Files (Different Names/Types)
```
Input:
├── pics/cat.jpg
├── downloads/dog.jpg
└── misc/document.pdf

Output:
├── JPG_20241222/
│   ├── cat.jpg
│   └── dog.jpg
└── PDF_20241222/
    └── document.pdf
```

### 2. Same Name, Different Size
```
Input:
├── pics/cat.jpg (200 KB)
└── misc/cat.jpg (250 KB)

Output:
└── JPG_20241222/
    ├── cat.jpg      ← original
    └── cat_1.jpg    ← renamed
```

### 3. Same Name/Size, Different Content
```
Input:
├── pics/cat.jpg (200 KB, content A)
├── downloads/cat.jpg (200 KB, content A)  ← duplicate
└── misc/cat.jpg (200 KB, content B)       ← different content

Output:
├── JPG_20241222/
│   └── cat.jpg                    ← original
└── EXISTING/
    └── JPG_20241222/
        └── cat.jpg                ← moved here
```

### 4. Exact Duplicates
```
Input:
├── pics/cat.jpg (200 KB, content A)
├── downloads/cat.jpg (200 KB, content A)  ← removed
└── misc/cat.jpg (200 KB, content A)       ← removed

Output:
└── JPG_20241222/
    └── cat.jpg                    ← only original kept
```

## 💻 System Requirements

### Supported Operating Systems
- **macOS** (10.12 Sierra or later)
- **Linux** (Ubuntu 16.04+, CentOS 7+, Debian 9+)
- **Unix-like systems** with bash support

### Required Commands
The script uses standard Unix commands that should be available on most systems:
- `bash` (version 4.0+)
- `find`
- `stat`
- `shasum` (or `sha1sum` on Linux)
- `mkdir`
- `mv`
- `rm`
- `date`

### Storage Requirements
- **Minimum**: 100MB free space for logs and temporary operations
- **Recommended**: 20% of total file size being organized for safe operation

## 🔧 Advanced Configuration

### Custom File Type Handling

#### Only Process Images and Videos
```bash
INCLUDE_EXTENSIONS="jpg,jpeg,png,gif,bmp,tiff,mp4,avi,mov,mkv,webm"
```

#### Exclude System and Temporary Files
```bash
EXCLUDE_EXTENSIONS="tmp,temp,log,bak,cache,lock,pid,swap"
```

### Size-Based Organization

#### Only Large Files (>10MB)
```bash
MIN_FILE_SIZE=10485760  # 10MB in bytes
MAX_FILE_SIZE=0         # No upper limit
```

#### Only Small Files (<1MB)
```bash
MIN_FILE_SIZE=0
MAX_FILE_SIZE=1048576   # 1MB in bytes
```

### Custom Folder Naming

#### Simple Names Without Timestamps
```bash
USE_TIMESTAMP=false
```
**Result**: `JPG/`, `PDF/`, `MP4/` instead of `JPG_20241222/`

#### Custom Date Format
```bash
DATE_FORMAT="%Y-%m-%d"  # Results in JPG_2024-12-22
DATE_FORMAT="%Y%U"      # Results in JPG_202451 (year + week)
```

### Folder Ignore Patterns

#### Development Projects
```bash
DEFAULT_IGNORE_FOLDERS="node_modules,vendor,.git,.svn,dist,build"
```

#### Media Production
```bash
DEFAULT_IGNORE_FOLDERS="raw,working,archive,backup,temp"
```

## 🐛 Troubleshooting

### Common Issues

#### Permission Denied
```bash
chmod +x organize_by_extension.sh
# If still having issues:
sudo chmod +x organize_by_extension.sh
```

#### Files Not Moving
Check the log file for detailed error information:
```bash
cat organize_log_YYYYMMDD_HHMMSS.log
```

#### Script Not Found
Ensure you're in the correct directory:
```bash
ls -la organize_by_extension.sh
./organize_by_extension.sh
```

### Performance Considerations

#### Large Directories (>10,000 files)
- Run during off-peak hours
- Consider processing subdirectories separately
- Monitor disk space during operation

#### Network Drives
- Script may run slower on network-mounted drives
- Ensure stable network connection
- Consider copying files locally first

## 🔮 Future Implementations

### Planned Features (v2.0)

#### 1. Configuration File Support
```bash
# organize_config.conf
[general]
use_timestamp=true
date_format=%Y%m%d

[filters]
include_extensions=jpg,png,pdf
min_file_size=1024
max_file_size=104857600

[advanced]
parallel_processing=true
checksum_algorithm=sha256
```

**Implementation Location**: Add config parser in main script around line 50
```bash
# Add after current configuration section
if [[ -f "organize_config.conf" ]]; then
    source "organize_config.conf"
fi
```

#### 2. Parallel Processing
```bash
# Enable multi-threading for large directories
PARALLEL_PROCESSING=true
MAX_WORKERS=4
```

**Implementation**: Replace main processing loop with GNU parallel
```bash
find "$ROOT_DIR" -type f -print0 | parallel -0 -j $MAX_WORKERS process_single_file
```

#### 3. Advanced Duplicate Detection
- **Content-based**: EXIF data comparison for images
- **Fuzzy matching**: Similar filenames detection
- **Visual similarity**: Perceptual hashing for images

**Implementation Location**: Add after line 200 (hash calculation)
```bash
# Add advanced duplicate detection functions
calculate_perceptual_hash() {
    # Implementation for image similarity
}
```

#### 4. Database Integration
```bash
# SQLite database for tracking operations
DB_ENABLED=true
DB_PATH="$SCRIPT_DIR/organize_history.db"
```

#### 5. Web Interface
- Browser-based configuration
- Real-time progress monitoring
- Visual file preview before organization

#### 6. Cloud Storage Integration
```bash
# Support for cloud services
CLOUD_SYNC=true
CLOUD_PROVIDER="dropbox"  # dropbox, gdrive, onedrive
```

### Experimental Features (v3.0)

#### 1. AI-Powered Categorization
```bash
# Machine learning-based file categorization
AI_CATEGORIZATION=true
MODEL_PATH="./models/file_classifier.model"
```

#### 2. Content-Based Organization
- Organize photos by faces, objects, or scenes
- Group documents by topic or content similarity
- Audio files by genre, artist, or mood

#### 3. Smart Conflict Resolution
```bash
# AI-driven duplicate resolution
SMART_CONFLICTS=true
CONFLICT_STRATEGY="ai_decide"  # user_prompt, ai_decide, keep_newest
```

### Code Modification Guide

#### Adding New File Type Categories
```bash
# Location: After line 300 (get_folder_name function)
get_special_category() {
    local ext="$1"
    case "${ext,,}" in
        "jpg"|"jpeg"|"png"|"gif"|"bmp")
            echo "IMAGES"
            ;;
        "mp4"|"avi"|"mov"|"mkv")
            echo "VIDEOS"
            ;;
        "pdf"|"doc"|"docx"|"txt")
            echo "DOCUMENTS"
            ;;
        *)
            get_folder_name "$ext"
            ;;
    esac
}
```

#### Custom Processing Rules
```bash
# Location: After line 400 (main processing logic)
apply_custom_rules() {
    local file="$1"
    local ext="$2"
    
    # Example: Move all files from 2020 to archive
    if [[ $(date -r "$file" +%Y) == "2020" ]]; then
        echo "ARCHIVE_2020"
        return 0
    fi
    
    # Example: Large video files go to external drive
    if [[ "${ext,,}" == "mp4" && $file_size -gt 1073741824 ]]; then
        echo "/external/LARGE_VIDEOS"
        return 0
    fi
    
    return 1
}
```

#### Adding New Hash Algorithms
```bash
# Location: Replace shasum calculation around line 350
calculate_file_hash() {
    local file="$1"
    local algorithm="${HASH_ALGORITHM:-sha1}"
    
    case "$algorithm" in
        "md5")
            md5sum "$file" | awk '{print $1}'
            ;;
        "sha256")
            sha256sum "$file" | awk '{print $1}'
            ;;
        *)
            shasum "$file" | awk '{print $1}'
            ;;
    esac
}
```

## 🤝 Contributing

### Development Setup
```bash
git clone https://github.com/wsmr/Script-Bash-organize_by_extension.git
cd Script-Bash-organize_by_extension

# Create development branch
git checkout -b feature/your-feature-name

# Make changes and test
./organize_by_extension.sh test_directory

# Commit and push
git add .
git commit -m "Add: your feature description"
git push origin feature/your-feature-name
```

### Testing Guidelines

#### Test Cases to Verify
1. **Basic functionality** with various file types
2. **Duplicate handling** with identical files
3. **Size-based filtering** with large and small files
4. **Error handling** with corrupted or inaccessible files
5. **Permission handling** with read-only files
6. **Large directory performance** (1000+ files)

#### Test Directory Structure
```
test_files/
├── images/
│   ├── photo1.jpg (100KB)
│   ├── photo1.jpg (200KB, different content)
│   └── photo2.png
├── documents/
│   ├── report.pdf
│   └── notes.txt
├── duplicates/
│   ├── photo1.jpg (100KB, same content)
│   └── report.pdf (exact duplicate)
└── problematic/
    ├── no_extension_file
    ├── .hidden_file
    └── large_file.zip (>100MB)
```

### Code Style Guidelines
- Use descriptive variable names
- Add comments for complex logic
- Follow bash best practices (shellcheck compliance)
- Maintain backward compatibility
- Include error handling for all operations

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Inspired by file organization needs in digital asset management
- Thanks to the open-source community for shell scripting best practices
- Special thanks to contributors and testers

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/wsmr/Script-Bash-organize_by_extension/issues)
- **Discussions**: [GitHub Discussions](https://github.com/wsmr/Script-Bash-organize_by_extension/discussions)

[//]: # (- **Email**: your.email@domain.com)

---

**⭐ Star this repository if you find it helpful!**
