#!/bin/bash

# Build script for WhatsApp Transfer
# This script builds the MacOS application using xcodebuild

set -e

echo "🚀 Building WhatsApp Transfer..."

# Check if xcodebuild is available
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Error: xcodebuild not found. Please run this on macOS with Xcode installed."
    exit 1
fi

# Configuration
PROJECT="WhatsAppTransfer.xcodeproj"
SCHEME="WhatsAppTransfer"
CONFIGURATION="Release"
BUILD_DIR="build"

# Clean previous builds
echo "🧹 Cleaning previous builds..."
rm -rf "$BUILD_DIR"

# Build the application
echo "🔨 Building application..."
xcodebuild \
    -project "$PROJECT" \
    -scheme "$SCHEME" \
    -configuration "$CONFIGURATION" \
    -derivedDataPath "$BUILD_DIR" \
    clean build

echo "✅ Build completed successfully!"
echo "📦 Application located at: $BUILD_DIR/Build/Products/$CONFIGURATION/WhatsAppTransfer.app"
