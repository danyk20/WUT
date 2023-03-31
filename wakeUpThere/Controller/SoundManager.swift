//
//  SoundManager.swift
//  wakeUpThere
//
//  Created by Daniel Košč on 30/06/2022.
//

import Foundation
import AVKit

/// Singleton class for dealing with sounds in the app.
class SoundManager {

    static let instance = SoundManager()

    private var player: AVAudioPlayer?
    private var settings = Settings.defaultSettings

    /// Play default sound bell.mp3.
    public func playSound() {
        getSettings()
        guard let url = getTone() else { return }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.volume = getVolume()
            player?.numberOfLoops = -1
            player?.play()
            vibrate()
        } catch let error {
            print("Error while playing the sound. \(error.localizedDescription)")
        }
    }

    func getTone() -> URL? {
        let tone = settings.tone
        return Bundle.main.url(forResource: tone, withExtension: "wav")
    }

    func getVolume() -> Float {
        settings.volume
    }

    func getVibration() -> Bool {
        settings.isVibrationEnabled
    }

    func vibrate() {
        if getVibration() {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
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

    /// Stop playing sound.
    public func stop() {
        player?.stop()
    }
}
