//
//  WhatsAppTransferApp.swift
//  WhatsAppTransfer
//
//  A MacOS application for transferring WhatsApp chat history from Android to iOS
//

import SwiftUI

@main
struct WhatsAppTransferApp: App {
    @StateObject private var deviceManager = DeviceManager()
    @StateObject private var transferManager = TransferManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(deviceManager)
                .environmentObject(transferManager)
                .frame(minWidth: 800, minHeight: 600)
        }
        .windowStyle(.hiddenTitleBar)
        .commands {
            CommandGroup(replacing: .newItem) { }
        }
    }
}
