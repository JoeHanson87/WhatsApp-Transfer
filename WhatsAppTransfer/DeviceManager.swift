//
//  DeviceManager.swift
//  WhatsAppTransfer
//
//  Manages device detection and connection for Android and iOS devices
//

import Foundation
import Combine

// Helper extension for expanding tilde in paths
extension String {
    var expandingTildeInPath: String {
        return NSString(string: self).expandingTildeInPath
    }
}

class DeviceManager: ObservableObject {
    @Published var androidConnected: Bool = false
    @Published var iosConnected: Bool = false
    @Published var androidDeviceInfo: String? = nil
    @Published var iosDeviceInfo: String? = nil
    
    private var timer: Timer?
    
    init() {
        startMonitoring()
    }
    
    deinit {
        stopMonitoring()
    }
    
    func startMonitoring() {
        // Initial check
        refreshDevices()
        
        // Set up periodic checking every 3 seconds
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
            self?.refreshDevices()
        }
    }
    
    func stopMonitoring() {
        timer?.invalidate()
        timer = nil
    }
    
    func refreshDevices() {
        checkAndroidDevice()
        checkiOSDevice()
    }
    
    // Helper function to find an executable in multiple paths
    private func findExecutable(name: String, paths: [String]) -> String? {
        let fileManager = FileManager.default
        
        // Check each provided path
        for path in paths {
            if fileManager.isExecutableFile(atPath: path) {
                return path
            }
        }
        
        // Fallback: try using 'which' with full PATH environment
        let task = Process()
        task.launchPath = "/bin/sh"
        task.arguments = ["-c", "which \(name)"]
        
        // Set environment with common PATH locations
        var environment = ProcessInfo.processInfo.environment
        let additionalPaths = ["/opt/homebrew/bin", "/usr/local/bin", "/usr/bin"]
        if let currentPath = environment["PATH"] {
            environment["PATH"] = additionalPaths.joined(separator: ":") + ":" + currentPath
        } else {
            environment["PATH"] = additionalPaths.joined(separator: ":")
        }
        task.environment = environment
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = Pipe()
        
        do {
            try task.run()
            task.waitUntilExit()
            
            if task.terminationStatus == 0 {
                let data = pipe.fileHandleForReading.readDataToEndOfFile()
                if let output = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines),
                   !output.isEmpty {
                    return output
                }
            }
        } catch {
            // Ignore errors and return nil
        }
        
        return nil
    }
    
    private func checkAndroidDevice() {
        // Check for Android devices using ADB
        // Check common installation paths for ADB (Homebrew and system locations)
        let adbPath = findExecutable(name: "adb", paths: [
            "/opt/homebrew/bin/adb",      // Homebrew on Apple Silicon
            "/usr/local/bin/adb",         // Homebrew on Intel
            "/usr/bin/adb",               // System installation
            "~/Library/Android/sdk/platform-tools/adb".expandingTildeInPath  // Android SDK
        ])
        
        if let path = adbPath {
            // ADB is available, check for devices
            checkADBDevices(adbPath: path)
        } else {
            DispatchQueue.main.async {
                self.androidConnected = false
                self.androidDeviceInfo = "ADB not found - Please install Android Platform Tools"
            }
        }
    }
    
    private func checkADBDevices(adbPath: String) {
        let task = Process()
        task.launchPath = "/bin/sh"
        task.arguments = ["-c", "\(adbPath) devices -l | grep -v 'List of devices' | grep -v '^$' | grep 'device'"]
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = Pipe()
        
        do {
            try task.run()
            task.waitUntilExit()
            
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            let output = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            
            DispatchQueue.main.async {
                if !output.isEmpty && task.terminationStatus == 0 {
                    self.androidConnected = true
                    // Parse device info
                    if let firstLine = output.components(separatedBy: "\n").first {
                        let components = firstLine.components(separatedBy: " ")
                        if let model = components.first(where: { $0.hasPrefix("model:") }) {
                            let modelName = model.replacingOccurrences(of: "model:", with: "")
                            self.androidDeviceInfo = "Model: \(modelName)"
                        } else {
                            self.androidDeviceInfo = "Android device connected"
                        }
                    }
                } else {
                    self.androidConnected = false
                    self.androidDeviceInfo = nil
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.androidConnected = false
                self.androidDeviceInfo = nil
            }
        }
    }
    
    private func checkiOSDevice() {
        // Check for iOS devices using ideviceinfo (from libimobiledevice)
        // Check common installation paths for ideviceinfo (Homebrew locations)
        let ideviceinfoPath = findExecutable(name: "ideviceinfo", paths: [
            "/opt/homebrew/bin/ideviceinfo",  // Homebrew on Apple Silicon
            "/usr/local/bin/ideviceinfo",     // Homebrew on Intel
            "/usr/bin/ideviceinfo"            // System installation (rare)
        ])
        
        if let path = ideviceinfoPath {
            // ideviceinfo is available, check for devices
            checkiOSDeviceInfo(ideviceinfoPath: path)
        } else {
            DispatchQueue.main.async {
                self.iosConnected = false
                self.iosDeviceInfo = "libimobiledevice not found - Please install via Homebrew"
            }
        }
    }
    
    private func checkiOSDeviceInfo(ideviceinfoPath: String) {
        let task = Process()
        task.launchPath = "/bin/sh"
        task.arguments = ["-c", "\(ideviceinfoPath) -k DeviceName"]
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = Pipe()
        
        do {
            try task.run()
            task.waitUntilExit()
            
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            let output = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            
            DispatchQueue.main.async {
                if !output.isEmpty && task.terminationStatus == 0 {
                    self.iosConnected = true
                    self.iosDeviceInfo = "Device: \(output)"
                } else {
                    self.iosConnected = false
                    self.iosDeviceInfo = nil
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.iosConnected = false
                self.iosDeviceInfo = nil
            }
        }
    }
}
