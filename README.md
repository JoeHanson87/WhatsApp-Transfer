# WhatsApp Transfer

A powerful MacOS application for transferring WhatsApp chat history from Android devices to iOS devices.

## Overview

WhatsApp Transfer is a native MacOS application built with Swift and SwiftUI that enables you to transfer your complete WhatsApp chat history, including messages, media files, and attachments, from an Android phone to an iPhone.

## Features

- ✅ **Complete Data Transfer**: Transfer all WhatsApp messages, photos, videos, and documents
- ✅ **User-Friendly Interface**: Modern, intuitive SwiftUI interface with real-time progress tracking
- ✅ **Device Detection**: Automatic detection of connected Android and iOS devices
- ✅ **Safe Transfer**: Non-destructive transfer - your Android data remains intact
- ✅ **Database Conversion**: Automatic conversion from Android SQLite format to iOS format
- ✅ **Media Support**: Full support for all media types including images, videos, audio, and documents

## Requirements

### System Requirements
- macOS 13.0 (Ventura) or later
- Xcode 14.0 or later (for building from source)

### Prerequisites

Before using WhatsApp Transfer, you need to install the following tools:

1. **Android Platform Tools (ADB)**
   ```bash
   brew install android-platform-tools
   ```

2. **libimobiledevice** (for iOS device communication)
   ```bash
   brew install libimobiledevice
   ```

3. **ideviceinstaller** (optional, for advanced iOS operations)
   ```bash
   brew install ideviceinstaller
   ```

### Device Requirements

#### Android Device
- USB debugging must be enabled
- WhatsApp must be installed and set up
- USB cable for connection to Mac

#### iOS Device
- iPhone running iOS 12 or later
- WhatsApp must be installed
- USB cable for connection to Mac
- Device must be unlocked and trusted on the Mac

## Installation

### Option 1: Download Pre-built App (Coming Soon)
Download the latest release from the [Releases](https://github.com/JoeHanson87/WhatsApp-Transfer/releases) page.

### Option 2: Build from Source

1. Clone the repository:
   ```bash
   git clone https://github.com/JoeHanson87/WhatsApp-Transfer.git
   cd WhatsApp-Transfer
   ```

2. Open the project in Xcode:
   ```bash
   open WhatsAppTransfer.xcodeproj
   ```

3. Build and run the project (⌘+R)

## Usage

### Step-by-Step Guide

1. **Prepare Your Android Device**
   - Enable USB debugging in Developer Options
   - Connect your Android device to your Mac via USB
   - Accept the USB debugging prompt on your Android device

2. **Prepare Your iOS Device**
   - Connect your iPhone to your Mac via USB
   - Unlock your iPhone
   - Tap "Trust" when prompted on your iPhone

3. **Launch WhatsApp Transfer**
   - Open the WhatsApp Transfer application
   - The app will automatically detect connected devices
   - Verify that both devices show as "Connected"

4. **Start the Transfer**
   - Click the "Start Transfer" button
   - Confirm the transfer when prompted
   - Wait for the process to complete (this may take several minutes)

5. **Verify on iOS**
   - Open WhatsApp on your iPhone
   - Verify that your chat history has been transferred

### Transfer Process

The transfer happens in the following steps:

1. **Backup from Android**: Extracts WhatsApp data from the Android device
2. **Database Extraction**: Extracts and processes the WhatsApp database
3. **Format Conversion**: Converts Android database format to iOS-compatible format
4. **Media Transfer**: Copies all media files (photos, videos, documents)
5. **Restore to iOS**: Writes the converted data to the iPhone

## Troubleshooting

### Android Device Not Detected

- Ensure USB debugging is enabled on your Android device
- Try using a different USB cable or port
- Verify ADB is installed: `which adb`
- Check ADB can see your device: `adb devices`

### iOS Device Not Detected

- Make sure you've trusted the computer on your iPhone
- Verify libimobiledevice is installed: `which ideviceinfo`
- Check if device is visible: `ideviceinfo -k DeviceName`
- Try disconnecting and reconnecting the device

### Transfer Failed

- Ensure both devices remain connected during the transfer
- Check that both devices are unlocked
- Verify sufficient storage space on the iOS device
- Make sure WhatsApp is closed on both devices during transfer

### Database Encryption Issues

If your Android WhatsApp database is encrypted, you may need to:
1. Create an unencrypted backup in WhatsApp settings
2. Or use WhatsApp's built-in export feature first

## Technical Details

### Architecture

- **Swift/SwiftUI**: Modern native MacOS application
- **Device Management**: Uses ADB for Android and libimobiledevice for iOS
- **Database Conversion**: Converts SQLite databases between Android and iOS formats
- **Multi-threaded**: Asynchronous operations for smooth UI experience

### Data Processing

1. **Android Backup**: Uses ADB to pull WhatsApp data directory
2. **Database Reading**: Reads Android SQLite database format
3. **Data Transformation**: Converts timestamps, message formats, and media references
4. **iOS Writing**: Creates iOS-compatible database structure
5. **Media Transfer**: Copies all media files maintaining directory structure

## Privacy & Security

- All processing happens locally on your Mac
- No data is sent to external servers
- No analytics or tracking
- Your data remains private throughout the transfer

## Limitations

- Both devices must be connected via USB during transfer
- Transfer time depends on the amount of data
- Some features may require WhatsApp to be closed during transfer
- Encrypted databases need to be decrypted first

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Disclaimer

This application is not affiliated with, endorsed by, or associated with WhatsApp Inc. or Meta Platforms, Inc. Use at your own risk. Always backup your data before performing transfers.

## Support

For issues, questions, or suggestions, please open an issue on [GitHub Issues](https://github.com/JoeHanson87/WhatsApp-Transfer/issues).

## Acknowledgments

- Built with Swift and SwiftUI
- Uses Android Platform Tools (ADB)
- Uses libimobiledevice for iOS communication

---

**Note**: This is an independent project created to help users migrate their WhatsApp data between platforms. Please ensure you comply with WhatsApp's Terms of Service when using this tool.
