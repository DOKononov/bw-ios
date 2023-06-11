//
//  RecordsVM.swift
//  BeWired
//
//  Created by Dmitry Kononov on 20.05.23.
//

import Foundation

protocol RecordsVMProtocol {
    func recDidTapped()
    func playDidTapped()
    var records: [URL] {get set}
    var selectedRecordUrl: URL? {get set}
    var didReciveError: ((String) -> Void)? {get set}
    var recordsDidChanges: (()-> Void)? {get set}
    var recDidChangedStatus: ((Bool)-> Void)? {get set}
    var playDidChangedStatus: ((Bool)-> Void)? {get set}
    func deleteRecord(at url: URL)
}

final class RecordsVM: RecordsVMProtocol {
    var recDidChangedStatus: ((Bool) -> Void)?
    var playDidChangedStatus: ((Bool) -> Void)?
    var recordsDidChanges: (() -> Void)?
    private let user: User
    
    private let audioRecorder: AudioRecorder
    private let audioPlayer: AudioPlayer
    private let audioStorage: AudioStorageProtocol
    private var dateStamp = ""
    private var recInProgress = false {
        didSet {
            recDidChangedStatus?(recInProgress)
        }
    }
    private var playInProgress = false {
        didSet {
            playDidChangedStatus?(playInProgress)
        }
    }
    var selectedRecordUrl: URL?
    var records: [URL] = [] {
        didSet {
            recordsDidChanges?()
        }
    }
    var didReciveError: ((String) -> Void)?
    
    init(user: User) {
        self.user = user
        self.audioStorage = AudioStorage()
        self.audioPlayer = AudioPlayer()
        self.audioRecorder = AudioRecorder(audioStorage)
        getAllRecords()
        bind()
    }
    
    func deleteRecord(at url: URL) {
        do {
            try audioStorage.deleteAudioFile(at: url)
        } catch {
            didReciveError?(error.localizedDescription)
        }
        getAllRecords()
    }
    
    func recDidTapped() {
        if recInProgress {
            audioRecorder.stopRecording()
        } else {
            dateStamp = Date().convertedToIdString()
            do {
                try audioRecorder.startRecording(recordId: "\(user.id)\(dateStamp)")
                getAllRecords()
            } catch {
                didReciveError?(error.localizedDescription)
            }
        }
        recInProgress = !recInProgress
    }
    
    func playDidTapped() {
        guard let selectedRecordUrl else {
            didReciveError?("selectedRecordUrl Error")
            return
        }
        
        if playInProgress {
            audioPlayer.stop()
        } else {
            do {
                try audioPlayer.play(record: selectedRecordUrl)
            } catch {
                didReciveError?(error.localizedDescription)
            }
        }
        playInProgress = !playInProgress
    }
    
    func getAllRecords() {
        do {
            let audioFiles = try audioStorage.getAllAudioFiles(of: .record)
            self.records = audioFiles.sorted { $0.lastPathComponent > $1.lastPathComponent}
        } catch {
            didReciveError?(error.localizedDescription)
        }
    }
    
    private func handleResult(result: Result<Void, Error>) {
        switch result {
        case .success():
            break
        case .failure(let error):
            didReciveError?(error.localizedDescription)
            return
        }
    }
    
    private func bind() {
        audioPlayer.playDidFinished = { [weak self] in
            self?.playInProgress = false
        }
    }
}
