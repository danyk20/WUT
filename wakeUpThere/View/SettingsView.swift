//
//  SettingsView.swift
//  wakeUpThere
//
//  Created by Oliver Rainoch on 23.03.2023.
//

import SwiftUI

struct SettingsView: View {
    // Create state variables for selected tone, volume, and vibration
    @State private var tone = "Default"
    @State private var volume = 50.0
    @State private var isVibrationEnabled = true
    @State private var isEditing = false
    @ObservedObject var settingsController: SettingsController

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Notification Tone")) {
                    Picker(selection: $tone, label: Text("Select Tone")) {
                        ForEach(self.settingsController.systemSounds, id: \.self) { sound in
                            Text(sound)
                        }
                    }
                    .onChange(of: tone) { selectedTone in
                        self.settingsController.settings.tone = selectedTone
                        self.settingsController.saveSettings()
                    }
                }
                Section(header: Text("Notification Volume")) {
                    HStack {
                        Text("Volume")
                        Slider(
                            value: $volume,
                            in: 0...100,
                            onEditingChanged: { editing in
                                isEditing = editing
                            }
                        ).onChange(of: volume) { volume in
                            self.settingsController.settings.volume = Float(volume)
                            self.settingsController.saveSettings()
                        }
                    }
                }
                Section(header: Text("Notification Vibration")) {
                    Toggle(isOn: $isVibrationEnabled) {
                        Text("Enable Vibration")
                    }.onChange(of: isVibrationEnabled) { isEnabled in
                        self.settingsController.settings.isVibrationEnabled = isEnabled
                        self.settingsController.saveSettings()
                    }
                }
            }
            .navigationTitle("Notification Settings")
            .onAppear {
                self.settingsController.getSettings()
                self.tone = settingsController.settings.tone
                self.volume = Double(settingsController.settings.volume)
                self.isVibrationEnabled = settingsController.settings.isVibrationEnabled
             }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(settingsController: SettingsController())
    }
}
