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
                        ForEach(self.settingsController.systemSounds, id: \.self, content: { sound in
                            Text(sound)
                        })
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
                        )
                    }
                }
                Section(header: Text("Notification Vibration")) {
                    Toggle(isOn: $isVibrationEnabled) {
                        Text("Enable Vibration")
                    }
                }
            }
            .navigationTitle("Notification Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(settingsController: SettingsController(settings: Settings.defaultSettings))
    }
}
