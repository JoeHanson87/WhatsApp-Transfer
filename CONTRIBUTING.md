# Contributing to WhatsApp Transfer

Thank you for your interest in contributing to WhatsApp Transfer! This document provides guidelines and information for contributors.

## Table of Contents
- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Project Structure](#project-structure)
- [Coding Standards](#coding-standards)
- [Testing](#testing)
- [Submitting Changes](#submitting-changes)

## Code of Conduct

By participating in this project, you agree to maintain a respectful and inclusive environment for everyone. Be kind, be professional, and help us make this project welcoming to all.

## Getting Started

### Prerequisites

- macOS 13.0 or later
- Xcode 14.0 or later
- Swift 5.0 or later
- Git

### Fork and Clone

1. Fork the repository on GitHub
2. Clone your fork locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/WhatsApp-Transfer.git
   cd WhatsApp-Transfer
   ```
3. Add the upstream remote:
   ```bash
   git remote add upstream https://github.com/JoeHanson87/WhatsApp-Transfer.git
   ```

## Development Setup

### Opening the Project

1. Open the Xcode project:
   ```bash
   open WhatsAppTransfer.xcodeproj
   ```

2. Wait for Xcode to index the project

3. Build the project (⌘+B) to ensure everything compiles

### Installing Development Dependencies

```bash
# Install Android Platform Tools (for testing)
brew install android-platform-tools

# Install libimobiledevice (for iOS device communication)
brew install libimobiledevice

# Install development tools
brew install swiftlint  # Optional: for code linting
```

## Project Structure

```
WhatsAppTransfer/
├── WhatsAppTransfer/
│   ├── WhatsAppTransferApp.swift    # App entry point
│   ├── ContentView.swift            # Main UI
│   ├── DeviceManager.swift          # Device detection & management
│   ├── TransferManager.swift        # Transfer orchestration
│   ├── DatabaseConverter.swift      # Database format conversion
│   ├── Assets.xcassets/             # App assets and icons
│   ├── Info.plist                   # App configuration
│   └── WhatsAppTransfer.entitlements # Security permissions
├── WhatsAppTransfer.xcodeproj/      # Xcode project files
├── README.md                        # Project documentation
├── USERGUIDE.md                     # User documentation
├── CONTRIBUTING.md                  # This file
└── LICENSE                          # MIT License
```

### Key Components

#### WhatsAppTransferApp.swift
- Main app entry point
- SwiftUI App lifecycle management
- Environment object setup

#### ContentView.swift
- Main user interface
- SwiftUI views and components
- User interaction handling

#### DeviceManager.swift
- Android device detection via ADB
- iOS device detection via libimobiledevice
- Real-time device status monitoring

#### TransferManager.swift
- Transfer workflow orchestration
- Progress tracking
- Error handling
- Async operations

#### DatabaseConverter.swift
- WhatsApp database format conversion
- SQLite handling
- Data transformation logic

## Coding Standards

### Swift Style Guide

We follow the [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/). Key points:

#### Naming
- Use clear, descriptive names
- Methods and functions: `camelCase`
- Types and protocols: `PascalCase`
- Use American English spelling

```swift
// Good
func transferWhatsAppData(from android: String, to ios: String)
class DeviceManager

// Avoid
func trans(f: String, t: String)
class DevMgr
```

#### Code Organization
- Group related functionality
- Use `// MARK:` for section organization
- Keep files focused and reasonably sized

```swift
class TransferManager {
    // MARK: - Properties
    @Published var progress: Double = 0.0
    
    // MARK: - Public Methods
    func startTransfer() { }
    
    // MARK: - Private Methods
    private func performTransfer() { }
}
```

#### SwiftUI Best Practices
- Extract complex views into separate structs
- Use `@State` for local view state
- Use `@StateObject` for owned observable objects
- Use `@EnvironmentObject` for shared state

```swift
struct DeviceCard: View {
    let title: String
    let isConnected: Bool
    
    var body: some View {
        VStack {
            // View implementation
        }
    }
}
```

#### Error Handling
- Use `Result` type for success/failure cases
- Create custom error types when appropriate
- Provide meaningful error messages

```swift
enum TransferError: LocalizedError {
    case deviceNotConnected(String)
    case transferFailed(String)
    
    var errorDescription: String? {
        switch self {
        case .deviceNotConnected(let device):
            return "Device not connected: \(device)"
        case .transferFailed(let reason):
            return "Transfer failed: \(reason)"
        }
    }
}
```

#### Comments
- Write self-documenting code
- Add comments for complex logic
- Document public APIs

```swift
/// Converts WhatsApp database from Android format to iOS format
/// - Parameter androidPath: Path to Android database file
/// - Returns: Path to converted iOS database
/// - Throws: ConversionError if conversion fails
func convert(androidPath: String) throws -> String {
    // Implementation
}
```

### Code Formatting

- Indent with 4 spaces (no tabs)
- Line length: 120 characters max (soft limit)
- Add blank lines between logical sections
- Use trailing commas in multi-line arrays/dictionaries

## Testing

### Manual Testing

When making changes, test the following:

1. **Device Detection**
   - Connect/disconnect Android device
   - Connect/disconnect iOS device
   - Verify status updates in UI

2. **Transfer Process**
   - Test with small dataset
   - Test with larger dataset
   - Verify progress updates
   - Check error handling

3. **UI Responsiveness**
   - Verify all buttons work
   - Check progress indicators
   - Test on different screen sizes

### Testing Checklist

Before submitting:
- [ ] Code compiles without warnings
- [ ] App launches successfully
- [ ] Device detection works
- [ ] Transfer process completes
- [ ] UI updates correctly
- [ ] Error messages are clear
- [ ] No memory leaks (use Instruments)

## Submitting Changes

### Branch Naming

Use descriptive branch names:
- `feature/add-backup-verification`
- `bugfix/fix-device-detection`
- `docs/update-readme`
- `refactor/improve-database-converter`

### Commit Messages

Write clear, descriptive commit messages:

```
Short summary (50 chars or less)

More detailed explanation if needed. Wrap at 72 characters.
Explain what changed and why, not just what you did.

- Bullet points are okay
- Use present tense: "Add feature" not "Added feature"
- Reference issues: Fixes #123
```

Good examples:
```
Add progress indicator to database conversion

Improve device detection reliability

Fix crash when iOS device disconnects during transfer
```

### Pull Request Process

1. **Sync your fork**
   ```bash
   git fetch upstream
   git checkout main
   git merge upstream/main
   ```

2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make your changes**
   - Follow coding standards
   - Test thoroughly
   - Update documentation if needed

4. **Commit your changes**
   ```bash
   git add .
   git commit -m "Your descriptive commit message"
   ```

5. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```

6. **Create Pull Request**
   - Go to GitHub and create a PR
   - Fill in the PR template
   - Link related issues
   - Add screenshots for UI changes

### PR Description Template

```markdown
## Description
Brief description of what this PR does

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Code refactoring

## Changes Made
- Change 1
- Change 2
- Change 3

## Testing
Describe how you tested these changes

## Screenshots (if applicable)
Add screenshots for UI changes

## Related Issues
Fixes #123
Related to #456
```

## Areas for Contribution

### High Priority
- Improve database conversion logic
- Add support for encrypted Android backups
- Enhance error handling and recovery
- Add unit tests
- Improve iOS restore process

### Medium Priority
- Add logging system
- Improve UI/UX
- Add preferences/settings panel
- Support for WhatsApp Business
- Progress persistence (resume interrupted transfers)

### Documentation
- Improve code documentation
- Add more examples to user guide
- Create video tutorials
- Translate documentation

### Testing
- Add unit tests
- Add integration tests
- Test on different device combinations
- Performance testing with large datasets

## Getting Help

If you need help:

1. Check existing documentation
2. Look at similar code in the project
3. Open an issue with your question
4. Tag your PR as "help wanted" if stuck

## Recognition

Contributors will be recognized in:
- GitHub contributors list
- README acknowledgments
- Release notes

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing to WhatsApp Transfer! 🙌
