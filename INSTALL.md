# Installation Guide

## Quick Start

### For Users

#### Prerequisites
Install the required command-line tools:

```bash
# Install Homebrew (if not already installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Android Platform Tools
brew install android-platform-tools

# Install libimobiledevice
brew install libimobiledevice
```

#### Download and Install

**Option 1: Download Pre-built App (Recommended)**
1. Go to [Releases](https://github.com/JoeHanson87/WhatsApp-Transfer/releases)
2. Download the latest `.dmg` file
3. Open the `.dmg` file
4. Drag WhatsApp Transfer to your Applications folder
5. Open WhatsApp Transfer from Applications

**Option 2: Build from Source**
See [Build Instructions](#for-developers) below.

### For Developers

#### Requirements
- macOS 13.0 (Ventura) or later
- Xcode 14.0 or later
- Command Line Tools for Xcode

#### Clone Repository
```bash
git clone https://github.com/JoeHanson87/WhatsApp-Transfer.git
cd WhatsApp-Transfer
```

#### Build with Xcode

1. **Open the project:**
   ```bash
   open WhatsAppTransfer.xcodeproj
   ```

2. **Select target:**
   - Select "WhatsAppTransfer" scheme
   - Select "My Mac" as destination

3. **Build:**
   - Press ⌘+B to build
   - Press ⌘+R to build and run

#### Build from Command Line

```bash
# Run the build script
./build.sh

# Or use xcodebuild directly
xcodebuild -project WhatsAppTransfer.xcodeproj \
           -scheme WhatsAppTransfer \
           -configuration Release \
           clean build
```

#### Build Output
The built application will be located at:
```
build/Build/Products/Release/WhatsAppTransfer.app
```

#### Run the App
```bash
open build/Build/Products/Release/WhatsAppTransfer.app
```

## Configuration

### Android Setup
1. Enable Developer Options on your Android device
2. Enable USB Debugging
3. Connect via USB and authorize the computer

### iOS Setup
1. Connect iPhone via USB
2. Trust the computer when prompted
3. Keep device unlocked during transfer

## Troubleshooting Installation

### Command-line Tools Issues

**ADB not working:**
```bash
# Check ADB installation
which adb

# Test ADB
adb version

# If not working, reinstall
brew reinstall android-platform-tools
```

**libimobiledevice not working:**
```bash
# Check installation
which ideviceinfo

# Test with connected device
ideviceinfo -k DeviceName

# If not working, reinstall
brew reinstall libimobiledevice
```

### Build Issues

**"xcodebuild: command not found"**
- Install Xcode from Mac App Store
- Install Command Line Tools: `xcode-select --install`

**"No scheme named WhatsAppTransfer"**
- Open project in Xcode first
- Xcode will create the scheme automatically

**Code signing errors:**
- Open project in Xcode
- Go to project settings
- Under "Signing & Capabilities", select your development team
- Or change "Code Sign Identity" to "Sign to Run Locally"

**Build errors:**
- Clean build folder: ⌘+Shift+K in Xcode
- Or: `rm -rf build/`
- Then rebuild

### macOS Gatekeeper Issues

If macOS prevents opening the app:

1. Right-click the app and select "Open"
2. Click "Open" in the dialog
3. Or disable Gatekeeper temporarily:
   ```bash
   sudo spctl --master-disable
   ```
   
To re-enable Gatekeeper:
```bash
sudo spctl --master-enable
```

## Updating

### Update Pre-built App
1. Download new version from Releases
2. Replace old app in Applications folder
3. Restart the app

### Update Source Code
```bash
git pull origin main
open WhatsAppTransfer.xcodeproj
# Build and run
```

## Uninstallation

### Remove the App
```bash
# Remove app
rm -rf /Applications/WhatsAppTransfer.app

# Remove temporary transfer files (optional)
rm -rf ~/WhatsAppTransfer/
```

### Remove Dependencies (Optional)
```bash
# Only if you don't need these tools for other purposes
brew uninstall android-platform-tools
brew uninstall libimobiledevice
```

## Verifying Installation

Run these commands to verify everything is set up:

```bash
# Check ADB
adb version
# Should show: Android Debug Bridge version X.X.X

# Check libimobiledevice
ideviceinfo --version
# Should show version number

# With Android device connected
adb devices
# Should list your device

# With iOS device connected
ideviceinfo -k DeviceName
# Should show your iPhone's name
```

## Next Steps

After installation:
1. Read the [User Guide](USERGUIDE.md)
2. Connect your devices
3. Launch WhatsApp Transfer
4. Follow the in-app instructions

## Getting Help

- Check [User Guide](USERGUIDE.md) for usage help
- See [README](README.md) for overview
- Report issues on [GitHub Issues](https://github.com/JoeHanson87/WhatsApp-Transfer/issues)

---

Need more help? Open an issue with:
- macOS version
- Xcode version (if building from source)
- Error messages
- Steps you've tried
