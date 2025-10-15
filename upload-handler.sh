#!/bin/sh
UPLOAD_DIR="/var/www/uploads"
TMP_TAR="/tmp/uploads/upload.tar"

mkdir -p "$UPLOAD_DIR"

# Read uploaded tar to a file
cat > "$TMP_TAR"

# Clean old contents
find "$UPLOAD_DIR" -mindepth 1 -not -name "$(basename "$TMP_TAR")" -exec rm -rf {} +

# Extract new archive
tar -xf "$TMP_TAR" -C "$UPLOAD_DIR"

# Remove the tar file
rm -f "$TMP_TAR"

# FastCGI response
echo "Content-Type: text/plain"
echo ""
echo "Upload and extraction completed. Old files removed."
