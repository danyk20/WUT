//
//  SettingsController.swift
//  wakeUpThere
//
//  Created by Oliver Rainoch on 24.03.2023.
//

import Foundation
import UserNotifications

class SettingsController: ObservableObject {

    @Published var settings: Settings
    var systemSounds: [String]

    init(settings: Settings) {
        self.settings = settings
        self.systemSounds = []
        self.systemSounds = getSounds()
    }

    func saveSettings() {
        // Implement your code to save the settings here
    }

    func getSounds() -> [String] {
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
