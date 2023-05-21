//
//  AudioRecorder.swift
//  BeWired
//
//  Created by Dmitry Kononov on 26.04.23.
//

import Foundation
import AVFoundation

protocol AudioRecorderProtocol {
    func startRecording(recordId: String, completion: @escaping AudioResult<Void>)
    func stopRecording()
}

final class AudioRecorder: AudioRecorderProtocol {
    
    private var audioRecorder: AVAudioRecorder
    private let audioStorage: AudioStorageProtocol
    private var audioSession: AVAudioSession
    
    init(_ audioStorage: AudioStorageProtocol) {
        self.audioRecorder = AVAudioRecorder()
        self.audioSession = AVAudioSession.sharedInstance()
        self.audioStorage = audioStorage
    }
    
    
    func startRecording(recordId: String, completion: @escaping AudioResult<Void>) {
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)
        } catch {
            completion(.failure(error))
            return
        }
        let settings = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        let directoryURL = audioStorage.getDocumentsDirectory(for: recordId)
        do {
            audioRecorder = try AVAudioRecorder(url: directoryURL, settings: settings)
            audioRecorder.record()
        } catch {
            completion(.failure(error))
            return
        }
        completion(.success(()))
    }
    
    func stopRecording() {
        audioRecorder.stop()
    }
    
}
