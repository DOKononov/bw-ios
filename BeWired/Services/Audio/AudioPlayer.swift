//
//  AudioPlayer.swift
//  BeWired
//
//  Created by Dmitry Kononov on 26.04.23.
//

import Foundation
import AVFoundation

protocol AudioPlayerProtocol {
    func playAudio()
    func stopAudio() 
}

final class AudioPlayer: NSObject, AudioPlayerProtocol {
    
    private var audioPlayer = AVAudioPlayer()
    private let audioStorage: AudioStorageProtocol
    
    init(audioStorage: AudioStorageProtocol) {
        self.audioPlayer = AVAudioPlayer()
        self.audioStorage = audioStorage
    }
    
    func playAudio() {
        let audioURL = audioStorage.getDocumentsDirectory()
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
            audioPlayer.play()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func stopAudio() {
        audioPlayer.stop()
    }
}


extension AudioPlayer: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        //TODO: audio did finished logic 
    }
}
