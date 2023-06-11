//
//  AudioRecorder.swift
//  BeWired
//
//  Created by Dmitry Kononov on 26.04.23.
//

import Foundation
import AVFoundation

protocol AudioRecorderProtocol {
    func startRecording(recordId: String) throws
    func stopRecording()
}

final class AudioRecorder: AudioRecorderProtocol {
    
    private var audioRecorder: AVAudioRecorder
    private let audioStorage: AudioStorageProtocol
    private var audioSession: AVAudioSession
    private let prefix = RecordType.record.rawValue

    
    init(_ audioStorage: AudioStorageProtocol) {
        self.audioRecorder = AVAudioRecorder()
        self.audioSession = AVAudioSession.sharedInstance()
        self.audioStorage = audioStorage
    }
    
    
    func startRecording(recordId: String) throws {
        try audioSession.setCategory(.playAndRecord, mode: .default)
        try audioSession.setActive(true)
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        let directoryURL = audioStorage.getDocumentsDirectory(for: prefix+recordId)
        
        audioRecorder = try AVAudioRecorder(url: directoryURL, settings: settings)
        audioRecorder.record()
    }
    
    func stopRecording() {
        audioRecorder.stop()
    }
    
}
