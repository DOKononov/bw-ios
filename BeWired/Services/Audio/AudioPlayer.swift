//
//  AudioPlayer.swift
//  BeWired
//
//  Created by Dmitry Kononov on 26.04.23.
//

import Foundation
import AVFoundation

protocol AudioPlayerProtocol {
    func play(record id: String, completion: @escaping AudioResult<Void>)
    func play(record url: URL, completion: @escaping AudioResult<Void>)
    func stop()
    func pause()
    var playDidFinished: (()-> Void)? {get set}
}

final class AudioPlayer: NSObject, AudioPlayerProtocol {
    var playDidFinished: (() -> Void)?
    
    private var audioPlayer: AVAudioPlayer
    private let audioStorage: AudioStorageProtocol
    weak var delegate: AVAudioPlayerDelegate?
    
    init(_ audioStorage: AudioStorageProtocol) {
        self.audioPlayer = AVAudioPlayer()
        self.audioStorage = audioStorage
        super.init()
    }
    
    func play(record id: String, completion: @escaping AudioResult<Void>) {
        let audioURL = audioStorage.getDocumentsDirectory(for: id)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
            audioPlayer.delegate = self
            audioPlayer.play()
            completion(.success(()))
            return
        } catch {
            completion(.failure(error))
            return
        }
    }
    
    func play(record url: URL, completion: @escaping AudioResult<Void>) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.delegate = self
            audioPlayer.play()
            completion(.success(()))
            return
        } catch {
            completion(.failure(error))
            return
        }
    }
    
    func stop() {
        audioPlayer.stop()
    }
    
    func pause() {
        audioPlayer.pause()
    }
}


extension AudioPlayer: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        //TODO: audio did finished logic
        playDidFinished?()
    }
    
}
