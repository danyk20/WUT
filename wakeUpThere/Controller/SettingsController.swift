//
//  SettingsController.swift
//  wakeUpThere
//
//  Created by Oliver Rainoch on 24.03.2023.
//

import Foundation
import UserNotifications

class SettingsController: ObservableObject {

    var settings: Settings = Settings.defaultSettings
    var systemSounds: [String]

    init() {
        self.systemSounds = []
        self.systemSounds = getSounds()
        self.getSettings()
    }

    func saveSettings() {
        let defaults = UserDefaults.standard
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(settings) {
            defaults.set(encoded, forKey: "MySettings")
        }
    }

    func getSettings() {
        let defaults = UserDefaults.standard
        if let savedSettings = defaults.object(forKey: "MySettings") as? Data {
            let decoder = JSONDecoder()
            if let loadedSettings = try? decoder.decode(Settings.self, from: savedSettings) {
                settings = loadedSettings
            }
        }
    }

    private func getSounds() -> [String] {
        guard let path = Bundle.main.resourcePath else {
            return []
        }

        let fileManager = FileManager.default
        let files = try? fileManager.contentsOfDirectory(atPath: path)

        guard let allFiles = files else {
            return []
        }

        let wavFiles = allFiles.filter { $0.hasSuffix(".wav") }.map { URL(fileURLWithPath: $0).deletingPathExtension().lastPathComponent }

        return wavFiles
    }
}
