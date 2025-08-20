#!/bin/bash

# Flutter Build and Dropbox Upload Script
# This script builds a Flutter APK and uploads it to Dropbox

echo "Starting Flutter APK build and upload process..."
echo "================================================"

# Build the Flutter APK
echo "Building Flutter APK..."
flutter build apk

# Check if the build was successful
if [ $? -eq 0 ]; then
    echo "✅ Flutter APK build completed successfully!"
    echo ""
    
    # Execute the Python script to upload to Dropbox
    echo "Starting Dropbox upload..."
    python3 upload_to_dropbox.py
    
    # Check if the upload was successful
    if [ $? -eq 0 ]; then
        echo "✅ Upload to Dropbox completed successfully!"
        echo ""
        echo "🎉 Process completed! Your APK has been built and uploaded to Dropbox."
    else
        echo "❌ Error: Failed to upload APK to Dropbox"
        exit 1
    fi
else
    echo "❌ Error: Flutter build failed"
    exit 1
fi

echo "================================================"
echo "Script execution completed."