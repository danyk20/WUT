//
//  Settings.swift
//  wakeUpThere
//
//  Created by Oliver Rainoch on 24.03.2023.
//

import Foundation
import AVFoundation

struct Settings: Codable {
    var tone: String
    var volume: Float
    var isVibrationEnabled: Bool

    static let defaultSettings = Settings(
        tone: "bells",
        volume: AVAudioSession.sharedInstance().outputVolume,
        isVibrationEnabled: true
    )
}
