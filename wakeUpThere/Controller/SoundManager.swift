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

    /// Play default sound bell.mp3.
    public func playSound() {
        let generator = UINotificationFeedbackGenerator()
        guard let url = Bundle.main.url(forResource: "bell", withExtension: ".mp3") else { return }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = -1
            player?.play()
            generator.notificationOccurred(.success)
        } catch let error {
            print("Error while playing the sound. \(error.localizedDescription)")
        }
    }

    /// Stop playing sound.
    public func stop() {
        player?.stop()
    }
}
