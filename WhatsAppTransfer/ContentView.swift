//
//  ContentView.swift
//  WhatsAppTransfer
//
//  Main user interface for the WhatsApp Transfer application
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var deviceManager: DeviceManager
    @EnvironmentObject var transferManager: TransferManager
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Image(systemName: "arrow.left.arrow.right.circle.fill")
                    .font(.system(size: 32))
                    .foregroundColor(.green)
                Text("WhatsApp Transfer")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding()
            .background(Color(NSColor.controlBackgroundColor))
            
            Divider()
            
            // Main Content
            ScrollView {
                VStack(spacing: 30) {
                    // Instructions
                    InstructionsView()
                    
                    Divider()
                    
                    // Device Status
                    DeviceStatusView()
                    
                    Divider()
                    
                    // Transfer Controls
                    TransferControlsView()
                }
                .padding()
            }
            
            Divider()
            
            // Footer with status
            HStack {
                Image(systemName: transferManager.isTransferring ? "arrow.clockwise.circle.fill" : "checkmark.circle.fill")
                    .foregroundColor(transferManager.isTransferring ? .blue : .gray)
                    .rotationEffect(.degrees(transferManager.isTransferring ? 360 : 0))
                    .animation(transferManager.isTransferring ? Animation.linear(duration: 1).repeatForever(autoreverses: false) : .default, value: transferManager.isTransferring)
                
                Text(transferManager.statusMessage)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                if transferManager.isTransferring {
                    ProgressView(value: transferManager.progress)
                        .frame(width: 150)
                }
            }
            .padding()
            .background(Color(NSColor.controlBackgroundColor))
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Notice"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}

struct InstructionsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("How to Transfer")
                .font(.title2)
                .fontWeight(.semibold)
            
            VStack(alignment: .leading, spacing: 10) {
                InstructionStep(number: 1, text: "Enable USB debugging on your Android device")
                InstructionStep(number: 2, text: "Connect both Android and iOS devices to your Mac via USB")
                InstructionStep(number: 3, text: "Unlock both devices and trust this computer when prompted")
                InstructionStep(number: 4, text: "Click 'Start Transfer' to begin the process")
            }
            
            HStack {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(.blue)
                Text("This process will not delete data from your Android device")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 5)
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor).opacity(0.5))
        .cornerRadius(10)
    }
}

struct InstructionStep: View {
    let number: Int
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.green)
                    .frame(width: 28, height: 28)
                Text("\(number)")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
            }
            
            Text(text)
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
        }
    }
}

struct DeviceStatusView: View {
    @EnvironmentObject var deviceManager: DeviceManager
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Device Status")
                .font(.title2)
                .fontWeight(.semibold)
            
            HStack(spacing: 50) {
                // Android Device
                DeviceCard(
                    icon: "smartphone",
                    title: "Android Device",
                    isConnected: deviceManager.androidConnected,
                    deviceInfo: deviceManager.androidDeviceInfo
                )
                
                Image(systemName: "arrow.right.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.green)
                
                // iOS Device
                DeviceCard(
                    icon: "iphone",
                    title: "iOS Device",
                    isConnected: deviceManager.iosConnected,
                    deviceInfo: deviceManager.iosDeviceInfo
                )
            }
            
            Button(action: {
                deviceManager.refreshDevices()
            }) {
                Label("Refresh Devices", systemImage: "arrow.clockwise")
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor).opacity(0.5))
        .cornerRadius(10)
    }
}

struct DeviceCard: View {
    let icon: String
    let title: String
    let isConnected: Bool
    let deviceInfo: String?
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 50))
                .foregroundColor(isConnected ? .green : .gray)
            
            Text(title)
                .font(.headline)
            
            HStack {
                Circle()
                    .fill(isConnected ? Color.green : Color.red)
                    .frame(width: 10, height: 10)
                Text(isConnected ? "Connected" : "Not Connected")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if let info = deviceInfo {
                Text(info)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(width: 200, height: 180)
        .padding()
        .background(Color(NSColor.windowBackgroundColor))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isConnected ? Color.green : Color.gray.opacity(0.3), lineWidth: 2)
        )
    }
}

struct TransferControlsView: View {
    @EnvironmentObject var deviceManager: DeviceManager
    @EnvironmentObject var transferManager: TransferManager
    @State private var showingConfirmation = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Transfer Controls")
                .font(.title2)
                .fontWeight(.semibold)
            
            if transferManager.isTransferring {
                VStack(spacing: 15) {
                    Text("Transfer in Progress")
                        .font(.headline)
                    
                    ProgressView(value: transferManager.progress) {
                        Text(transferManager.currentStep)
                            .font(.caption)
                    }
                    .frame(width: 400)
                    
                    Text("\(Int(transferManager.progress * 100))% Complete")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            } else {
                VStack(spacing: 15) {
                    Button(action: {
                        showingConfirmation = true
                    }) {
                        Label("Start Transfer", systemImage: "play.circle.fill")
                            .font(.title3)
                            .frame(width: 250, height: 50)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
                    .disabled(!deviceManager.androidConnected || !deviceManager.iosConnected)
                    .confirmationDialog("Start WhatsApp Transfer?", isPresented: $showingConfirmation) {
                        Button("Start Transfer") {
                            transferManager.startTransfer(
                                androidDevice: deviceManager.androidDeviceInfo ?? "Unknown",
                                iosDevice: deviceManager.iosDeviceInfo ?? "Unknown"
                            )
                        }
                        Button("Cancel", role: .cancel) { }
                    } message: {
                        Text("This will transfer WhatsApp data from your Android device to your iOS device. The process may take several minutes.")
                    }
                    
                    if !deviceManager.androidConnected || !deviceManager.iosConnected {
                        Text("Please connect both devices to continue")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            if let error = transferManager.errorMessage {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                }
                .padding()
                .background(Color.red.opacity(0.1))
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor).opacity(0.5))
        .cornerRadius(10)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(DeviceManager())
            .environmentObject(TransferManager())
    }
}
