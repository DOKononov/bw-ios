//
//  AudioPlayer.swift
//  BeWired
//
//  Created by Dmitry Kononov on 26.04.23.
//

import Foundation
import AVFoundation

protocol AudioPlayerProtocol {
    func play(record url: URL) throws
    func stop()
    var playDidFinished: (()-> Void)? {get set}
}

final class AudioPlayer: NSObject, AudioPlayerProtocol {
    var playDidFinished: (() -> Void)?
    
    private var audioPlayer: AVAudioPlayer
    
    override init() {
        self.audioPlayer = AVAudioPlayer()
        super.init()
    }
    
    func play(record url: URL) throws {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.delegate = self
            audioPlayer.play()
    }
    
    func stop() {
        audioPlayer.stop()
    }
    
}


extension AudioPlayer: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playDidFinished?()
    }
    
    //    func play(record id: String, completion: @escaping AudioResult<Void>) {
    //        let audioURL = audioStorage.getDocumentsDirectory(for: id)
    //        do {
    //            audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
    //            audioPlayer.delegate = self
    //            audioPlayer.play()
    //            completion(.success(()))
    //            return
    //        } catch {
    //            completion(.failure(error))
    //            return
    //        }
    //    }
    
    //    func pause() {
    //        audioPlayer.pause()
    //    }
    
    
}
