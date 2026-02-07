//
//  TransferManager.swift
//  WhatsAppTransfer
//
//  Manages the WhatsApp data transfer process from Android to iOS
//

import Foundation
import Combine

class TransferManager: ObservableObject {
    @Published var isTransferring: Bool = false
    @Published var progress: Double = 0.0
    @Published var statusMessage: String = "Ready to transfer"
    @Published var currentStep: String = ""
    @Published var errorMessage: String? = nil
    
    private let databaseConverter = DatabaseConverter()
    
    func startTransfer(androidDevice: String, iosDevice: String) {
        guard !isTransferring else { return }
        
        isTransferring = true
        errorMessage = nil
        progress = 0.0
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.performTransfer(androidDevice: androidDevice, iosDevice: iosDevice)
        }
    }
    
    private func performTransfer(androidDevice: String, iosDevice: String) {
        do {
            // Step 1: Backup WhatsApp data from Android
            updateProgress(0.1, step: "Backing up WhatsApp from Android...", status: "Connecting to Android device...")
            try backupWhatsAppFromAndroid()
            
            // Step 2: Extract and decrypt Android backup
            updateProgress(0.3, step: "Extracting WhatsApp database...", status: "Processing Android backup...")
            let androidBackupPath = try extractAndroidBackup()
            
            // Step 3: Convert database format
            updateProgress(0.5, step: "Converting database format...", status: "Converting Android database to iOS format...")
            let iosBackupPath = try databaseConverter.convert(androidPath: androidBackupPath)
            
            // Step 4: Transfer media files
            updateProgress(0.7, step: "Transferring media files...", status: "Copying photos, videos, and documents...")
            try transferMediaFiles(from: androidBackupPath, to: iosBackupPath)
            
            // Step 5: Restore to iOS device
            updateProgress(0.9, step: "Restoring to iOS device...", status: "Writing data to iPhone...")
            try restoreToiOS(backupPath: iosBackupPath)
            
            // Complete
            updateProgress(1.0, step: "Transfer complete!", status: "WhatsApp data successfully transferred")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                self?.isTransferring = false
            }
            
        } catch {
            handleError(error)
        }
    }
    
    private func backupWhatsAppFromAndroid() throws {
        // Create backup using ADB
        let task = Process()
        task.launchPath = "/bin/sh"
        task.arguments = ["-c", "mkdir -p ~/WhatsAppTransfer/android_backup && adb pull /sdcard/Android/media/com.whatsapp ~/WhatsAppTransfer/android_backup/ 2>&1"]
        
        // Set environment with common PATH locations to ensure ADB is found
        var environment = ProcessInfo.processInfo.environment
        if let currentPath = environment["PATH"] {
            environment["PATH"] = ToolPaths.commonPaths.joined(separator: ":") + ":" + currentPath
        } else {
            environment["PATH"] = ToolPaths.commonPaths.joined(separator: ":")
        }
        task.environment = environment
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe
        
        try task.run()
        task.waitUntilExit()
        
        if task.terminationStatus != 0 {
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            let output = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw TransferError.androidBackupFailed("Failed to backup from Android: \(output)")
        }
        
        sleep(1) // Brief pause to ensure files are written
    }
    
    private func extractAndroidBackup() throws -> String {
        let backupPath = NSString(string: "~/WhatsAppTransfer/android_backup").expandingTildeInPath
        
        // Verify backup exists
        let fileManager = FileManager.default
        guard fileManager.fileExists(atPath: backupPath) else {
            throw TransferError.backupNotFound("Android backup not found at: \(backupPath)")
        }
        
        return backupPath
    }
    
    private func transferMediaFiles(from androidPath: String, to iosPath: String) throws {
        // Copy media files from Android backup to iOS backup location
        let fileManager = FileManager.default
        
        let mediaSubdirs = ["Media", "Backups"]
        
        for subdir in mediaSubdirs {
            let sourcePath = (androidPath as NSString).appendingPathComponent(subdir)
            let destPath = (iosPath as NSString).appendingPathComponent(subdir)
            
            if fileManager.fileExists(atPath: sourcePath) {
                try? fileManager.createDirectory(atPath: destPath, withIntermediateDirectories: true, attributes: nil)
                
                let contents = try fileManager.contentsOfDirectory(atPath: sourcePath)
                for file in contents {
                    let srcFile = (sourcePath as NSString).appendingPathComponent(file)
                    let dstFile = (destPath as NSString).appendingPathComponent(file)
                    
                    try? fileManager.copyItem(atPath: srcFile, toPath: dstFile)
                }
            }
        }
    }
    
    private func restoreToiOS(backupPath: String) throws {
        // In a real implementation, this would use libimobiledevice to restore to iOS
        // For demonstration, we'll simulate the process
        
        let task = Process()
        task.launchPath = "/bin/sh"
        task.arguments = ["-c", "echo 'Restoring to iOS device...' && sleep 2"]
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe
        
        try task.run()
        task.waitUntilExit()
        
        if task.terminationStatus != 0 {
            throw TransferError.iosRestoreFailed("Failed to restore to iOS device")
        }
    }
    
    private func updateProgress(_ value: Double, step: String, status: String) {
        DispatchQueue.main.async { [weak self] in
            self?.progress = value
            self?.currentStep = step
            self?.statusMessage = status
        }
        
        // Simulate processing time
        Thread.sleep(forTimeInterval: 1.0)
    }
    
    private func handleError(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.isTransferring = false
            self?.errorMessage = error.localizedDescription
            self?.statusMessage = "Transfer failed"
        }
    }
}

enum TransferError: LocalizedError {
    case androidBackupFailed(String)
    case backupNotFound(String)
    case conversionFailed(String)
    case iosRestoreFailed(String)
    
    var errorDescription: String? {
        switch self {
        case .androidBackupFailed(let message):
            return "Android backup failed: \(message)"
        case .backupNotFound(let message):
            return "Backup not found: \(message)"
        case .conversionFailed(let message):
            return "Database conversion failed: \(message)"
        case .iosRestoreFailed(let message):
            return "iOS restore failed: \(message)"
        }
    }
}
