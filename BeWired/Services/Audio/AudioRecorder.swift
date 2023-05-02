//
//  AudioRecorder.swift
//  BeWired
//
//  Created by Dmitry Kononov on 26.04.23.
//

import Foundation
import AVFoundation

protocol AudioRecorderProtocol {
    func startRecording()
    func stopRecording()
}

final class AudioRecorder: AudioRecorderProtocol {
    
    private var audioRecorder: AVAudioRecorder
    private let audioStorage: AudioStorageProtocol
    
    init(audioStorage: AudioStorageProtocol) {
        self.audioRecorder = AVAudioRecorder()
        self.audioStorage = audioStorage
    }
    
    
    func startRecording() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)
            
            let settings = [
                AVFormatIDKey: Int(kAudioFormatLinearPCM),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            let audioURL = audioStorage.getDocumentsDirectory()
            audioRecorder = try AVAudioRecorder(url: audioURL, settings: settings)
            audioRecorder.record()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func stopRecording() {
        audioRecorder.stop()
    }
    
}
