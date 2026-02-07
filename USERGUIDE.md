# User Guide - WhatsApp Transfer

## Table of Contents
1. [Getting Started](#getting-started)
2. [Device Setup](#device-setup)
3. [Transfer Process](#transfer-process)
4. [Troubleshooting](#troubleshooting)
5. [FAQ](#faq)

## Getting Started

### Installation

#### Prerequisites
Before using WhatsApp Transfer, install the required tools:

```bash
# Install Android Platform Tools
brew install android-platform-tools

# Install libimobiledevice for iOS
brew install libimobiledevice
```

#### Verify Installation
```bash
# Verify ADB is installed
adb version

# Verify libimobiledevice is installed
ideviceinfo --version
```

## Device Setup

### Setting Up Android Device

1. **Enable Developer Options**
   - Go to Settings > About Phone
   - Tap "Build Number" 7 times
   - Developer options will now appear in Settings

2. **Enable USB Debugging**
   - Go to Settings > Developer Options
   - Enable "USB Debugging"
   - Connect device to Mac via USB
   - Accept the "Allow USB Debugging" prompt on your phone

3. **Verify Connection**
   ```bash
   adb devices
   ```
   Your device should appear in the list.

### Setting Up iOS Device

1. **Connect iPhone**
   - Connect your iPhone to Mac via USB cable
   - Unlock your iPhone
   - When prompted, tap "Trust This Computer"
   - Enter your iPhone passcode if requested

2. **Verify Connection**
   ```bash
   ideviceinfo -k DeviceName
   ```
   Your iPhone's name should be displayed.

## Transfer Process

### Before You Start

- ✅ Ensure both devices have sufficient battery (recommend 50%+)
- ✅ Close WhatsApp on both devices
- ✅ Ensure stable USB connections (avoid extension cables if possible)
- ✅ Verify you have enough storage space on your iPhone

### Step-by-Step Transfer

1. **Launch Application**
   - Open WhatsApp Transfer app
   - Wait for device detection

2. **Verify Device Status**
   - Check that both Android and iOS devices show "Connected"
   - Review device information displayed
   - If devices not detected, click "Refresh Devices"

3. **Initiate Transfer**
   - Click "Start Transfer" button
   - Read and confirm the transfer dialog
   - Do not disconnect devices during transfer

4. **Monitor Progress**
   - Watch the progress bar for status updates
   - Transfer steps:
     - Backing up from Android (10%)
     - Extracting database (30%)
     - Converting format (50%)
     - Transferring media (70%)
     - Restoring to iOS (90%)
     - Complete (100%)

5. **Completion**
   - Wait for "Transfer Complete" message
   - Safely disconnect devices
   - Open WhatsApp on iPhone to verify

### Post-Transfer

1. **Verify Data**
   - Open WhatsApp on your iPhone
   - Check recent conversations
   - Verify media files loaded correctly
   - Confirm contact information is intact

2. **Clean Up (Optional)**
   - Original Android data remains unchanged
   - You can continue using WhatsApp on Android if desired
   - Or uninstall WhatsApp from Android

## Troubleshooting

### Common Issues

#### "ADB not found"
**Problem**: Android Platform Tools not installed
**Solution**: 
```bash
brew install android-platform-tools
```

#### "libimobiledevice not found"
**Problem**: iOS tools not installed
**Solution**:
```bash
brew install libimobiledevice
```

#### Android Device Not Detected
**Possible Causes**:
- USB debugging not enabled
- USB cable issue
- Device not authorized

**Solutions**:
1. Revoke USB debugging authorizations on Android:
   - Settings > Developer Options > Revoke USB Debugging Authorizations
   - Reconnect and re-authorize

2. Try different USB cable or port

3. Restart ADB:
   ```bash
   adb kill-server
   adb start-server
   ```

#### iOS Device Not Detected
**Possible Causes**:
- Device not trusted
- Device locked
- Lightning cable issue

**Solutions**:
1. Ensure device is unlocked
2. Reconnect and tap "Trust" again
3. Try different cable or USB port
4. Restart device pairing:
   ```bash
   idevicepair unpair
   idevicepair pair
   ```

#### Transfer Failed Midway
**Possible Causes**:
- Device disconnected
- Insufficient storage
- WhatsApp running

**Solutions**:
1. Ensure WhatsApp is closed on both devices
2. Check storage space on iPhone
3. Keep devices connected and unlocked
4. Try transfer again

#### Database Encrypted Error
**Problem**: Android WhatsApp database is encrypted
**Solution**:
1. Open WhatsApp on Android
2. Go to Settings > Chats > Chat Backup
3. Create a local unencrypted backup first
4. Try transfer again

### Advanced Troubleshooting

#### Check Android Backup Location
```bash
adb shell ls -la /sdcard/Android/media/com.whatsapp/
```

#### Manual Database Check
```bash
# Check if msgstore.db exists
adb shell ls -la /data/data/com.whatsapp/databases/

# If encrypted, look for key file
adb shell ls -la /data/data/com.whatsapp/files/key
```

#### Check iOS Device Info
```bash
# Get device name
ideviceinfo -k DeviceName

# Check iOS version
ideviceinfo -k ProductVersion

# Verify WhatsApp installation
ideviceinstaller -l | grep -i whatsapp
```

## FAQ

### General Questions

**Q: Will this delete data from my Android phone?**
A: No, the transfer process does not delete any data from your Android device. Your WhatsApp data remains intact.

**Q: How long does the transfer take?**
A: Transfer time depends on the amount of data. Typically:
- Small (< 1GB): 5-10 minutes
- Medium (1-5GB): 15-30 minutes
- Large (> 5GB): 30-60 minutes

**Q: Can I use my phone during the transfer?**
A: It's recommended to keep both devices connected and avoid using them during the transfer to prevent interruption.

**Q: Will group chats be transferred?**
A: Yes, all individual chats and group chats will be transferred, including group media.

**Q: What about WhatsApp Business?**
A: This tool is designed for regular WhatsApp. WhatsApp Business may require additional steps.

### Technical Questions

**Q: What data is transferred?**
A: The following data is transferred:
- Text messages
- Images and photos
- Videos
- Voice messages
- Documents
- Contact information
- Chat metadata (timestamps, read status, etc.)

**Q: What is NOT transferred?**
A: The following are not transferred:
- Call history (WhatsApp calls)
- Payment history
- Settings and preferences
- Notification preferences

**Q: Does this work with encrypted backups?**
A: The app works best with unencrypted local backups. If your Android backup is encrypted, you may need to create an unencrypted version first.

**Q: Can I transfer from iOS to Android?**
A: This version supports Android to iOS transfers only. iOS to Android transfers require a different implementation.

**Q: Is this officially supported by WhatsApp?**
A: This is an independent third-party tool. For official transfer methods, refer to WhatsApp's "Move to iOS" feature.

### Safety & Privacy

**Q: Is my data safe?**
A: Yes. All processing happens locally on your Mac. No data is uploaded to external servers.

**Q: Do you store my messages?**
A: No. The application does not store, log, or transmit any of your messages or media.

**Q: Can I reverse the transfer?**
A: Data is not deleted from Android, so you can continue using WhatsApp there. However, changes made on iOS after transfer won't sync back to Android.

## Getting Help

If you encounter issues not covered in this guide:

1. **Check GitHub Issues**: [WhatsApp-Transfer Issues](https://github.com/JoeHanson87/WhatsApp-Transfer/issues)
2. **Open New Issue**: Provide details about your problem, including:
   - macOS version
   - Android device model and OS version
   - iOS device model and iOS version
   - Error messages received
   - Steps already tried

## Tips for Success

✅ **Do's**
- Use original USB cables when possible
- Keep devices connected throughout transfer
- Close WhatsApp on both devices
- Ensure sufficient storage on iPhone
- Backup your data before transfer

❌ **Don'ts**
- Don't use devices during transfer
- Don't disconnect devices mid-transfer
- Don't use USB hubs if experiencing issues
- Don't interrupt the process
- Don't have WhatsApp open during transfer

---

For more information, see the main [README.md](README.md) file.
