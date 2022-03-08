//
//  SoundManager.swift
//  KabooGame
//
//  Created by Danil Masnaviev on 07/03/22.
//

import AVFoundation
import SwiftUI

class SoundManager {
    
    @AppStorage("music") var savedMusic = true
    static let sharedManager = SoundManager()
    var audioPlayer: AVAudioPlayer?
    var backgroundPlayer: AVAudioPlayer?
    
    func playBackground() {
        if let path = Bundle.main.path(forResource: "background_music", ofType: "mp3") {
            do {
                backgroundPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                backgroundPlayer!.numberOfLoops = -1
                backgroundPlayer!.prepareToPlay()
                backgroundPlayer?.play()
            } catch {
                print("ERROR: COULD NOT FIND AND PLAY THE SOUND FILE!")
            }
        }
    }
    
    func playSound(sound: String, type: String) {
        if let path = Bundle.main.path(forResource: sound, ofType: type) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                audioPlayer?.play()
            } catch {
                print("ERROR: COULD NOT FIND AND PLAY THE SOUND FILE!")
            }
        }
    }
}
