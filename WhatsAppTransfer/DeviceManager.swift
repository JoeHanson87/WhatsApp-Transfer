//
//  DeviceManager.swift
//  WhatsAppTransfer
//
//  Manages device detection and connection for Android and iOS devices
//

import Foundation
import Combine

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
    
    private func checkAndroidDevice() {
        // Check for Android devices using ADB
        let task = Process()
        task.launchPath = "/usr/bin/which"
        task.arguments = ["adb"]
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = Pipe()
        
        do {
            try task.run()
            task.waitUntilExit()
            
            if task.terminationStatus == 0 {
                // ADB is available, check for devices
                checkADBDevices()
            } else {
                DispatchQueue.main.async {
                    self.androidConnected = false
                    self.androidDeviceInfo = "ADB not found - Please install Android Platform Tools"
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.androidConnected = false
                self.androidDeviceInfo = "Error checking for ADB"
            }
        }
    }
    
    private func checkADBDevices() {
        let task = Process()
        task.launchPath = "/bin/sh"
        task.arguments = ["-c", "adb devices -l | grep -v 'List of devices' | grep -v '^$' | grep 'device'"]
        
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
        let task = Process()
        task.launchPath = "/usr/bin/which"
        task.arguments = ["ideviceinfo"]
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = Pipe()
        
        do {
            try task.run()
            task.waitUntilExit()
            
            if task.terminationStatus == 0 {
                // ideviceinfo is available, check for devices
                checkiOSDeviceInfo()
            } else {
                DispatchQueue.main.async {
                    self.iosConnected = false
                    self.iosDeviceInfo = "libimobiledevice not found - Please install via Homebrew"
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.iosConnected = false
                self.iosDeviceInfo = "Error checking for libimobiledevice"
            }
        }
    }
    
    private func checkiOSDeviceInfo() {
        let task = Process()
        task.launchPath = "/bin/sh"
        task.arguments = ["-c", "ideviceinfo -k DeviceName"]
        
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
